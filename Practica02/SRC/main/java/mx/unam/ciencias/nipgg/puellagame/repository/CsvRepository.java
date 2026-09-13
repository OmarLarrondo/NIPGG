package mx.unam.ciencias.nipgg.puellagame.repository;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.function.Supplier;
import java.util.stream.Stream;

/**
 * Repositorio CRUD que conserva entidades en un archivo CSV UTF-8.
 *
 * <p>Las instancias que apuntan a la misma ruta comparten un bloqueo justo.
 * Las lecturas pueden ejecutarse simultáneamente, mientras que cada mutación
 * mantiene un bloqueo exclusivo desde la lectura del estado previo hasta el
 * reemplazo atómico del archivo.</p>
 *
 * @param <T> tipo de entidad almacenada
 * @param <K> tipo de su llave única
 * @since 1.0
 */
public final class CsvRepository<T, K> implements CrudRepository<T, K> {

    /** Bloqueos compartidos por ruta absoluta normalizada. */
    private static final ConcurrentHashMap<Path, ReentrantReadWriteLock> LOCKS =
            new ConcurrentHashMap<>();

    /** Archivo que contiene las entidades. */
    private final Path path;

    /** Reglas funcionales de conversión. */
    private final CsvSchema<T, K> schema;

    /** Ejecutor utilizado por las operaciones asíncronas. */
    private final Executor executor;

    /** Bloqueo compartido por todas las instancias de esta ruta. */
    private final ReentrantReadWriteLock lock;

    /**
     * Construye un repositorio que usa el grupo común de trabajo paralelo.
     *
     * @param path ubicación del archivo CSV
     * @param schema reglas de conversión de la entidad
     */
    public CsvRepository(Path path, CsvSchema<T, K> schema) {
        this(path, schema, ForkJoinPool.commonPool());
    }

    /**
     * Construye un repositorio con un ejecutor configurable.
     *
     * @param path ubicación del archivo CSV
     * @param schema reglas de conversión de la entidad
     * @param executor ejecutor para las operaciones asíncronas
     */
    public CsvRepository(Path path, CsvSchema<T, K> schema, Executor executor) {
        this.path = Objects.requireNonNull(path,
                "La ruta no puede ser nula").toAbsolutePath().normalize();
        this.schema = Objects.requireNonNull(schema,
                "El esquema no puede ser nulo");
        this.executor = Objects.requireNonNull(executor,
                "El ejecutor no puede ser nulo");
        this.lock = LOCKS.computeIfAbsent(this.path,
                ignored -> new ReentrantReadWriteLock(true));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public T create(T entity) {
        var key = schema.keyOf(entity);
        return withWriteLock(() -> {
            var entities = readEntities();
            if (entities.stream().map(schema::keyOf)
                    .anyMatch(key::equals)) {
                throw new CsvRepositoryException(
                        "Ya existe una entidad con la llave " + key);
            }
            var updated = Stream.concat(entities.stream(), Stream.of(entity))
                    .toList();
            writeEntities(updated);
            return entity;
        });
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Optional<T> findById(K key) {
        Objects.requireNonNull(key, "La llave no puede ser nula");
        return withReadLock(() -> readEntities().stream()
                .filter(entity -> key.equals(schema.keyOf(entity)))
                .findFirst());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<T> findAll() {
        return withReadLock(this::readEntities);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public T update(T entity) {
        var key = schema.keyOf(entity);
        return withWriteLock(() -> {
            var entities = readEntities();
            if (entities.stream().map(schema::keyOf)
                    .noneMatch(key::equals)) {
                throw new CsvRepositoryException(
                        "No existe una entidad con la llave " + key);
            }
            var updated = entities.stream()
                    .map(current -> key.equals(schema.keyOf(current))
                            ? entity : current)
                    .toList();
            writeEntities(updated);
            return entity;
        });
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public boolean deleteById(K key) {
        Objects.requireNonNull(key, "La llave no puede ser nula");
        return withWriteLock(() -> {
            var entities = readEntities();
            var updated = entities.stream()
                    .filter(entity -> !key.equals(schema.keyOf(entity)))
                    .toList();
            if (updated.size() == entities.size()) {
                return false;
            }
            writeEntities(updated);
            return true;
        });
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CompletableFuture<T> createAsync(T entity) {
        return CompletableFuture.supplyAsync(() -> create(entity), executor);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CompletableFuture<Optional<T>> findByIdAsync(K key) {
        return CompletableFuture.supplyAsync(() -> findById(key), executor);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CompletableFuture<List<T>> findAllAsync() {
        return CompletableFuture.supplyAsync(this::findAll, executor);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CompletableFuture<T> updateAsync(T entity) {
        return CompletableFuture.supplyAsync(() -> update(entity), executor);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public CompletableFuture<Boolean> deleteByIdAsync(K key) {
        return CompletableFuture.supplyAsync(() -> deleteById(key), executor);
    }

    /**
     * Lee y valida la instantánea actual del archivo.
     *
     * @return entidades inmutables en orden de aparición
     */
    private List<T> readEntities() {
        if (Files.notExists(path)) {
            return List.of();
        }
        try {
            var content = Files.readString(path, StandardCharsets.UTF_8);
            var records = CsvFormat.parse(content);
            if (records.isEmpty()) {
                throw new CsvRepositoryException(
                        "El archivo CSV está vacío: " + path);
            }
            if (!records.getFirst().equals(schema.header())) {
                throw new CsvRepositoryException(
                        "El encabezado del archivo no coincide con el esquema: "
                                + path);
            }
            var entities = records.stream()
                    .skip(1)
                    .map(schema::decode)
                    .toList();
            validateUniqueKeys(entities);
            return entities;
        } catch (IOException exception) {
            throw new CsvRepositoryException(
                    "No fue posible leer el archivo CSV " + path, exception);
        }
    }

    /**
     * Verifica que el archivo no contenga llaves repetidas.
     *
     * @param entities entidades recién leídas
     */
    private void validateUniqueKeys(List<T> entities) {
        var keys = new HashSet<K>();
        entities.stream().map(schema::keyOf).forEach(key -> {
            if (!keys.add(key)) {
                throw new CsvRepositoryException(
                        "El archivo contiene la llave repetida " + key);
            }
        });
    }

    /**
     * Escribe una instantánea completa mediante reemplazo atómico.
     *
     * @param entities entidades que formarán el nuevo archivo
     */
    private void writeEntities(List<T> entities) {
        Path temporary = null;
        try {
            var parent = Optional.ofNullable(path.getParent())
                    .orElseThrow(() -> new CsvRepositoryException(
                            "La ruta CSV debe tener un directorio padre"));
            Files.createDirectories(parent);
            temporary = Files.createTempFile(parent,
                    path.getFileName().toString(), ".tmp");

            var records = new ArrayList<List<String>>(entities.size() + 1);
            records.add(schema.header());
            entities.stream().map(schema::encode).forEach(records::add);
            Files.writeString(temporary, CsvFormat.write(records),
                    StandardCharsets.UTF_8);
            replaceAtomically(temporary);
            temporary = null;
        } catch (IOException exception) {
            throw new CsvRepositoryException(
                    "No fue posible escribir el archivo CSV " + path,
                    exception);
        } finally {
            deleteTemporary(temporary);
        }
    }

    /**
     * Reemplaza el archivo final y usa una alternativa segura si el sistema de
     * archivos no admite movimientos atómicos.
     *
     * @param temporary archivo temporal completamente escrito
     * @throws IOException si ninguna modalidad de reemplazo funciona
     */
    private void replaceAtomically(Path temporary) throws IOException {
        try {
            Files.move(temporary, path, StandardCopyOption.ATOMIC_MOVE,
                    StandardCopyOption.REPLACE_EXISTING);
        } catch (AtomicMoveNotSupportedException exception) {
            Files.move(temporary, path, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    /**
     * Elimina un temporal sobrante sin ocultar la excepción principal.
     *
     * @param temporary ruta temporal, o {@code null} si ya fue movida
     */
    private void deleteTemporary(Path temporary) {
        if (temporary == null) {
            return;
        }
        try {
            Files.deleteIfExists(temporary);
        } catch (IOException ignored) {
            // La operación principal ya falló; el temporal conserva datos
            // recuperables y no debe reemplazar la causa original.
        }
    }

    /**
     * Ejecuta una acción mientras mantiene el bloqueo compartido de lectura.
     *
     * @param action acción que se desea proteger
     * @param <R> tipo del resultado
     * @return resultado de la acción
     */
    private <R> R withReadLock(Supplier<R> action) {
        var readLock = lock.readLock();
        readLock.lock();
        try {
            return action.get();
        } finally {
            readLock.unlock();
        }
    }

    /**
     * Ejecuta una acción mientras mantiene el bloqueo exclusivo de escritura.
     *
     * @param action acción que se desea proteger
     * @param <R> tipo del resultado
     * @return resultado de la acción
     */
    private <R> R withWriteLock(Supplier<R> action) {
        var writeLock = lock.writeLock();
        writeLock.lock();
        try {
            return action.get();
        } finally {
            writeLock.unlock();
        }
    }
}
