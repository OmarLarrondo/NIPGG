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
import mx.unam.ciencias.nipgg.puellagame.model.Sucursal;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepository;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvSchema;

/**
 * Verifica las operaciones CRUD y las validaciones del servicio de sucursales
 * sobre un repositorio CSV real en un directorio temporal.
 */
final class SucursalServiceTest {

    /** Directorio aislado que JUnit elimina después de cada prueba. */
    @TempDir
    private Path temporaryDirectory;

    // ------------------------------------------------------------------
    // crear()
    // ------------------------------------------------------------------

    /**
     * Verifica que una sucursal válida se cree y se recupere correctamente.
     */
    @Test
    void createsAndRetrievesValidSucursal() throws Exception {
        var service = service("sucursales.csv");
        var sucursal = new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678");

        var creado = service.crear(sucursal);

        assertEquals(sucursal, creado);
        assertEquals(sucursal, service.buscarPorId(1));
    }

    /**
     * Verifica que el ID duplicado sea rechazado por el servicio.
     */
    @Test
    void rejectsDuplicateId() throws Exception {
        var service = service("sucursales.csv");
        var original = new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678");
        service.crear(original);

        var exception = assertThrows(ValidationException.class,
                () -> service.crear(original));

        assertTrue(exception.getMessage().contains("Ya existe"));
    }

    /**
     * Verifica que una sucursal nula sea rechazada.
     */
    @Test
    void rejectsNullSucursal() {
        var service = service("sucursales.csv");

        assertThrows(ValidationException.class, () -> service.crear(null));
    }

    /**
     * Verifica que un ID no positivo sea rechazado.
     */
    @Test
    void rejectsNonPositiveId() {
        var service = service("sucursales.csv");
        var sucursal = new Sucursal(0, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678");

        assertThrows(ValidationException.class, () -> service.crear(sucursal));
    }

    /**
     * Verifica que un nombre vacío sea rechazado.
     */
    @Test
    void rejectsEmptyName() {
        var service = service("sucursales.csv");
        var sucursal = new Sucursal(1, "",
                "Av. Reforma 123", "5512345678");

        assertThrows(ValidationException.class, () -> service.crear(sucursal));
    }

    /**
     * Verifica que una dirección vacía sea rechazada.
     */
    @Test
    void rejectsEmptyAddress() {
        var service = service("sucursales.csv");
        var sucursal = new Sucursal(1, "PuellaGame Centro",
                "", "5512345678");

        assertThrows(ValidationException.class, () -> service.crear(sucursal));
    }

    /**
     * Verifica que un teléfono que no tenga exactamente diez dígitos
     * sea rechazado.
     */
    @Test
    void rejectsInvalidPhone() {
        var service = service("sucursales.csv");
        var sucursal = new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "12345");

        assertThrows(ValidationException.class, () -> service.crear(sucursal));
    }

    // ------------------------------------------------------------------
    // buscarPorId()
    // ------------------------------------------------------------------

    /**
     * Verifica que buscar un ID inexistente lance EntityNotFoundException.
     */
    @Test
    void rejectsMissingIdOnSearch() {
        var service = service("sucursales.csv");

        assertThrows(EntityNotFoundException.class,
                () -> service.buscarPorId(99));
    }

    /**
     * Verifica que buscar un ID inválido lance ValidationException.
     */
    @Test
    void rejectsInvalidIdOnSearch() {
        var service = service("sucursales.csv");

        assertThrows(ValidationException.class, () -> service.buscarPorId(null));
        assertThrows(ValidationException.class, () -> service.buscarPorId(0));
        assertThrows(ValidationException.class, () -> service.buscarPorId(-1));
    }

    // ------------------------------------------------------------------
    // listar()
    // ------------------------------------------------------------------

    /**
     * Verifica que listar devuelva todas las sucursales almacenadas.
     */
    @Test
    void listsAllSucursales() throws Exception {
        var service = service("sucursales.csv");
        service.crear(new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678"));
        service.crear(new Sucursal(2, "PuellaGame Norte",
                "Av. Insurgentes 456", "5512345679"));

        List<Sucursal> sucursales = service.listar();

        assertEquals(2, sucursales.size());
    }

    // ------------------------------------------------------------------
    // actualizar()
    // ------------------------------------------------------------------

    /**
     * Verifica que actualizar una sucursal existente funcione.
     */
    @Test
    void updatesExistingSucursal() throws Exception {
        var service = service("sucursales.csv");
        service.crear(new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678"));

        var actualizado = new Sucursal(1, "PuellaGame Centro Histórico",
                "Av. Reforma 456", "5512345670");
        var resultado = service.actualizar(actualizado);

        assertEquals(actualizado, resultado);
        assertEquals("PuellaGame Centro Histórico",
                service.buscarPorId(1).getNombre());
    }

    /**
     * Verifica que actualizar una sucursal inexistente lance
     * EntityNotFoundException.
     */
    @Test
    void rejectsUpdateOfMissingSucursal() {
        var service = service("sucursales.csv");
        var sucursal = new Sucursal(99, "Fantasma",
                "Av. Inexistente 0", "5512345678");

        assertThrows(EntityNotFoundException.class,
                () -> service.actualizar(sucursal));
    }

    /**
     * Verifica que actualizar con datos inválidos lance ValidationException.
     */
    @Test
    void rejectsUpdateWithInvalidData() throws Exception {
        var service = service("sucursales.csv");
        service.crear(new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678"));

        var invalido = new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "123");

        assertThrows(ValidationException.class,
                () -> service.actualizar(invalido));
    }

    // ------------------------------------------------------------------
    // eliminar()
    // ------------------------------------------------------------------

    /**
     * Verifica que eliminar una sucursal existente funcione.
     */
    @Test
    void deletesExistingSucursal() throws Exception {
        var service = service("sucursales.csv");
        service.crear(new Sucursal(1, "PuellaGame Centro",
                "Av. Reforma 123", "5512345678"));

        service.eliminar(1);

        assertThrows(EntityNotFoundException.class,
                () -> service.buscarPorId(1));
    }

    /**
     * Verifica que eliminar una sucursal inexistente lance
     * EntityNotFoundException.
     */
    @Test
    void rejectsDeleteOfMissingSucursal() {
        var service = service("sucursales.csv");

        assertThrows(EntityNotFoundException.class,
                () -> service.eliminar(99));
    }

    /**
     * Verifica que eliminar con un ID inválido lance ValidationException.
     */
    @Test
    void rejectsDeleteWithInvalidId() {
        var service = service("sucursales.csv");

        assertThrows(ValidationException.class, () -> service.eliminar(null));
        assertThrows(ValidationException.class, () -> service.eliminar(0));
    }

    // ------------------------------------------------------------------
    // Utilidades de prueba
    // ------------------------------------------------------------------

    /**
     * Construye un servicio de sucursales con repositorio CSV temporal.
     *
     * @param fileName nombre del archivo CSV dentro del directorio temporal
     * @return servicio configurado
     */
    private SucursalService service(String fileName) {
        var repository = new CsvRepository<>(
                temporaryDirectory.resolve(fileName),
                schema());
        return new SucursalService(repository);
    }

    /**
     * Define las funciones puras de conversión para la entidad Sucursal.
     *
     * @return esquema de cuatro columnas
     */
    private CsvSchema<Sucursal, Integer> schema() {
        return new CsvSchema<>(
                List.of("idSucursal", "nombre", "direccion", "telefono"),
                Sucursal::getId,
                sucursal -> List.of(
                        Integer.toString(sucursal.getId()),
                        sucursal.getNombre(),
                        sucursal.getDireccion(),
                        sucursal.getTelefono()),
                fields -> new Sucursal(
                        Integer.parseInt(fields.get(0)),
                        fields.get(1),
                        fields.get(2),
                        fields.get(3)));
    }
}