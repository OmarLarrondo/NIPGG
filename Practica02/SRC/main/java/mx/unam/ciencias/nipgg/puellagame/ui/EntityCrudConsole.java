package mx.unam.ciencias.nipgg.puellagame.ui;

import java.io.PrintStream;
import java.util.Objects;

import mx.unam.ciencias.nipgg.puellagame.exception.EntityNotFoundException;
import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.repository.CsvRepositoryException;
import mx.unam.ciencias.nipgg.puellagame.service.CrudService;

/**
 * Conecta un submenú CRUD con un servicio concreto y el formulario de su
 * entidad.
 *
 * <p>La clase concentra el manejo de errores de dominio y persistencia para
 * que todas las entidades tengan una interacción uniforme.</p>
 *
 * @param <T> tipo de entidad gestionada
 * @since 1.0
 */
public final class EntityCrudConsole<T> {

    /** Nombre plural que se muestra en mensajes y encabezados. */
    private final String entityName;

    /** Lector compartido por todos los flujos de captura. */
    private final ConsoleInput input;

    /** Salida donde se muestran resultados y errores. */
    private final PrintStream output;

    /** Servicio que aplica las reglas de negocio. */
    private final CrudService<T, Integer> service;

    /** Formulario y formato particulares de la entidad. */
    private final EntityConsoleForm<T> form;

    /**
     * Construye el controlador de consola para una entidad.
     *
     * @param entityName nombre plural de la entidad
     * @param input lector de datos de consola
     * @param output salida de consola
     * @param service servicio CRUD de la entidad
     * @param form formulario específico de la entidad
     */
    public EntityCrudConsole(String entityName, ConsoleInput input,
                             PrintStream output, CrudService<T, Integer> service,
                             EntityConsoleForm<T> form) {
        this.entityName = Objects.requireNonNull(entityName,
                "La entidad no puede ser nula.");
        this.input = Objects.requireNonNull(input,
                "El lector no puede ser nulo.");
        this.output = Objects.requireNonNull(output,
                "La salida no puede ser nula.");
        this.service = Objects.requireNonNull(service,
                "El servicio no puede ser nulo.");
        this.form = Objects.requireNonNull(form,
                "El formulario no puede ser nulo.");
    }

    /** Abre el submenú CRUD y atiende sus operaciones hasta regresar. */
    public void run() {
        new CrudConsoleMenu(entityName, input, output, this::create,
                this::findById, this::update, this::delete).run();
    }

    private void create() {
        execute("Registro guardado", () -> service.crear(form.readNew(input)));
    }

    private void findById() {
        int id = input.readPositiveInteger("ID a consultar: ");
        execute("Resultado", () -> service.buscarPorId(id));
    }

    private void update() {
        int id = input.readPositiveInteger("ID a editar: ");
        execute("Registro actualizado",
                () -> service.actualizar(form.readUpdated(id, input)));
    }

    private void delete() {
        int id = input.readPositiveInteger("ID a eliminar: ");
        if (!input.readConfirmation("¿Confirmas la eliminación?")) {
            output.println("Operación cancelada.");
            return;
        }
        try {
            service.eliminar(id);
            output.println("Registro eliminado.");
        } catch (ValidationException | EntityNotFoundException
                | CsvRepositoryException exception) {
            output.println("Error: " + exception.getMessage());
        }
    }

    private void execute(String title, ConsoleOperation<T> operation) {
        try {
            T entity = operation.run();
            output.printf("%s:%n%s%n", title, form.format(entity));
        } catch (ValidationException | EntityNotFoundException
                | CsvRepositoryException exception) {
            output.println("Error: " + exception.getMessage());
        }
    }

    /** Operación de consola que puede fallar por reglas de negocio. */
    @FunctionalInterface
    private interface ConsoleOperation<R> {

        /**
         * Ejecuta una operación que devuelve una entidad.
         *
         * @return resultado de la operación
         * @throws ValidationException si los datos no son válidos
         * @throws EntityNotFoundException si no se encuentra la entidad
         */
        R run() throws ValidationException, EntityNotFoundException;
    }
}
