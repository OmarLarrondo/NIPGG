package mx.unam.ciencias.nipgg.puellagame.ui;

import mx.unam.ciencias.nipgg.puellagame.model.Sucursal;

/** Captura y presenta las sucursales desde la interfaz de consola. */
public final class SucursalConsoleForm implements EntityConsoleForm<Sucursal> {

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

    private Sucursal read(int id, ConsoleInput input) {
        return new Sucursal(id,
                input.readRequiredText("Nombre: "),
                input.readRequiredText("Dirección: "),
                input.readPhone("Teléfono: "));
    }
}
