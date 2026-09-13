package mx.unam.ciencias.nipgg.puellagame.repository;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertInstanceOf;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

/**
 * Verifica el contrato CRUD, el formato CSV y la sincronización del
 * repositorio sin depender de los modelos de otras capas.
 */
final class CsvRepositoryTest {

    /** Directorio aislado que JUnit elimina después de cada prueba. */
    @TempDir
    private Path temporaryDirectory;

    /**
     * Comprueba el ciclo CRUD completo y la inmutabilidad de los resultados.
     */
    @Test
    void performsCompleteCrudCycle() {
        var repository = repository("entities.csv");
        var original = new TestEntity(1, "Mami", "registro inicial");
        var updated = new TestEntity(1, "Mami Tomoe", "actualizado");

        assertTrue(repository.findAll().isEmpty());
        assertEquals(original, repository.create(original));
        assertEquals(original, repository.findById(1).orElseThrow());
        assertThrows(UnsupportedOperationException.class,
                () -> repository.findAll().add(updated));
        assertEquals(updated, repository.update(updated));
        assertEquals(List.of(updated), repository.findAll());
        assertTrue(repository.deleteById(1));
        assertFalse(repository.deleteById(1));
        assertTrue(repository.findById(1).isEmpty());
    }

    /**
     * Verifica que altas repetidas y actualizaciones inexistentes sean
     * rechazadas con mensajes utilizables por la interfaz.
     */
    @Test
    void rejectsDuplicateAndMissingKeys() {
        var repository = repository("keys.csv");
        repository.create(new TestEntity(7, "Homura", "primero"));

        var duplicate = assertThrows(CsvRepositoryException.class,
                () -> repository.create(
                        new TestEntity(7, "Madoka", "repetido")));
        var missing = assertThrows(CsvRepositoryException.class,
                () -> repository.update(
                        new TestEntity(8, "Sayaka", "inexistente")));

        assertTrue(duplicate.getMessage().contains("7"));
        assertTrue(missing.getMessage().contains("8"));
    }

    /**
     * Comprueba que comas, comillas y saltos de línea sobrevivan un viaje de
     * escritura y lectura.
     *
     * @throws IOException si la inspección directa del archivo falla
     */
    @Test
    void preservesSpecialCsvCharacters() throws IOException {
        var path = temporaryDirectory.resolve("special.csv");
        var repository = new CsvRepository<>(path, schema());
        var entity = new TestEntity(2, "Kyoko, Sakura",
                "Dijo \"hola\"\r\ny continuó");

        repository.create(entity);

        assertEquals(entity, repository.findById(2).orElseThrow());
        var raw = Files.readString(path, StandardCharsets.UTF_8);
        assertTrue(raw.contains("\"Kyoko, Sakura\""));
        assertTrue(raw.contains("\"Dijo \"\"hola\"\"\r\ny continuó\""));
    }

    /**
     * Verifica que un encabezado distinto no sea sobrescrito silenciosamente.
     *
     * @throws IOException si no se puede preparar el archivo de prueba
     */
    @Test
    void rejectsUnexpectedHeader() throws IOException {
        var path = temporaryDirectory.resolve("header.csv");
        Files.writeString(path, "other,name,note\n1,A,B\n",
                StandardCharsets.UTF_8);

        var exception = assertThrows(CsvRepositoryException.class,
                () -> new CsvRepository<>(path, schema()).findAll());

        assertTrue(exception.getMessage().contains("encabezado"));
    }

    /**
     * Verifica el rechazo de comillas sin cerrar y filas con columnas faltantes.
     *
     * @throws IOException si no se pueden preparar los archivos de prueba
     */
    @Test
    void rejectsMalformedFiles() throws IOException {
        var quotesPath = temporaryDirectory.resolve("quotes.csv");
        Files.writeString(quotesPath,
                "id,name,note\n1,Nombre,\"texto sin cierre",
                StandardCharsets.UTF_8);
        var columnsPath = temporaryDirectory.resolve("columns.csv");
        Files.writeString(columnsPath, "id,name,note\n1,Nombre\n",
                StandardCharsets.UTF_8);

        var quotes = assertThrows(CsvRepositoryException.class,
                () -> new CsvRepository<>(quotesPath, schema()).findAll());
        var columns = assertThrows(CsvRepositoryException.class,
                () -> new CsvRepository<>(columnsPath, schema()).findAll());

        assertTrue(quotes.getMessage().contains("entrecomillado"));
        assertTrue(columns.getMessage().contains("columnas"));
    }

    /**
     * Verifica que las llaves duplicadas introducidas externamente se detecten.
     *
     * @throws IOException si no se puede preparar el archivo de prueba
     */
    @Test
    void rejectsDuplicateKeysAlreadyInFile() throws IOException {
        var path = temporaryDirectory.resolve("duplicates.csv");
        Files.writeString(path,
                "id,name,note\n1,Uno,A\n1,Otro,B\n",
                StandardCharsets.UTF_8);

        var exception = assertThrows(CsvRepositoryException.class,
                () -> new CsvRepository<>(path, schema()).findAll());

        assertTrue(exception.getMessage().contains("repetida 1"));
    }

    /**
     * Ejecuta operaciones sobre tres archivos al mismo tiempo con un ejecutor
     * dedicado.
     */
    @Test
    void executesIndependentRepositoriesInParallel() {
        try (var executor = Executors.newFixedThreadPool(3)) {
            var first = repository("first.csv", executor);
            var second = repository("second.csv", executor);
            var third = repository("third.csv", executor);

            CompletableFuture.allOf(
                    first.createAsync(new TestEntity(1, "A", "uno")),
                    second.createAsync(new TestEntity(2, "B", "dos")),
                    third.createAsync(new TestEntity(3, "C", "tres")))
                    .join();

            assertEquals(1, first.findAllAsync().join().size());
            assertEquals(1, second.findAllAsync().join().size());
            assertEquals(1, third.findAllAsync().join().size());
        }
    }

    /**
     * Comprueba que instancias diferentes sobre la misma ruta no pierdan altas
     * cuando muchas tareas escriben simultáneamente.
     */
    @Test
    void serializesConcurrentWritesToSamePath() {
        try (var executor = Executors.newFixedThreadPool(8)) {
            var path = temporaryDirectory.resolve("shared.csv");
            var first = new CsvRepository<>(path, schema(), executor);
            var second = new CsvRepository<>(path, schema(), executor);

            var tasks = IntStream.rangeClosed(1, 80)
                    .mapToObj(id -> (id & 1) == 0
                            ? first.createAsync(new TestEntity(
                                    id, "Entidad " + id, "par"))
                            : second.createAsync(new TestEntity(
                                    id, "Entidad " + id, "impar")))
                    .toArray(CompletableFuture<?>[]::new);
            CompletableFuture.allOf(tasks).join();

            var entities = first.findAll();
            assertEquals(80, entities.size());
            assertEquals(80, entities.stream()
                    .map(TestEntity::id).distinct().count());
        }
    }

    /**
     * Comprueba que una excepción de persistencia conserve su tipo como causa
     * de una tarea asíncrona fallida.
     */
    @Test
    void propagatesRepositoryFailuresFromAsyncOperations() {
        var repository = repository("async-error.csv");
        repository.create(new TestEntity(1, "A", "original"));

        var completion = assertThrows(CompletionException.class,
                () -> repository.createAsync(
                        new TestEntity(1, "B", "duplicado")).join());

        assertInstanceOf(CsvRepositoryException.class,
                completion.getCause());
    }

    /**
     * Comprueba las validaciones estructurales del esquema.
     */
    @Test
    void validatesSchemaDefinitionAndEncodedWidth() {
        assertThrows(IllegalArgumentException.class,
                () -> new CsvSchema<TestEntity, Integer>(
                        List.of(), TestEntity::id,
                        entity -> List.of(), fields -> null));
        assertThrows(IllegalArgumentException.class,
                () -> new CsvSchema<TestEntity, Integer>(
                        List.of("id", "id"), TestEntity::id,
                        entity -> List.of(), fields -> null));

        var invalidWidth = new CsvSchema<TestEntity, Integer>(
                List.of("id", "name"), TestEntity::id,
                entity -> List.of(Integer.toString(entity.id())),
                fields -> new TestEntity(1, "A", "B"));
        assertThrows(CsvRepositoryException.class,
                () -> invalidWidth.encode(new TestEntity(1, "A", "B")));
    }

    /**
     * Crea un repositorio de prueba con el ejecutor predeterminado.
     *
     * @param fileName nombre del archivo temporal
     * @return repositorio configurado
     */
    private CsvRepository<TestEntity, Integer> repository(String fileName) {
        return new CsvRepository<>(temporaryDirectory.resolve(fileName),
                schema());
    }

    /**
     * Crea un repositorio de prueba con un ejecutor explícito.
     *
     * @param fileName nombre del archivo temporal
     * @param executor ejecutor de tareas asíncronas
     * @return repositorio configurado
     */
    private CsvRepository<TestEntity, Integer> repository(
            String fileName, java.util.concurrent.Executor executor) {
        return new CsvRepository<>(temporaryDirectory.resolve(fileName),
                schema(), executor);
    }

    /**
     * Define las funciones puras de conversión para la entidad de prueba.
     *
     * @return esquema de tres columnas
     */
    private CsvSchema<TestEntity, Integer> schema() {
        return new CsvSchema<>(
                List.of("id", "name", "note"),
                TestEntity::id,
                entity -> List.of(Integer.toString(entity.id()),
                        entity.name(), entity.note()),
                fields -> new TestEntity(Integer.parseInt(fields.get(0)),
                        fields.get(1), fields.get(2)));
    }

    /**
     * Entidad inmutable utilizada exclusivamente por las pruebas.
     *
     * @param id llave única
     * @param name nombre descriptivo
     * @param note texto que permite probar escapes CSV
     */
    private record TestEntity(int id, String name, String note) {
    }
}
