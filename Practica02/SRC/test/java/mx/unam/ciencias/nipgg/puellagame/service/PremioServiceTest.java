package mx.unam.ciencias.nipgg.puellagame.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.nio.file.Path;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.model.Premio;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepository;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvSchema;

/**
 * Verifica las operaciones CRUD y las validaciones del servicio de premios
 * sobre un repositorio CSV real en un directorio temporal.
 */
final class PremioServiceTest {

    /** Directorio aislado que JUnit elimina después de cada prueba. */
    @TempDir
    private Path temporaryDirectory;

    /**
     * Verifica que un premio válido se cree y se recupere correctamente.
     */
    @Test
    void createsAndRetrievesValidPremio() throws Exception {
        var service = service("premios.csv");
        var premio = new Premio(1, "Peluche", "Peluche de Madoka", 100, 5);

        var creado = service.crear(premio);

        assertEquals(premio, creado);
        assertEquals(premio, service.buscarPorId(1));
    }

    /**
     * Verifica que el ID duplicado sea rechazado por el servicio.
     */
    @Test
    void rejectsDuplicateId() throws Exception {
        var service = service("premios.csv");
        var original = new Premio(1, "Peluche", "Peluche de Madoka", 100, 5);
        service.crear(original);

        var exception = assertThrows(ValidationException.class,
                () -> service.crear(original));

        assertTrue(exception.getMessage().contains("Ya existe"));
    }

    /**
     * Verifica que un nombre vacío sea rechazado.
     */
    @Test
    void rejectsEmptyName() {
        var service = service("premios.csv");
        var premio = new Premio(1, "", "Descripción válida", 100, 5);

        assertThrows(ValidationException.class, () -> service.crear(premio));
    }

    /**
     * Verifica que los puntos requeridos no puedan ser negativos.
     */
    @Test
    void rejectsNegativePoints() {
        var service = service("premios.csv");
        var premio = new Premio(1, "Peluche", "Peluche de Madoka", -10, 5);

        assertThrows(ValidationException.class, () -> service.crear(premio));
    }

    /**
     * Verifica que las existencias no puedan ser negativas.
     */
    @Test
    void rejectsNegativeStock() {
        var service = service("premios.csv");
        var premio = new Premio(1, "Peluche", "Peluche de Madoka", 100, -1);

        assertThrows(ValidationException.class, () -> service.crear(premio));
    }

    /**
     * Verifica que buscar un ID inexistente lance EntityNotFoundException.
     */
    @Test
    void rejectsMissingIdOnSearch() {
        var service = service("premios.csv");

        assertThrows(EntityNotFoundException.class,
                () -> service.buscarPorId(99));
    }

    /**
     * Verifica que buscar un ID inválido lance ValidationException.
     */
    @Test
    void rejectsInvalidIdOnSearch() {
        var service = service("premios.csv");

        assertThrows(ValidationException.class, () -> service.buscarPorId(null));
        assertThrows(ValidationException.class, () -> service.buscarPorId(0));
        assertThrows(ValidationException.class, () -> service.buscarPorId(-1));
    }

    /**
     * Verifica que listar devuelva todos los premios almacenados.
     */
    @Test
    void listsAllPremios() throws Exception {
        var service = service("premios.csv");
        service.crear(new Premio(1, "Peluche", "Descripción 1", 100, 5));
        service.crear(new Premio(2, "Llavero", "Descripción 2", 50, 10));

        var premios = service.listar();

        assertEquals(2, premios.size());
    }

    /**
     * Verifica que actualizar un premio existente funcione.
     */
    @Test
    void updatesExistingPremio() throws Exception {
        var service = service("premios.csv");
        service.crear(new Premio(1, "Peluche", "Descripción", 100, 5));

        var actualizado = new Premio(1, "Peluche XL", "Peluche grande", 150, 3);
        var resultado = service.actualizar(actualizado);

        assertEquals(actualizado, resultado);
        assertEquals("Peluche XL", service.buscarPorId(1).getNombre());
    }

    /**
     * Verifica que actualizar un premio inexistente lance EntityNotFoundException.
     */
    @Test
    void rejectsUpdateOfMissingPremio() {
        var service = service("premios.csv");
        var premio = new Premio(99, "Fantasma", "No existe", 100, 5);

        assertThrows(EntityNotFoundException.class,
                () -> service.actualizar(premio));
    }

    /**
     * Verifica que eliminar un premio existente funcione.
     */
    @Test
    void deletesExistingPremio() throws Exception {
        var service = service("premios.csv");
        service.crear(new Premio(1, "Peluche", "Descripción", 100, 5));

        service.eliminar(1);

        assertThrows(EntityNotFoundException.class,
                () -> service.buscarPorId(1));
    }

    /**
     * Verifica que eliminar un premio inexistente lance EntityNotFoundException.
     */
    @Test
    void rejectsDeleteOfMissingPremio() {
        var service = service("premios.csv");

        assertThrows(EntityNotFoundException.class,
                () -> service.eliminar(99));
    }

    /**
     * Verifica que un premio nulo sea rechazado.
     */
    @Test
    void rejectsNullPremio() {
        var service = service("premios.csv");

        assertThrows(ValidationException.class, () -> service.crear(null));
    }

    /**
     * Construye un servicio de premios con repositorio CSV temporal.
     *
     * @param fileName nombre del archivo CSV dentro del directorio temporal
     * @return servicio configurado
     */
    private PremioService service(String fileName) {
        var repository = new CsvRepository<>(
                temporaryDirectory.resolve(fileName),
                schema());
        return new PremioService(repository);
    }

    /**
     * Define las funciones puras de conversión para la entidad Premio.
     *
     * @return esquema de cinco columnas
     */
    private CsvSchema<Premio, Integer> schema() {
        return new CsvSchema<>(
                java.util.List.of("id", "nombre", "descripcion",
                        "puntosRequeridos", "existencias"),
                Premio::getId,
                premio -> java.util.List.of(
                        Integer.toString(premio.getId()),
                        premio.getNombre(),
                        premio.getDescripcion(),
                        Integer.toString(premio.getPuntosRequeridos()),
                        Integer.toString(premio.getExistencias())),
                fields -> new Premio(
                        Integer.parseInt(fields.get(0)),
                        fields.get(1),
                        fields.get(2),
                        Integer.parseInt(fields.get(3)),
                        Integer.parseInt(fields.get(4))));
    }
}