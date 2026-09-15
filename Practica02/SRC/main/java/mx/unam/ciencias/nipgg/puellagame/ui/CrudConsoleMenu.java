package mx.unam.ciencias.nipgg.puellagame.ui;

import java.io.PrintStream;
import java.util.Objects;

/**
 * Proporciona la navegación CRUD común para una entidad.
 *
 * <p>Las operaciones se reciben como acciones para mantener este menú
 * independiente de las implementaciones de servicios y modelos.</p>
 *
 * @since 1.0
 */
public final class CrudConsoleMenu {

    /** Nombre plural que se muestra en el encabezado. */
    private final String entityName;

    /** Lector compartido por los submenús. */
    private final ConsoleInput input;

    /** Salida donde se imprime el submenú. */
    private final PrintStream output;

    /** Acción de alta. */
    private final Runnable createAction;

    /** Acción de consulta por llave. */
    private final Runnable findAction;

    /** Acción de modificación. */
    private final Runnable updateAction;

    /** Acción de eliminación. */
    private final Runnable deleteAction;

    /**
     * Construye un submenú CRUD para la entidad indicada.
     *
     * @param entityName nombre plural de la entidad
     * @param input lector de datos de consola
     * @param output salida de consola
     * @param createAction acción de alta
     * @param findAction acción de consulta
     * @param updateAction acción de modificación
     * @param deleteAction acción de eliminación
     */
    public CrudConsoleMenu(String entityName, ConsoleInput input, PrintStream output,
                           Runnable createAction, Runnable findAction,
                           Runnable updateAction, Runnable deleteAction) {
        this.entityName = Objects.requireNonNull(entityName, "La entidad no puede ser nula.");
        this.input = Objects.requireNonNull(input, "El lector no puede ser nulo.");
        this.output = Objects.requireNonNull(output, "La salida no puede ser nula.");
        this.createAction = Objects.requireNonNull(createAction, "El alta no puede ser nula.");
        this.findAction = Objects.requireNonNull(findAction, "La consulta no puede ser nula.");
        this.updateAction = Objects.requireNonNull(updateAction, "La modificación no puede ser nula.");
        this.deleteAction = Objects.requireNonNull(deleteAction, "La eliminación no puede ser nula.");
    }

    /** Ejecuta este submenú hasta que se elige regresar. */
    public void run() {
        boolean running = true;
        while (running) {
            showMenu();
            switch (input.readOption("Elige una opción: ", 0, 4)) {
                case 1 -> createAction.run();
                case 2 -> findAction.run();
                case 3 -> updateAction.run();
                case 4 -> deleteAction.run();
                case 0 -> running = false;
                default -> throw new IllegalStateException("Opción no contemplada.");
            }
        }
    }

    /** Muestra las operaciones disponibles para la entidad actual. */
    private void showMenu() {
        output.printf("%n=== %s ===%n", entityName);
        output.println("1. Agregar");
        output.println("2. Consultar por ID");
        output.println("3. Editar");
        output.println("4. Eliminar");
        output.println("0. Regresar");
    }
}
