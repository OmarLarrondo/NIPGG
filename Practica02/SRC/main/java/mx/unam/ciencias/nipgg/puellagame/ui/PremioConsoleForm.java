package mx.unam.ciencias.nipgg.puellagame.ui;

import mx.unam.ciencias.nipgg.puellagame.model.Premio;

/** Captura y presenta los premios desde la interfaz de consola. */
public final class PremioConsoleForm implements EntityConsoleForm<Premio> {

    /** Construye un formulario de premios sin estado. */
    public PremioConsoleForm() {
    }

    /** {@inheritDoc} */
    @Override
    public Premio readNew(ConsoleInput input) {
        return read(input.readPositiveInteger("ID de premio: "), input);
    }

    /** {@inheritDoc} */
    @Override
    public Premio readUpdated(int id, ConsoleInput input) {
        return read(id, input);
    }

    /** {@inheritDoc} */
    @Override
    public String format(Premio premio) {
        return "ID: " + premio.getId()
                + "\nNombre: " + premio.getNombre()
                + "\nDescripción: " + premio.getDescripcion()
                + "\nPuntos requeridos: " + premio.getPuntosRequeridos()
                + "\nExistencias: " + premio.getExistencias();
    }

    /**
     * Captura los campos editables de un premio.
     *
     * @param id identificador que conservará la entidad
     * @param input lector validado de consola
     * @return premio construido con los valores capturados
     */
    private Premio read(int id, ConsoleInput input) {
        return new Premio(id,
                input.readRequiredText("Nombre: "),
                input.readRequiredText("Descripción: "),
                input.readPositiveInteger("Puntos requeridos: "),
                input.readNonNegativeInteger("Existencias: "));
    }
}
