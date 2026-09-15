package mx.unam.ciencias.nipgg.puellagame.ui;

import java.io.InputStream;
import java.io.PrintStream;
import java.util.Locale;
import java.util.Scanner;

import mx.unam.ciencias.nipgg.puellagame.exception.ValidationException;
import mx.unam.ciencias.nipgg.puellagame.validation.Validator;

/**
 * Lee datos de la consola y repite cada pregunta hasta obtener una respuesta
 * válida.
 *
 * <p>Centraliza las validaciones de interacción para que los submenús no
 * dupliquen mensajes ni reglas de entrada. Esta clase no cierra el flujo de
 * entrada, ya que normalmente corresponde a {@link System#in}.</p>
 *
 * @since 1.0
 */
public final class ConsoleInput {

    /** Escáner que consume las respuestas escritas en la consola. */
    private final Scanner scanner;

    /** Salida utilizada para mostrar preguntas y errores recuperables. */
    private final PrintStream output;

    /**
     * Construye un lector sobre los flujos indicados.
     *
     * @param input flujo del que se leen las respuestas
     * @param output flujo en el que se muestran preguntas y mensajes
     */
    public ConsoleInput(InputStream input, PrintStream output) {
        scanner = new Scanner(input);
        this.output = output;
    }

    /**
     * Lee una opción entera dentro de un intervalo inclusivo.
     *
     * @param prompt texto que se muestra antes de leer
     * @param minimum valor mínimo permitido
     * @param maximum valor máximo permitido
     * @return opción válida elegida por la persona usuaria
     * @throws IllegalArgumentException si el intervalo está invertido
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public int readOption(String prompt, int minimum, int maximum) {
        if (minimum > maximum) {
            throw new IllegalArgumentException("El intervalo de opciones es inválido.");
        }
        while (true) {
            String value = readLine(prompt);
            try {
                int option = Integer.parseInt(value.trim());
                if (option < minimum || option > maximum) {
                    output.printf("Elige una opción entre %d y %d.%n", minimum, maximum);
                    continue;
                }
                return option;
            } catch (NumberFormatException exception) {
                output.println("La opción debe ser un número entero.");
            }
        }
    }

    /**
     * Lee un texto obligatorio.
     *
     * @param prompt texto que se muestra antes de leer
     * @return texto sin espacios al inicio ni al final
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public String readRequiredText(String prompt) {
        while (true) {
            try {
                return Validator.validateNotEmpty(readLine(prompt));
            } catch (ValidationException exception) {
                showValidationError(exception);
            }
        }
    }

    /**
     * Lee un entero estrictamente positivo.
     *
     * @param prompt texto que se muestra antes de leer
     * @return entero positivo
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public int readPositiveInteger(String prompt) {
        while (true) {
            try {
                return Validator.validatePositiveInteger(readLine(prompt));
            } catch (ValidationException exception) {
                showValidationError(exception);
            }
        }
    }

    /**
     * Lee un entero no negativo.
     *
     * @param prompt texto que se muestra antes de leer
     * @return entero igual o mayor que cero
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public int readNonNegativeInteger(String prompt) {
        while (true) {
            try {
                return Validator.validateNonNegativeInteger(readLine(prompt));
            } catch (ValidationException exception) {
                showValidationError(exception);
            }
        }
    }

    /**
     * Lee un correo electrónico con formato válido.
     *
     * @param prompt texto que se muestra antes de leer
     * @return correo sin espacios exteriores
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public String readEmail(String prompt) {
        while (true) {
            try {
                return Validator.validateEmail(readLine(prompt));
            } catch (ValidationException exception) {
                showValidationError(exception);
            }
        }
    }

    /**
     * Lee un teléfono compuesto por exactamente diez dígitos.
     *
     * @param prompt texto que se muestra antes de leer
     * @return teléfono validado
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public String readPhone(String prompt) {
        while (true) {
            try {
                return Validator.validatePhone(readLine(prompt));
            } catch (ValidationException exception) {
                showValidationError(exception);
            }
        }
    }

    /**
     * Solicita una confirmación explícita de sí o no.
     *
     * @param prompt texto que describe la acción a confirmar
     * @return {@code true} para s o si; {@code false} para n o no
     * @throws IllegalStateException si el flujo de entrada termina
     */
    public boolean readConfirmation(String prompt) {
        while (true) {
            String answer = readLine(prompt + " (s/n): ").trim()
                    .toLowerCase(Locale.ROOT);
            if (answer.equals("s") || answer.equals("si")) {
                return true;
            }
            if (answer.equals("n") || answer.equals("no")) {
                return false;
            }
            output.println("Responde con s (sí) o n (no).");
        }
    }

    /**
     * Muestra una pregunta y consume la siguiente línea disponible.
     *
     * @param prompt texto que se muestra antes de leer
     * @return línea leída sin transformaciones
     * @throws IllegalStateException si el flujo de entrada terminó
     */
    private String readLine(String prompt) {
        output.print(prompt);
        if (!scanner.hasNextLine()) {
            throw new IllegalStateException("No hay más datos disponibles en la consola.");
        }
        return scanner.nextLine();
    }

    /**
     * Presenta un error de validación recuperable.
     *
     * @param exception error cuyo mensaje se mostrará
     */
    private void showValidationError(ValidationException exception) {
        output.println("Error: " + exception.getMessage());
    }
}
