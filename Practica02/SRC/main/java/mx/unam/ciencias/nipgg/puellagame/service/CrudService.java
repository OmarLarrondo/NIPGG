package mx.unam.ciencias.nipgg.puellagame.service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepositoryException;

/**
 * Define las operaciones de negocio disponibles para una entidad.
 *
 * @param <T> tipo de entidad gestionada
 * @param <K> tipo de la llave única de la entidad
 * @since 1.0
 */
public interface CrudService<T, K> {

    /**
     * Crea una nueva entidad tras validar sus datos.
     *
     * @param entity entidad a crear
     * @return la entidad creada
     * @throws ValidationException si los datos no son válidos
     * @throws CsvRepositoryException si no se puede persistir
     */
    T crear(T entity) throws ValidationException;

    /**
     * Busca una entidad por su llave.
     *
     * @param key llave a buscar
     * @return la entidad encontrada
     * @throws ValidationException si la llave es inválida
     * @throws EntityNotFoundException si no existe
     * @throws CsvRepositoryException si no se puede leer
     */
    T buscarPorId(K key) throws ValidationException, EntityNotFoundException;

    /**
     * Lista todas las entidades.
     *
     * @return lista de entidades
     * @throws CsvRepositoryException si no se puede leer
     */
    List<T> listar(); 

    /**
     * Actualiza una entidad existente.
     *
     * @param entity entidad con los nuevos datos
     * @return la entidad actualizada
     * @throws ValidationException si los datos son inválidos
     * @throws EntityNotFoundException si la entidad no existe
     * @throws CsvRepositoryException si no se puede persistir
     */
    T actualizar(T entity) throws ValidationException, EntityNotFoundException;

    /**
     * Elimina una entidad por su llave.
     *
     * @param key llave de la entidad a eliminar
     * @throws ValidationException si la llave es inválida
     * @throws EntityNotFoundException si la entidad no existe
     * @throws CsvRepositoryException si no se puede persistir
     */
    void eliminar(K key) throws ValidationException, EntityNotFoundException;

    // Versiones asíncronas 
    CompletableFuture<T> crearAsync(T entity);
    CompletableFuture<T> buscarPorIdAsync(K key);
    CompletableFuture<List<T>> listarAsync();
    CompletableFuture<T> actualizarAsync(T entity);
    CompletableFuture<Void> eliminarAsync(K key);
}