package mx.unam.ciencias.nipgg.puellagame.ui;

import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

import mx.unam.ciencias.nipgg.puellagame.model.Sucursal;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepository;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvSchema;
import mx.unam.ciencias.nipgg.puellagame.service.SucursalService;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

/**
 * Verifica el flujo de interfaz completo con el servicio y la persistencia
 * temporal, sin modificar los CSV entregables del proyecto.
 */
final class EntityCrudConsoleTest {

    /** Directorio aislado que JUnit elimina después de cada prueba. */
    @TempDir
    private Path temporaryDirectory;

    /**
     * Comprueba altas, consultas, modificaciones y bajas desde el submenú de
     * sucursales con el repositorio CSV real.
     *
     * @throws IOException si no se puede preparar el CSV temporal
     */
    @Test
    void performsFullSucursalCrudFlow() throws IOException {
        var path = temporaryDirectory.resolve("sucursales.csv");
        Files.writeString(path, "idSucursal,nombre,direccion,telefono\n",
                StandardCharsets.UTF_8);
        var repository = new CsvRepository<>(path, sucursalSchema());
        var service = new SucursalService(repository);
        var output = new ByteArrayOutputStream();
        var printStream = new PrintStream(output, true, StandardCharsets.UTF_8);
        var input = new ConsoleInput(new ByteArrayInputStream((
                "1\n1\nCentro Norte\nAv. Universidad 3000\n5512345678\n"
                + "2\n1\n"
                + "3\n1\nCentro Sur\nAv. Insurgentes 100\n5598765432\n"
                + "4\n1\ns\n0\n").getBytes(StandardCharsets.UTF_8)),
                printStream);
        var console = new EntityCrudConsole<>("Sucursales", input, printStream,
                service, new SucursalConsoleForm());

        console.run();

        assertTrue(repository.findAll().isEmpty());
        var transcript = output.toString(StandardCharsets.UTF_8);
        assertTrue(transcript.contains("Registro guardado"));
        assertTrue(transcript.contains("Centro Norte"));
        assertTrue(transcript.contains("Registro actualizado"));
        assertTrue(transcript.contains("Registro eliminado"));
    }

    /** Construye el esquema CSV acordado para la entidad Sucursal. */
    private CsvSchema<Sucursal, Integer> sucursalSchema() {
        return new CsvSchema<>(List.of("idSucursal", "nombre", "direccion",
                "telefono"), Sucursal::getId,
                sucursal -> List.of(String.valueOf(sucursal.getId()),
                        sucursal.getNombre(), sucursal.getDireccion(),
                        sucursal.getTelefono()),
                fields -> new Sucursal(Integer.parseInt(fields.get(0)),
                        fields.get(1), fields.get(2), fields.get(3)));
    }
}
