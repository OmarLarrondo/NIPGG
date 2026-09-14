package mx.unam.ciencias.nipgg.puellagame.exception;

/**
 * Excepción utilizada cuando no se encuentra una entidad con la información proporcionada.
 */
public class EntityNotFoundException extends Exception {

    /**
     * Crea una nueva excepción indicando que no se encontró la entidad solicitada.
     *
     * @param message mensaje que describe el error.
     */
    public EntityNotFoundException(String message) {
        super(message);
    }
}
