package mx.unam.ciencias.nipgg.puellagame.validation;

import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

/**
 * Clase que prueba los métodos de validación de la clase Validator.
 */
public class ValidatorTest {

    /**
     * Prueba que un texto válido sea aceptado.
     */
    @Test
    public void testValidateNotEmptyWithValidValue() throws ValidationException {
        assertEquals("Juan", Validator.validateNotEmpty("Juan"));
    }

    /**
     * Prueba que una cadena vacía produzca una excepción.
     */
    @Test
    public void testValidateNotEmptyWithEmptyValue() {
        assertThrows(ValidationException.class, () -> Validator.validateNotEmpty(""));
    }

    /**
     * Prueba que una cadena que contiene únicamente espacios produzca una excepción.
     */
    @Test
    public void testValidateNotEmptyWithBlankValue() {
        assertThrows(ValidationException.class, () -> Validator.validateNotEmpty("   "));
    }

    /**
     * Prueba que un valor nulo produzca una excepción.
     */
    @Test
    public void testValidateNotEmptyWithNullValue() {
        assertThrows(ValidationException.class, () -> Validator.validateNotEmpty(null));
    }

    /**
     * Prueba que un entero positivo sea aceptado.
     */
    @Test
    public void testValidatePositiveIntegerWithValidValue() throws ValidationException {
        assertEquals(25, Validator.validatePositiveInteger("25"));
    }

    /**
     * Prueba que el cero sea rechazado como entero positivo.
     */
    @Test
    public void testValidatePositiveIntegerWithZero() {
        assertThrows(ValidationException.class, () -> Validator.validatePositiveInteger("0"));
    }

    /**
     * Prueba que un entero negativo sea rechazado.
     */
    @Test
    public void testValidatePositiveIntegerWithNegativeValue() {
        assertThrows(ValidationException.class, () -> Validator.validatePositiveInteger("-10"));
    }

    /**
     * Prueba que un valor que no es entero produzca una excepción.
     */
    @Test
    public void testValidatePositiveIntegerWithInvalidValue() {
        assertThrows(ValidationException.class,() -> Validator.validatePositiveInteger("abc")
        );
    }

    /**
     * Prueba que un número decimal sea rechazado como entero.
     */
    @Test
    public void testValidatePositiveIntegerWithDecimalValue() {
        assertThrows(ValidationException.class,() -> Validator.validatePositiveInteger("10.5")
        );
    }

    /**
     * Prueba que un entero no negativo sea aceptado.
     */
    @Test
    public void testValidateNonNegativeIntegerWithValidValue()
            throws ValidationException {

        assertEquals(25,Validator.validateNonNegativeInteger("25")
        );
    }

    /**
     * Prueba que el cero sea aceptado como entero no negativo.
     */
    @Test
    public void testValidateNonNegativeIntegerWithZero() throws ValidationException {
        assertEquals(0, Validator.validateNonNegativeInteger("0"));
    }

    /**
     * Prueba que un entero negativo sea rechazado.
     */
    @Test
    public void testValidateNonNegativeIntegerWithNegativeValue() {
        assertThrows(ValidationException.class, () -> Validator.validateNonNegativeInteger("-1"));
    }

    /**
     * Prueba que un valor no numérico sea rechazado.
     */
    @Test
    public void testValidateNonNegativeIntegerWithInvalidValue() {
        assertThrows(ValidationException.class, () -> Validator.validateNonNegativeInteger("abc"));
    }

    /**
     * Prueba que un correo electrónico válido sea aceptado.
     */
    @Test
    public void testValidateEmailWithValidValue() throws ValidationException {
        assertEquals("usuario@gmail.com", Validator.validateEmail("usuario@gmail.com"));
    }

    /**
     * Prueba que un correo sin arroba sea rechazado.
     */
    @Test
    public void testValidateEmailWithoutAtSymbol() {
        assertThrows(ValidationException.class, () -> Validator.validateEmail("usuariogmail.com"));
    }

    /**
     * Prueba que un correo sin dominio sea rechazado.
     */
    @Test
    public void testValidateEmailWithoutDomain() {
        assertThrows(ValidationException.class, () -> Validator.validateEmail("usuario@"));
    }

    /**
     * Prueba que un correo sin usuario sea rechazado.
     */
    @Test
    public void testValidateEmailWithoutUser() {
        assertThrows(ValidationException.class, () -> Validator.validateEmail("@gmail.com"));
    }

    /**
     * Prueba que un teléfono válido de diez dígitos sea aceptado.
     */
    @Test
    public void testValidatePhoneWithValidValue() throws ValidationException {
        assertEquals("5512345678", Validator.validatePhone("5512345678"));
    }

    /**
     * Prueba que un teléfono de nueve dígitos sea rechazado.
     */
    @Test
    public void testValidatePhoneWithNineDigits() {
        assertThrows(ValidationException.class, () -> Validator.validatePhone("551234567"));
    }

    /**
     * Prueba que un teléfono de once dígitos sea rechazado.
     */
    @Test
    public void testValidatePhoneWithElevenDigits() {
        assertThrows(ValidationException.class, () -> Validator.validatePhone("55123456789"));
    }

    /**
     * Prueba que un teléfono que contiene letras sea rechazado.
     */
    @Test
    public void testValidatePhoneWithLetters() {
        assertThrows(ValidationException.class, () -> Validator.validatePhone("551234ABCD"));
    }

    /**
     * Prueba que un teléfono con guiones sea rechazado.
     */
    @Test
    public void testValidatePhoneWithHyphens() {
        assertThrows(ValidationException.class, () -> Validator.validatePhone("55-1234-5678"));
    }
}
