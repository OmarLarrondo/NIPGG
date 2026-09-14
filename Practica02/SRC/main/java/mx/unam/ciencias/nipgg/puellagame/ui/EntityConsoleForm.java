package mx.unam.ciencias.nipgg.puellagame.ui;

/**
 * Describe cómo captura y presenta la interfaz una entidad concreta.
 *
 * <p>El contrato mantiene separado el flujo CRUD de los campos particulares
 * de sucursales, premios y clientes.</p>
 *
 * @param <T> tipo de entidad que captura el formulario
 * @since 1.0
 */
public interface EntityConsoleForm<T> {

    /**
     * Solicita los datos necesarios para crear una entidad.
     *
     * @param input lector de consola que valida cada respuesta
     * @return entidad construida con los datos capturados
     */
    T readNew(ConsoleInput input);

    /**
     * Solicita los datos necesarios para actualizar una entidad.
     *
     * @param id identificador inmutable de la entidad existente
     * @param input lector de consola que valida cada respuesta
     * @return entidad actualizada con el identificador indicado
     */
    T readUpdated(int id, ConsoleInput input);

    /**
     * Construye una representación legible para mostrar una entidad.
     *
     * @param entity entidad que se desea mostrar
     * @return texto con todos los campos de la entidad
     */
    String format(T entity);
}
