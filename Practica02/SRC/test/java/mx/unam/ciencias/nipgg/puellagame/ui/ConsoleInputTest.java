package mx.unam.ciencias.nipgg.puellagame.ui;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;

import org.junit.jupiter.api.Test;

/** Verifica entradas de consola que no dependen de los servicios del dominio. */
class ConsoleInputTest {

    @Test
    void repeatsAnInvalidOptionUntilReceivingOneInRange() {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        ConsoleInput input = inputFor("letras\n4\n2\n", output);

        assertEquals(2, input.readOption("Opción: ", 0, 3));
        assertTrue(output.toString(StandardCharsets.UTF_8)
                .contains("La opción debe ser un número entero."));
        assertTrue(output.toString(StandardCharsets.UTF_8)
                .contains("Elige una opción entre 0 y 3."));
    }

    @Test
    void validatesEmailAndPhoneBeforeReturningThem() {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        ConsoleInput input = inputFor("correo-invalido\nana@ejemplo.mx\n123\n5512345678\n",
                output);

        assertEquals("ana@ejemplo.mx", input.readEmail("Correo: "));
        assertEquals("5512345678", input.readPhone("Teléfono: "));
        assertTrue(output.toString(StandardCharsets.UTF_8).contains("Error:"));
    }

    @Test
    void readsOnlyExplicitConfirmations() {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        ConsoleInput input = inputFor("tal vez\ns\nn\n", output);

        assertTrue(input.readConfirmation("¿Continuar?"));
        assertFalse(input.readConfirmation("¿Eliminar?"));
        assertTrue(output.toString(StandardCharsets.UTF_8)
                .contains("Responde con s (sí) o n (no)."));
    }

    private ConsoleInput inputFor(String data, ByteArrayOutputStream output) {
        return new ConsoleInput(new ByteArrayInputStream(data.getBytes(StandardCharsets.UTF_8)),
                new PrintStream(output, true, StandardCharsets.UTF_8));
    }
}
