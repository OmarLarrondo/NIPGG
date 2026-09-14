package mx.unam.ciencias.nipgg.puellagame.service;

import java.util.List;
import java.util.Objects;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.model.Cliente;
import mx.unam.ciencias.nipgg.puellagame.repository.CrudRepository;
import mx.unam.ciencias.nipgg.puellagame.validation.Validator;

/**
 * Servicio de negocio para la entidad {@link Cliente}.
 *
 * <p>Orquesta las operaciones CRUD sobre clientes aplicando
 * validaciones de datos antes de delegar en el repositorio CSV.
 *
 * @since 1.0
 */
public class ClienteService implements CrudService<Cliente, Integer> {

    private final CrudRepository<Cliente, Integer> repository;

    /**
     * Crea el servicio de clientes.
     *
     * @param repository repositorio CSV de clientes
     */
    public ClienteService(CrudRepository<Cliente, Integer> repository) {
        this.repository = Objects.requireNonNull(repository,
                "El repositorio no puede ser nulo");
    }

    // ------------------------------------------------------------------
    // Operaciones síncronas
    // ------------------------------------------------------------------

    @Override
    public Cliente crear(Cliente cliente) throws ValidationException {
        validarCliente(cliente, true);

        //No se puede crear con un Id existente
        if (repository.findById(cliente.getId()).isPresent()) {
            throw new ValidationException(
                    "Ya existe un cliente con el ID " + cliente.getId());
        }

        return repository.create(cliente);
    }

    @Override
    public Cliente buscarPorId(Integer id)
            throws ValidationException, EntityNotFoundException {
        validarLlave(id);
        return repository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException(
                        "No existe un cliente con el ID " + id));
    }

    @Override
    public List<Cliente> listar() {
        return repository.findAll();
    }

    @Override
    public Cliente actualizar(Cliente cliente)
            throws ValidationException, EntityNotFoundException {
        validarCliente(cliente, false);

        //Un cliente debe existir para poder actualizar su información.
        if (repository.findById(cliente.getId()).isEmpty()) {
            throw new EntityNotFoundException(
                    "No se puede actualizar: no existe el cliente con ID "
                            + cliente.getId());
        }

        return repository.update(cliente);
    }

    @Override
    public void eliminar(Integer id)
            throws ValidationException, EntityNotFoundException {
        validarLlave(id);

        //Para que un cliente pueda ser eliminado, debe existir en el sistema.
        if (!repository.deleteById(id)) {
            throw new EntityNotFoundException(
                    "No se puede eliminar: no existe el cliente con ID " + id);
        }
    }

    // ------------------------------------------------------------------
    // Operaciones asíncronas
    // ------------------------------------------------------------------

    @Override
    public CompletableFuture<Cliente> crearAsync(Cliente cliente) {
        try {
            validarCliente(cliente, true);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(cliente.getId())
                .thenCompose(existente -> {
                    if (existente.isPresent()) {
                        return CompletableFuture.failedFuture(
                                new ValidationException(
                                        "Ya existe un cliente con el ID "
                                                + cliente.getId()));
                    }
                    return repository.createAsync(cliente);
                });
    }

    @Override
    public CompletableFuture<Cliente> buscarPorIdAsync(Integer id) {
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
                                        "No existe un cliente con el ID " + id));
                    }
                    return opt.get();
                });
    }

    @Override
    public CompletableFuture<List<Cliente>> listarAsync() {
        return repository.findAllAsync();
    }

    @Override
    public CompletableFuture<Cliente> actualizarAsync(Cliente cliente) {
        try {
            validarCliente(cliente, false);
        } catch (ValidationException e) {
            return CompletableFuture.failedFuture(e);
        }

        return repository.findByIdAsync(cliente.getId())
                .thenCompose(existente -> {
                    if (existente.isEmpty()) {
                        return CompletableFuture.failedFuture(
                                new CompletionException(
                                        new EntityNotFoundException(
                                                "No se puede actualizar: no existe el cliente con ID "
                                                        + cliente.getId())));
                    }
                    return repository.updateAsync(cliente);
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
                                                "No se puede eliminar: no existe el cliente con ID "
                                                        + id)));
                    }
                    return CompletableFuture.completedFuture(null);
                });
    }

    // ------------------------------------------------------------------
    // Validaciones privadas
    // ------------------------------------------------------------------

    /**
     * Valida los datos de un cliente.
     *
     * @param cliente entidad a validar
     * @param esNuevo {@code true} si es creación; {@code false} si es actualización
     * @throws ValidationException si algún campo no cumple las reglas
     */
    private void validarCliente(Cliente cliente, boolean esNuevo)
            throws ValidationException {

        if (cliente == null) {
            throw new ValidationException("El cliente no puede ser nulo.");
        }

        //El id es un entero positivo
        if (cliente.getId() == null || cliente.getId() <= 0) {
            throw new ValidationException(
                    "El ID del cliente debe ser un entero positivo.");
        }

        //Nombre no null
        cliente.setNombre(Validator.validateNotEmpty(cliente.getNombre()));

        //Formato de correo
        cliente.setCorreo(Validator.validateEmail(cliente.getCorreo()));

        //Teléfono de 10 dígitos
        cliente.setTelefono(Validator.validatePhone(cliente.getTelefono()));

        //Los puntos no pueden ser negativos
        if (cliente.getPuntosAcumulados() == null) {
            throw new ValidationException(
                    "Los puntos acumulados no pueden ser nulos.");
        }
        if (cliente.getPuntosAcumulados() < 0) {
            throw new ValidationException(
                    "Los puntos acumulados deben ser un entero no negativo.");
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