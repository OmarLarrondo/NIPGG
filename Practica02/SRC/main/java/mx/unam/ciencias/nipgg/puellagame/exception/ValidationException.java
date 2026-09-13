package mx.unam.ciencias.nipgg.puellagame.exception;

/**
 * Excepción utilizada cuando un dato proporcionado no cumple con las condiciones esperadas por el sistema.
 */
public class ValidationException extends Exception {

    /**
     * Crea una nueva excepción de validación con el mensaje indicado.
     *
     * @param message mensaje que describe el error.
     */
    public ValidationException(String message) {
        super(message);
    }
}
