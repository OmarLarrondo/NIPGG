package mx.unam.ciencias.nipgg.puellagame.ui;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.jupiter.api.Test;

/** Verifica el submenú CRUD sin requerir una implementación de servicios. */
class CrudConsoleMenuTest {

    @Test
    void delegatesAllCrudOperations() {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        PrintStream printStream = new PrintStream(output, true, StandardCharsets.UTF_8);
        ConsoleInput input = new ConsoleInput(
                new ByteArrayInputStream("1\n2\n3\n4\n0\n".getBytes(StandardCharsets.UTF_8)),
                printStream);
        AtomicInteger operations = new AtomicInteger();
        CrudConsoleMenu menu = new CrudConsoleMenu("Premios", input, printStream,
                operations::incrementAndGet, operations::incrementAndGet,
                operations::incrementAndGet, operations::incrementAndGet);

        menu.run();

        assertEquals(4, operations.get());
        assertTrue(output.toString(StandardCharsets.UTF_8).contains("Consultar por ID"));
    }
}
