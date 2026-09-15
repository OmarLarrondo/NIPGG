package mx.unam.ciencias.nipgg.puellagame.service;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.model.Sucursal;
import mx.unam.ciencias.nipgg.puellagame.repository.CrudRepository;
import mx.unam.ciencias.nipgg.puellagame.validation.Validator;

/**
 * Servicio de negocio para la entidad {@link Sucursal}.
 *
 * <p>Orquesta las operaciones CRUD sobre sucursales aplicando
 * validaciones de datos antes de delegar en el repositorio CSV.
 *
 * @since 1.0
 */
public class SucursalService implements CrudService<Sucursal, Integer> {

    /** Repositorio utilizado para consultar y persistir sucursales. */
    private final CrudRepository<Sucursal, Integer> repository;

    /**
     * Crea el servicio de sucursales.
     *
     * @param repository repositorio CSV de sucursales
     */
    public SucursalService(CrudRepository<Sucursal, Integer> repository) {
        this.repository = Objects.requireNonNull(repository,
                "El repositorio no puede ser nulo");
    }

    // ------------------------------------------------------------------
    // Operaciones síncronas
    // ------------------------------------------------------------------

    @Override
    public Sucursal crear(Sucursal sucursal) throws ValidationException {
        validarSucursal(sucursal, true);

        //No se permiten Id's duplicados
        if (repository.findById(sucursal.getId()).isPresent()) {
            throw new ValidationException(
                    "Ya existe una sucursal con el ID " + sucursal.getId());
        }

        return repository.create(sucursal);
    }

    @Override
    public Sucursal buscarPorId(Integer id) throws ValidationException, EntityNotFoundException{
        validarLlave(id);
        return repository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        "No existe una sucursal con el ID " + id));
    }

    @Override
    public List<Sucursal> listar() {
        return repository.findAll();
    }

    @Override
    public Sucursal actualizar(Sucursal sucursal) throws ValidationException, EntityNotFoundException{
        validarSucursal(sucursal, false);

        //Una sucursal debe existir antes de actualizarse
        if (repository.findById(sucursal.getId()).isEmpty()) {
            throw new EntityNotFoundException(
                    "No se puede actualizar: no existe la sucursal con ID "
                            + sucursal.getId());
        }

        return repository.update(sucursal);
    }

    @Override
    public void eliminar(Integer id) throws ValidationException, EntityNotFoundException{
        validarLlave(id);

        //Una sucursal debe existir para poder eliminarse
        if (!repository.deleteById(id)) {
            throw new EntityNotFoundException(
                    "No se puede eliminar: no existe la sucursal con ID " + id);
        }
    }

    // ------------------------------------------------------------------
    // Operaciones asíncronas
    // ------------------------------------------------------------------

    @Override
    public CompletableFuture<Sucursal> crearAsync(Sucursal sucursal) {
        try {
            validarSucursal(sucursal, true);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(sucursal.getId())
                .thenCompose(existente -> {
                    if (existente.isPresent()) {
                        return CompletableFuture.failedFuture(
                                new ValidationException(
                                        "Ya existe una sucursal con el ID "
                                                + sucursal.getId()));
                    }
                    return repository.createAsync(sucursal);
                });
    }

    @Override
    public CompletableFuture<Sucursal> buscarPorIdAsync(Integer id) {
        try {
            validarLlave(id);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(id)
                .thenApply(opt -> {
                    if (opt.isEmpty()) {
                        throw new java.util.concurrent.CompletionException(
                            new EntityNotFoundException(
                                "No existe una sucursal con el ID " + id));
                    }
                    return opt.get();
                });
    }

    @Override
    public CompletableFuture<List<Sucursal>> listarAsync() {
        return repository.findAllAsync();
    }

    @Override
    public CompletableFuture<Sucursal> actualizarAsync(Sucursal sucursal) {
        try {
            validarSucursal(sucursal, false);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(sucursal.getId())
                .thenCompose(existente -> {
                    if (existente.isEmpty()) {
                        return CompletableFuture.failedFuture(
                                new EntityNotFoundException(
                                        "No se puede actualizar: no existe la sucursal con ID "
                                                + sucursal.getId()));
                    }
                    return repository.updateAsync(sucursal);
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
                                new EntityNotFoundException(
                                        "No se puede eliminar: no existe la sucursal con ID " + id));
                    }
                    return CompletableFuture.completedFuture(null);
                });
    }

    // ------------------------------------------------------------------
    // Validaciones privadas
    // ------------------------------------------------------------------

    /**
     * Valida y normaliza todos los campos de una sucursal.
     *
     * @param sucursal entidad que se desea validar
     * @param esNueva indica si la validación corresponde a un alta
     * @throws ValidationException si la entidad o alguno de sus campos es inválido
     */
    private void validarSucursal(Sucursal sucursal, boolean esNueva)
            throws ValidationException {
        if (sucursal == null) {
            throw new ValidationException("La sucursal no puede ser nula.");
        }

        if (sucursal.getId() == null || sucursal.getId() <= 0) {
            throw new ValidationException(
                    "El ID de la sucursal debe ser un entero positivo.");
        }

        sucursal.setNombre(Validator.validateNotEmpty(sucursal.getNombre()));
        sucursal.setDireccion(Validator.validateNotEmpty(sucursal.getDireccion()));
        sucursal.setTelefono(Validator.validatePhone(sucursal.getTelefono()));
    }

    /**
     * Comprueba que una llave sea un entero positivo.
     *
     * @param id llave que se desea validar
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
