package mx.unam.ciencias.nipgg.puellagame.ui;

import mx.unam.ciencias.nipgg.puellagame.model.Cliente;

/** Captura y presenta los clientes desde la interfaz de consola. */
public final class ClienteConsoleForm implements EntityConsoleForm<Cliente> {

    /** Construye un formulario de clientes sin estado. */
    public ClienteConsoleForm() {
    }

    /** {@inheritDoc} */
    @Override
    public Cliente readNew(ConsoleInput input) {
        return read(input.readPositiveInteger("ID de cliente: "), input);
    }

    /** {@inheritDoc} */
    @Override
    public Cliente readUpdated(int id, ConsoleInput input) {
        return read(id, input);
    }

    /** {@inheritDoc} */
    @Override
    public String format(Cliente cliente) {
        return "ID: " + cliente.getId()
                + "\nNombre: " + cliente.getNombre()
                + "\nCorreo: " + cliente.getCorreo()
                + "\nTeléfono: " + cliente.getTelefono()
                + "\nPuntos acumulados: " + cliente.getPuntosAcumulados();
    }

    /**
     * Captura los campos editables de un cliente.
     *
     * @param id identificador que conservará la entidad
     * @param input lector validado de consola
     * @return cliente construido con los valores capturados
     */
    private Cliente read(int id, ConsoleInput input) {
        return new Cliente(id,
                input.readRequiredText("Nombre: "),
                input.readEmail("Correo: "),
                input.readPhone("Teléfono: "),
                input.readNonNegativeInteger("Puntos acumulados: "));
    }
}
