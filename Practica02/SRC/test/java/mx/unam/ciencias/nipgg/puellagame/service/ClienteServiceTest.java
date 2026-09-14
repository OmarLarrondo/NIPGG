package mx.unam.ciencias.nipgg.puellagame.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Path;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.model.Cliente;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepository;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvSchema;

/**
 * Verifica las operaciones CRUD y las validaciones del servicio de clientes
 * sobre un repositorio CSV real en un directorio temporal.
 */
final class ClienteServiceTest {

    /** Directorio aislado que JUnit elimina después de cada prueba. */
    @TempDir
    private Path temporaryDirectory;

    // ------------------------------------------------------------------
    // crear()
    // ------------------------------------------------------------------

    /**
     * Verifica que un cliente válido se cree y se recupere correctamente.
     */
    @Test
    void createsAndRetrievesValidCliente() throws Exception {
        var service = service("clientes.csv");
        var cliente = new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100);

        var creado = service.crear(cliente);

        assertEquals(cliente, creado);
        assertEquals(cliente, service.buscarPorId(1));
    }

    /**
     * Verifica que el ID duplicado sea rechazado por el servicio.
     */
    @Test
    void rejectsDuplicateId() throws Exception {
        var service = service("clientes.csv");
        var original = new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100);
        service.crear(original);

        var exception = assertThrows(ValidationException.class,
                () -> service.crear(original));

        assertTrue(exception.getMessage().contains("Ya existe"));
    }

    /**
     * Verifica que un cliente nulo sea rechazado.
     */
    @Test
    void rejectsNullCliente() {
        var service = service("clientes.csv");

        assertThrows(ValidationException.class, () -> service.crear(null));
    }

    /**
     * Verifica que un ID no positivo sea rechazado.
     */
    @Test
    void rejectsNonPositiveId() {
        var service = service("clientes.csv");
        var cliente = new Cliente(0, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100);

        assertThrows(ValidationException.class, () -> service.crear(cliente));
    }

    /**
     * Verifica que un nombre vacío sea rechazado.
     */
    @Test
    void rejectsEmptyName() {
        var service = service("clientes.csv");
        var cliente = new Cliente(1, "", 
                "madoka@example.com", "5512345678", 100);

        assertThrows(ValidationException.class, () -> service.crear(cliente));
    }

    /**
     * Verifica que un correo con formato inválido sea rechazado.
     */
    @Test
    void rejectsInvalidEmail() {
        var service = service("clientes.csv");
        var cliente = new Cliente(1, "Madoka Kaname",
                "correo-sin-arroba", "5512345678", 100);

        assertThrows(ValidationException.class, () -> service.crear(cliente));
    }

    /**
     * Verifica que un teléfono que no tenga exactamente diez dígitos
     * sea rechazado.
     */
    @Test
    void rejectsInvalidPhone() {
        var service = service("clientes.csv");
        var cliente = new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "12345", 100);

        assertThrows(ValidationException.class, () -> service.crear(cliente));
    }

    /**
     * Verifica que los puntos acumulados no puedan ser negativos.
     */
    @Test
    void rejectsNegativePoints() {
        var service = service("clientes.csv");
        var cliente = new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", -1);

        assertThrows(ValidationException.class, () -> service.crear(cliente));
    }

    // ------------------------------------------------------------------
    // buscarPorId()
    // ------------------------------------------------------------------

    /**
     * Verifica que buscar un ID inexistente lance EntityNotFoundException.
     */
    @Test
    void rejectsMissingIdOnSearch() {
        var service = service("clientes.csv");

        assertThrows(EntityNotFoundException.class,
                () -> service.buscarPorId(99));
    }

    /**
     * Verifica que buscar un ID inválido lance ValidationException.
     */
    @Test
    void rejectsInvalidIdOnSearch() {
        var service = service("clientes.csv");

        assertThrows(ValidationException.class, () -> service.buscarPorId(null));
        assertThrows(ValidationException.class, () -> service.buscarPorId(0));
        assertThrows(ValidationException.class, () -> service.buscarPorId(-1));
    }

    // ------------------------------------------------------------------
    // listar()
    // ------------------------------------------------------------------

    /**
     * Verifica que listar devuelva todos los clientes almacenados.
     */
    @Test
    void listsAllClientes() throws Exception {
        var service = service("clientes.csv");
        service.crear(new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100));
        service.crear(new Cliente(2, "Homura Akemi",
                "homura@example.com", "5512345679", 250));

        List<Cliente> clientes = service.listar();

        assertEquals(2, clientes.size());
    }

    // ------------------------------------------------------------------
    // actualizar()
    // ------------------------------------------------------------------

    /**
     * Verifica que actualizar un cliente existente funcione.
     */
    @Test
    void updatesExistingCliente() throws Exception {
        var service = service("clientes.csv");
        service.crear(new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100));

        var actualizado = new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 500);
        var resultado = service.actualizar(actualizado);

        assertEquals(actualizado, resultado);
        assertEquals(500, service.buscarPorId(1).getPuntosAcumulados());
    }

    /**
     * Verifica que actualizar un cliente inexistente lance
     * EntityNotFoundException.
     */
    @Test
    void rejectsUpdateOfMissingCliente() {
        var service = service("clientes.csv");
        var cliente = new Cliente(99, "Fantasma",
                "fantasma@example.com", "5512345678", 100);

        assertThrows(EntityNotFoundException.class,
                () -> service.actualizar(cliente));
    }

    /**
     * Verifica que actualizar con datos inválidos lance ValidationException.
     */
    @Test
    void rejectsUpdateWithInvalidData() throws Exception {
        var service = service("clientes.csv");
        service.crear(new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100));

        var invalido = new Cliente(1, "Madoka Kaname",
                "correo-malo", "5512345678", 100);

        assertThrows(ValidationException.class,
                () -> service.actualizar(invalido));
    }

    // ------------------------------------------------------------------
    // eliminar()
    // ------------------------------------------------------------------

    /**
     * Verifica que eliminar un cliente existente funcione.
     */
    @Test
    void deletesExistingCliente() throws Exception {
        var service = service("clientes.csv");
        service.crear(new Cliente(1, "Madoka Kaname",
                "madoka@example.com", "5512345678", 100));

        service.eliminar(1);

        assertThrows(EntityNotFoundException.class,
                () -> service.buscarPorId(1));
    }

    /**
     * Verifica que eliminar un cliente inexistente lance
     * EntityNotFoundException.
     */
    @Test
    void rejectsDeleteOfMissingCliente() {
        var service = service("clientes.csv");

        assertThrows(EntityNotFoundException.class,
                () -> service.eliminar(99));
    }

    /**
     * Verifica que eliminar con un ID inválido lance ValidationException.
     */
    @Test
    void rejectsDeleteWithInvalidId() {
        var service = service("clientes.csv");

        assertThrows(ValidationException.class, () -> service.eliminar(null));
        assertThrows(ValidationException.class, () -> service.eliminar(0));
    }

    // ------------------------------------------------------------------
    // Utilidades de prueba
    // ------------------------------------------------------------------

    /**
     * Construye un servicio de clientes con repositorio CSV temporal.
     *
     * @param fileName nombre del archivo CSV dentro del directorio temporal
     * @return servicio configurado
     */
    private ClienteService service(String fileName) {
        var repository = new CsvRepository<>(
                temporaryDirectory.resolve(fileName),
                schema());
        return new ClienteService(repository);
    }

    /**
     * Define las funciones puras de conversión para la entidad Cliente.
     *
     * @return esquema de cinco columnas
     */
    private CsvSchema<Cliente, Integer> schema() {
        return new CsvSchema<>(
                List.of("id", "nombre", "correo", "telefono",
                        "puntosAcumulados"),
                Cliente::getId,
                cliente -> List.of(
                        Integer.toString(cliente.getId()),
                        cliente.getNombre(),
                        cliente.getCorreo(),
                        cliente.getTelefono(),
                        Integer.toString(cliente.getPuntosAcumulados())),
                fields -> new Cliente(
                        Integer.parseInt(fields.get(0)),
                        fields.get(1),
                        fields.get(2),
                        fields.get(3),
                        Integer.parseInt(fields.get(4))));
    }
}