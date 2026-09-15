package mx.unam.ciencias.nipgg.puellagame.ui;

import java.io.PrintStream;
import java.util.Objects;

/**
 * Presenta el menú principal de PuellaGame y delega cada sección a una acción.
 *
 * <p>No conoce modelos, repositorios ni servicios. Esto permite probar la
 * navegación por separado y conectar las operaciones reales durante la
 * integración.</p>
 *
 * @since 1.0
 */
public final class ConsoleMenu {

    /** Lector compartido por la navegación principal. */
    private final ConsoleInput input;

    /** Salida donde se imprime el menú. */
    private final PrintStream output;

    /** Acción que abre la gestión de sucursales. */
    private final Runnable sucursalAction;

    /** Acción que abre la gestión de premios. */
    private final Runnable premioAction;

    /** Acción que abre la gestión de clientes. */
    private final Runnable clienteAction;

    /**
     * Construye el menú principal con las acciones de cada entidad.
     *
     * @param input lector de datos de consola
     * @param output salida de consola
     * @param sucursalAction acción que abre la gestión de sucursales
     * @param premioAction acción que abre la gestión de premios
     * @param clienteAction acción que abre la gestión de clientes
     */
    public ConsoleMenu(ConsoleInput input, PrintStream output,
                       Runnable sucursalAction, Runnable premioAction,
                       Runnable clienteAction) {
        this.input = Objects.requireNonNull(input, "El lector no puede ser nulo.");
        this.output = Objects.requireNonNull(output, "La salida no puede ser nula.");
        this.sucursalAction = Objects.requireNonNull(sucursalAction,
                "La acción de sucursales no puede ser nula.");
        this.premioAction = Objects.requireNonNull(premioAction,
                "La acción de premios no puede ser nula.");
        this.clienteAction = Objects.requireNonNull(clienteAction,
                "La acción de clientes no puede ser nula.");
    }

    /** Ejecuta el ciclo del menú hasta que se elige la opción de salida. */
    public void run() {
        boolean running = true;
        while (running) {
            showMainMenu();
            switch (input.readOption("Elige una opción: ", 0, 3)) {
                case 1 -> sucursalAction.run();
                case 2 -> premioAction.run();
                case 3 -> clienteAction.run();
                case 0 -> running = false;
                default -> throw new IllegalStateException("Opción no contemplada.");
            }
        }
        output.println("Gracias por usar PuellaGame.");
    }

    /** Muestra las opciones disponibles en el menú principal. */
    private void showMainMenu() {
        output.println();
        output.println("=== PuellaGame ===");
        output.println("1. Gestionar sucursales");
        output.println("2. Gestionar premios");
        output.println("3. Gestionar clientes");
        output.println("0. Salir");
    }
}
