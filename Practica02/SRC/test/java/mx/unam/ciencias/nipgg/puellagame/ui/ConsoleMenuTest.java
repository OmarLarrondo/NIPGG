package mx.unam.ciencias.nipgg.puellagame.ui;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicInteger;

import org.junit.jupiter.api.Test;

/** Verifica la navegación principal sin depender de servicios de dominio. */
class ConsoleMenuTest {

    @Test
    void delegatesEveryEntityOptionAndThenExits() {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        ConsoleInput input = new ConsoleInput(
                new ByteArrayInputStream("1\n2\n3\n0\n".getBytes(StandardCharsets.UTF_8)),
                new PrintStream(output, true, StandardCharsets.UTF_8));
        AtomicInteger sucursales = new AtomicInteger();
        AtomicInteger premios = new AtomicInteger();
        AtomicInteger clientes = new AtomicInteger();
        ConsoleMenu menu = new ConsoleMenu(input, new PrintStream(output, true, StandardCharsets.UTF_8),
                sucursales::incrementAndGet, premios::incrementAndGet, clientes::incrementAndGet);

        menu.run();

        assertEquals(1, sucursales.get());
        assertEquals(1, premios.get());
        assertEquals(1, clientes.get());
        assertTrue(output.toString(StandardCharsets.UTF_8)
                .contains("Gracias por usar PuellaGame."));
    }
}
