package mx.unam.ciencias.nipgg.puellagame.repository;

/**
 * Indica que una operación de persistencia CSV no pudo completarse.
 *
 * @since 1.0
 */
public final class CsvRepositoryException extends RuntimeException {

    /** Identificador de serialización de esta versión. */
    private static final long serialVersionUID = 1L;

    /**
     * Construye una excepción con un mensaje descriptivo.
     *
     * @param message descripción comprensible del problema
     */
    public CsvRepositoryException(String message) {
        super(message);
    }

    /**
     * Construye una excepción que conserva la causa original.
     *
     * @param message descripción comprensible del problema
     * @param cause error que originó el fallo de persistencia
     */
    public CsvRepositoryException(String message, Throwable cause) {
        super(message, cause);
    }
}
