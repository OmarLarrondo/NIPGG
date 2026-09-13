package mx.unam.ciencias.nipgg.puellagame.app;

import mx.unam.ciencias.nipgg.puellagame.ui.ConsoleInput;
import mx.unam.ciencias.nipgg.puellagame.ui.ConsoleMenu;
import mx.unam.ciencias.nipgg.puellagame.ui.CrudConsoleMenu;

/**
 * Punto de entrada de la aplicación PuellaGame.
 *
 * <p>Las acciones temporales se reemplazarán durante la integración por los
 * controladores que invoquen los servicios CRUD de cada entidad.</p>
 *
 * @since 1.0
 */
public final class Main {

    private Main() {
    }

    /**
     * Inicia la navegación principal de la aplicación.
     *
     * @param args argumentos de línea de comandos, no utilizados
     */
    public static void main(String[] args) {
        ConsoleInput input = new ConsoleInput(System.in, System.out);
        ConsoleMenu menu = new ConsoleMenu(input, System.out,
                () -> openEntityMenu("Sucursales", input),
                () -> openEntityMenu("Premios", input),
                () -> openEntityMenu("Clientes", input));
        menu.run();
    }

    private static void openEntityMenu(String entityName, ConsoleInput input) {
        CrudConsoleMenu menu = new CrudConsoleMenu(entityName, input, System.out,
                () -> showPendingOperation("agregar", entityName),
                () -> showPendingOperation("consultar", entityName),
                () -> showPendingOperation("editar", entityName),
                () -> showPendingOperation("eliminar", entityName));
        menu.run();
    }

    private static void showPendingOperation(String operation, String entityName) {
        System.out.printf("%nLa operación '%s' de %s se conectará durante la integración.%n",
                operation, entityName.toLowerCase());
    }
}
