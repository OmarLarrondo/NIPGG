package mx.unam.ciencias.nipgg.puellagame.repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

/**
 * Define las operaciones de persistencia disponibles para una entidad.
 *
 * @param <T> tipo de entidad almacenada
 * @param <K> tipo de la llave única de la entidad
 * @since 1.0
 */
public interface CrudRepository<T, K> {

    /**
     * Agrega una entidad nueva.
     *
     * @param entity entidad que se desea almacenar
     * @return la entidad almacenada
     * @throws CsvRepositoryException si la llave ya existe o no se puede
     *         persistir la entidad
     */
    T create(T entity);

    /**
     * Busca una entidad por su llave.
     *
     * @param key llave que se desea localizar
     * @return la entidad, o un valor vacío si no existe
     * @throws CsvRepositoryException si el archivo no se puede leer
     */
    Optional<T> findById(K key);

    /**
     * Recupera una instantánea inmutable de todas las entidades.
     *
     * @return entidades almacenadas en el orden del archivo
     * @throws CsvRepositoryException si el archivo no se puede leer
     */
    List<T> findAll();

    /**
     * Sustituye la entidad que tenga la misma llave.
     *
     * @param entity nueva representación de la entidad
     * @return la entidad actualizada
     * @throws CsvRepositoryException si la llave no existe o no se puede
     *         persistir el cambio
     */
    T update(T entity);

    /**
     * Elimina una entidad por su llave.
     *
     * @param key llave que se desea eliminar
     * @return {@code true} si se eliminó una entidad; {@code false} si no
     *         existía
     * @throws CsvRepositoryException si el archivo no se puede actualizar
     */
    boolean deleteById(K key);

    /**
     * Ejecuta {@link #create(Object)} sin bloquear al invocador.
     *
     * @param entity entidad que se desea almacenar
     * @return tarea que producirá la entidad almacenada
     */
    CompletableFuture<T> createAsync(T entity);

    /**
     * Ejecuta {@link #findById(Object)} sin bloquear al invocador.
     *
     * @param key llave que se desea localizar
     * @return tarea que producirá el resultado de la búsqueda
     */
    CompletableFuture<Optional<T>> findByIdAsync(K key);

    /**
     * Ejecuta {@link #findAll()} sin bloquear al invocador.
     *
     * @return tarea que producirá una instantánea inmutable
     */
    CompletableFuture<List<T>> findAllAsync();

    /**
     * Ejecuta {@link #update(Object)} sin bloquear al invocador.
     *
     * @param entity nueva representación de la entidad
     * @return tarea que producirá la entidad actualizada
     */
    CompletableFuture<T> updateAsync(T entity);

    /**
     * Ejecuta {@link #deleteById(Object)} sin bloquear al invocador.
     *
     * @param key llave que se desea eliminar
     * @return tarea que indicará si la entidad fue eliminada
     */
    CompletableFuture<Boolean> deleteByIdAsync(K key);
}
