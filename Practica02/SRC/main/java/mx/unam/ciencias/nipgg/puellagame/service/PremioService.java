package mx.unam.ciencias.nipgg.puellagame.service;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.model.Premio;
import mx.unam.ciencias.nipgg.puellagame.repository.CrudRepository;
import mx.unam.ciencias.nipgg.puellagame.validation.Validator;

/**
 * Servicio de negocio para la entidad {@link Premio}.
 *
 * <p>Orquesta las operaciones CRUD sobre premios aplicando
 * validaciones de datos antes de delegar en el repositorio CSV.
 *
 * @since 1.0
 */
public class PremioService implements CrudService<Premio, Integer> {

    private final CrudRepository<Premio, Integer> repository;

    /**
     * Crea el servicio de premios.
     *
     * @param repository repositorio CSV de premios
     */
    public PremioService(CrudRepository<Premio, Integer> repository) {
        this.repository = Objects.requireNonNull(repository,
                "El repositorio no puede ser nulo");
    }

    // ------------------------------------------------------------------
    // Operaciones síncronas
    // ------------------------------------------------------------------

    @Override
    public Premio crear(Premio premio) throws ValidationException {
        validarPremio(premio);

        //No hay Id's duplicados
        if (repository.findById(premio.getId()).isPresent()) {
            throw new ValidationException(
                    "Ya existe un premio con el ID " + premio.getId());
        }

        return repository.create(premio);
    }

    @Override
    public Premio buscarPorId(Integer id)
            throws ValidationException, EntityNotFoundException {
        validarLlave(id);
        return repository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        "No existe un premio con el ID " + id));
    }

    @Override
    public List<Premio> listar() {
        return repository.findAll();
    }

    @Override
    public Premio actualizar(Premio premio)
            throws ValidationException, EntityNotFoundException {
        validarPremio(premio);

        //Un premio debe existir para actualizarse
        if (repository.findById(premio.getId()).isEmpty()) {
            throw new EntityNotFoundException(
                    "No se puede actualizar: no existe el premio con ID "
                            + premio.getId());
        }

        return repository.update(premio);
    }

    @Override
    public void eliminar(Integer id)
            throws ValidationException, EntityNotFoundException {
        validarLlave(id);

        //Solo se pueden eliminar premios existentes
        if (!repository.deleteById(id)) {
            throw new EntityNotFoundException(
                    "No se puede eliminar: no existe el premio con ID " + id);
        }
    }

    // ------------------------------------------------------------------
    // Operaciones asíncronas
    // ------------------------------------------------------------------

    @Override
    public CompletableFuture<Premio> crearAsync(Premio premio) {
        try {
            validarPremio(premio);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(premio.getId())
                .thenCompose(existente -> {
                    if (existente.isPresent()) {
                        return CompletableFuture.failedFuture(
                                new ValidationException(
                                        "Ya existe un premio con el ID "
                                                + premio.getId()));
                    }
                    return repository.createAsync(premio);
                });
    }

    @Override
    public CompletableFuture<Premio> buscarPorIdAsync(Integer id) {
        try {
            validarLlave(id);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(id)
                .thenApply(opt -> {
                    if (opt.isEmpty()) {
                        throw new CompletionException(
                                new EntityNotFoundException(
                                        "No existe un premio con el ID " + id));
                    }
                    return opt.get();
                });
    }

    @Override
    public CompletableFuture<List<Premio>> listarAsync() {
        return repository.findAllAsync();
    }

    @Override
    public CompletableFuture<Premio> actualizarAsync(Premio premio) {
        try {
            validarPremio(premio);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(premio.getId())
                .thenCompose(existente -> {
                    if (existente.isEmpty()) {
                        return CompletableFuture.failedFuture(
                                new CompletionException(
                                        new EntityNotFoundException(
                                                "No se puede actualizar: no existe el premio con ID "
                                                        + premio.getId())));
                    }
                    return repository.updateAsync(premio);
                });
    }

    @Override
    public CompletableFuture<Void> eliminarAsync(Integer id) {
        try {
            validarLlave(id);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.deleteByIdAsync(id)
                .thenCompose(eliminado -> {
                    if (!eliminado) {
                        return CompletableFuture.failedFuture(
                                new CompletionException(
                                        new EntityNotFoundException(
                                                "No se puede eliminar: no existe el premio con ID "
                                                        + id)));
                    }
                    return CompletableFuture.completedFuture(null);
                });
    }

    // ------------------------------------------------------------------
    // Validaciones privadas
    // ------------------------------------------------------------------

    /**
     * Valida los datos de un premio.
     *
     * @param premio entidad a validar
     * @throws ValidationException si algún campo no cumple las reglas
     */
    private void validarPremio(Premio premio) throws ValidationException {

        if (premio == null) {
            throw new ValidationException("El premio no puede ser nulo.");
        }

        // ID: entero positivo
        if (premio.getId() == null || premio.getId() <= 0) {
            throw new ValidationException(
                    "El ID del premio debe ser un entero positivo.");
        }

        // Nombre: no vacío
        premio.setNombre(Validator.validateNotEmpty(premio.getNombre()));

        // Descripción: no vacía
        premio.setDescripcion(Validator.validateNotEmpty(premio.getDescripcion()));

        // Puntos requeridos: entero positivo (un premio no puede costar 0 puntos)
        if (premio.getPuntosRequeridos() == null) {
            throw new ValidationException(
                    "Los puntos requeridos no pueden ser nulos.");
        }
        if (premio.getPuntosRequeridos() <= 0) {
            throw new ValidationException(
                    "Los puntos requeridos deben ser un entero positivo.");
        }

        // Existencias: entero no negativo (puede estar agotado)
        if (premio.getExistencias() == null) {
            throw new ValidationException(
                    "Las existencias no pueden ser nulas.");
        }
        if (premio.getExistencias() < 0) {
            throw new ValidationException(
                    "Las existencias deben ser un entero no negativo.");
        }
    }

    /**
     * Valida que la llave sea un entero positivo.
     *
     * @param id llave a validar
     * @throws ValidationException si la llave es nula o no positiva
     */
    private void validarLlave(Integer id) throws ValidationException {
        if (id == null) {
            throw new ValidationException("El ID no puede ser nulo.");
        }
        if (id <= 0) {
            throw new ValidationException("El ID debe ser un entero positivo.");
        }
    }
}