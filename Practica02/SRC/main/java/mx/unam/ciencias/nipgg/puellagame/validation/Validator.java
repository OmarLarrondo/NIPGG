package mx.unam.ciencias.nipgg.puellagame.validation;

import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;

/**
 * Clase que contiene métodos para validar los datos utilizados
 * por la aplicación PuellaGame.
 */
public final class Validator {

    /**
     * Constructor privado para evitar la creación de objetos de esta clase.
     */
    private Validator() {
    }

    /**
     * Valida que una cadena no sea nula ni esté vacía.
     *
     * @param value cadena que se desea validar.
     * @return la cadena sin espacios al inicio y al final.
     * @throws ValidationException si la cadena es nula o está vacía.
     */
    public static String validateNotEmpty(String value)
            throws ValidationException {

        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException(
                "El valor no puede estar vacío."
            );
        }

        return value.trim();
    }

    /**
     * Valida que una cadena represente un número entero positivo.
     * Un entero positivo debe ser mayor que cero.
     *
     * @param value cadena que se desea validar.
     * @return el valor convertido a entero.
     * @throws ValidationException si el valor no es un entero o si es menor o igual a cero.
     */
    public static int validatePositiveInteger(String value)
            throws ValidationException {

        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("El valor no puede estar vacío.");
        }

        try {
            int number = Integer.parseInt(value.trim());

            if (number <= 0) {
                throw new ValidationException("El valor debe ser un entero positivo.");
            }

            return number;
        } catch (NumberFormatException e) {
            throw new ValidationException("El valor debe ser un número entero positivo.");
        }
    }

    /**
     * Valida que una cadena represente un número entero no negativo.
     * Un entero no negativo debe ser mayor o igual que cero.
     *
     * @param value cadena que se desea validar.
     * @return el valor convertido a entero.
     * @throws ValidationException si el valor no es un entero o si es menor que cero.
     */
    public static int validateNonNegativeInteger(String value)
            throws ValidationException {

        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("El valor no puede estar vacío.");
        }

        try {
            int number = Integer.parseInt(value.trim());

            if (number < 0) {
                throw new ValidationException("El valor debe ser un entero no negativo.");
            }

            return number;
        } catch (NumberFormatException e) {
            throw new ValidationException("El valor debe ser un número entero no negativo.");
        }
    }

    /**
     * Valida que una cadena tenga el formato básico de un correo electrónico.
     *
     * @param value correo electrónico que se desea validar.
     * @return el correo sin espacios al inicio y al final.
     * @throws ValidationException si el correo no tiene un formato válido.
     */
    public static String validateEmail(String value)
            throws ValidationException {

        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("El correo no puede estar vacío.");
        }

        String email = value.trim();

        String expression = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";

        if (!email.matches(expression)) {
            throw new ValidationException("El correo electrónico no tiene un formato válido.");
        }

        return email;
    }

    /**
     * Valida que una cadena contenga exactamente diez dígitos.
     *
     * @param value teléfono que se desea validar.
     * @return el teléfono sin espacios al inicio y al final.
     * @throws ValidationException si el teléfono no contiene exactamente diez dígitos.
     */
    public static String validatePhone(String value)
            throws ValidationException {

        if (value == null || value.trim().isEmpty()) {
            throw new ValidationException("El teléfono no puede estar vacío.");
        }

        String phone = value.trim();

        if (!phone.matches("\\d{10}")) {
            throw new ValidationException("El teléfono debe contener exactamente 10 dígitos.");
        }

        return phone;
    }
}
