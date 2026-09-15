package mx.unam.ciencias.nipgg.puellagame.ui;

import mx.unam.ciencias.nipgg.puellagame.model.Sucursal;

/** Captura y presenta las sucursales desde la interfaz de consola. */
public final class SucursalConsoleForm implements EntityConsoleForm<Sucursal> {

    /** Construye un formulario de sucursales sin estado. */
    public SucursalConsoleForm() {
    }

    /** {@inheritDoc} */
    @Override
    public Sucursal readNew(ConsoleInput input) {
        return read(input.readPositiveInteger("ID de sucursal: "), input);
    }

    /** {@inheritDoc} */
    @Override
    public Sucursal readUpdated(int id, ConsoleInput input) {
        return read(id, input);
    }

    /** {@inheritDoc} */
    @Override
    public String format(Sucursal sucursal) {
        return "ID: " + sucursal.getId()
                + "\nNombre: " + sucursal.getNombre()
                + "\nDirección: " + sucursal.getDireccion()
                + "\nTeléfono: " + sucursal.getTelefono();
    }

    /**
     * Captura los campos editables de una sucursal.
     *
     * @param id identificador que conservará la entidad
     * @param input lector validado de consola
     * @return sucursal construida con los valores capturados
     */
    private Sucursal read(int id, ConsoleInput input) {
        return new Sucursal(id,
                input.readRequiredText("Nombre: "),
                input.readRequiredText("Dirección: "),
                input.readPhone("Teléfono: "));
    }
}
