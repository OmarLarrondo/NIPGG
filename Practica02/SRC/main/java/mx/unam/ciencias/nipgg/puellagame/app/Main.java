package mx.unam.ciencias.nipgg.puellagame.app;

import java.nio.file.Path;
import java.util.List;

import mx.unam.ciencias.nipgg.puellagame.model.Cliente;
import mx.unam.ciencias.nipgg.puellagame.model.Premio;
import mx.unam.ciencias.nipgg.puellagame.model.Sucursal;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepository;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvSchema;
import mx.unam.ciencias.nipgg.puellagame.service.ClienteService;
import mx.unam.ciencias.nipgg.puellagame.service.PremioService;
import mx.unam.ciencias.nipgg.puellagame.service.SucursalService;
import mx.unam.ciencias.nipgg.puellagame.ui.ClienteConsoleForm;
import mx.unam.ciencias.nipgg.puellagame.ui.ConsoleInput;
import mx.unam.ciencias.nipgg.puellagame.ui.ConsoleMenu;
import mx.unam.ciencias.nipgg.puellagame.ui.EntityCrudConsole;
import mx.unam.ciencias.nipgg.puellagame.ui.PremioConsoleForm;
import mx.unam.ciencias.nipgg.puellagame.ui.SucursalConsoleForm;

/**
 * Punto de entrada de la aplicación PuellaGame.
 *
 * <p>Compone modelos, repositorios CSV, servicios y la interfaz de consola.
 * Los archivos persistentes se localizan en el directorio {@code datos} del
 * módulo {@code SRC}.</p>
 *
 * @since 1.0
 */
public final class Main {

    /** Impide crear instancias de la clase de arranque. */
    private Main() {
    }

    /**
     * Inicia la navegación principal de la aplicación.
     *
     * @param args argumentos de línea de comandos, no utilizados
     */
    public static void main(String[] args) {
        ConsoleInput input = new ConsoleInput(System.in, System.out);
        Path dataDirectory = Path.of("datos");
        var sucursalService = new SucursalService(new CsvRepository<>(
                dataDirectory.resolve("sucursales.csv"), sucursalSchema()));
        var premioService = new PremioService(new CsvRepository<>(
                dataDirectory.resolve("premios.csv"), premioSchema()));
        var clienteService = new ClienteService(new CsvRepository<>(
                dataDirectory.resolve("clientes.csv"), clienteSchema()));

        var sucursales = new EntityCrudConsole<>("Sucursales", input,
                System.out, sucursalService, new SucursalConsoleForm());
        var premios = new EntityCrudConsole<>("Premios", input, System.out,
                premioService, new PremioConsoleForm());
        var clientes = new EntityCrudConsole<>("Clientes", input, System.out,
                clienteService, new ClienteConsoleForm());
        ConsoleMenu menu = new ConsoleMenu(input, System.out,
                sucursales::run, premios::run, clientes::run);
        menu.run();
    }

    /**
     * Define la correspondencia entre sucursales y sus filas CSV.
     *
     * @return esquema CSV de sucursales
     */
    private static CsvSchema<Sucursal, Integer> sucursalSchema() {
        return new CsvSchema<>(List.of("idSucursal", "nombre", "direccion",
                "telefono"), Sucursal::getId,
                sucursal -> List.of(String.valueOf(sucursal.getId()),
                        sucursal.getNombre(), sucursal.getDireccion(),
                        sucursal.getTelefono()),
                fields -> new Sucursal(Integer.parseInt(fields.get(0)),
                        fields.get(1), fields.get(2), fields.get(3)));
    }

    /**
     * Define la correspondencia entre premios y sus filas CSV.
     *
     * @return esquema CSV de premios
     */
    private static CsvSchema<Premio, Integer> premioSchema() {
        return new CsvSchema<>(List.of("idPremio", "nombre", "descripcion",
                "puntosRequeridos", "existencias"), Premio::getId,
                premio -> List.of(String.valueOf(premio.getId()),
                        premio.getNombre(), premio.getDescripcion(),
                        String.valueOf(premio.getPuntosRequeridos()),
                        String.valueOf(premio.getExistencias())),
                fields -> new Premio(Integer.parseInt(fields.get(0)),
                        fields.get(1), fields.get(2),
                        Integer.parseInt(fields.get(3)),
                        Integer.parseInt(fields.get(4))));
    }

    /**
     * Define la correspondencia entre clientes y sus filas CSV.
     *
     * @return esquema CSV de clientes
     */
    private static CsvSchema<Cliente, Integer> clienteSchema() {
        return new CsvSchema<>(List.of("idCliente", "nombre", "correo",
                "telefono", "puntosAcumulados"), Cliente::getId,
                cliente -> List.of(String.valueOf(cliente.getId()),
                        cliente.getNombre(), cliente.getCorreo(),
                        cliente.getTelefono(),
                        String.valueOf(cliente.getPuntosAcumulados())),
                fields -> new Cliente(Integer.parseInt(fields.get(0)),
                        fields.get(1), fields.get(2), fields.get(3),
                        Integer.parseInt(fields.get(4))));
    }
}
