package mx.unam.ciencias.nipgg.puellagame.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * Convierte registros CSV entre texto y listas de campos.
 *
 * <p>La implementación admite comas, comillas y saltos de línea dentro de
 * campos entrecomillados. Es interna para mantener reducida la interfaz
 * pública del paquete.</p>
 */
final class CsvFormat {

    /** Separador de columnas utilizado por PuellaGame. */
    private static final char COMMA = ',';

    /** Delimitador de campos que requieren escape. */
    private static final char QUOTE = '"';

    /** Impide crear instancias de esta clase utilitaria. */
    private CsvFormat() {
        throw new AssertionError("Esta clase no debe instanciarse");
    }

    /**
     * Convierte varios registros a texto CSV terminado en salto de línea.
     *
     * @param records registros que se desean serializar
     * @return representación CSV de los registros
     */
    static String write(List<List<String>> records) {
        Objects.requireNonNull(records, "Los registros no pueden ser nulos");
        return records.stream()
                .map(CsvFormat::writeRecord)
                .collect(Collectors.joining("\n", "", "\n"));
    }

    /**
     * Convierte un registro a una línea CSV.
     *
     * @param fields campos del registro
     * @return línea con los escapes necesarios
     */
    private static String writeRecord(List<String> fields) {
        Objects.requireNonNull(fields, "La fila no puede ser nula");
        return fields.stream()
                .map(CsvFormat::escape)
                .collect(Collectors.joining(String.valueOf(COMMA)));
    }

    /**
     * Escapa un campo cuando contiene caracteres significativos para CSV.
     *
     * @param field campo que se desea escribir
     * @return campo escapado
     */
    private static String escape(String field) {
        Objects.requireNonNull(field, "Los campos no pueden ser nulos");
        var escaped = field.replace("\"", "\"\"");
        return field.indexOf(COMMA) >= 0
                        || field.indexOf(QUOTE) >= 0
                        || field.indexOf('\n') >= 0
                        || field.indexOf('\r') >= 0
                ? QUOTE + escaped + QUOTE
                : escaped;
    }

    /**
     * Analiza un documento CSV completo.
     *
     * @param content contenido del archivo
     * @return registros y campos en orden de aparición
     * @throws CsvRepositoryException si las comillas o caracteres posteriores
     *         a una comilla de cierre son inválidos
     */
    static List<List<String>> parse(String content) {
        Objects.requireNonNull(content, "El contenido CSV no puede ser nulo");
        var records = new ArrayList<List<String>>();
        var record = new ArrayList<String>();
        var field = new StringBuilder();
        var inQuotes = false;
        var quoteClosed = false;
        var recordStarted = false;

        for (var index = 0; index < content.length(); index++) {
            var character = content.charAt(index);
            if (inQuotes) {
                if (character == QUOTE) {
                    if (index + 1 < content.length()
                            && content.charAt(index + 1) == QUOTE) {
                        field.append(QUOTE);
                        index++;
                    } else {
                        inQuotes = false;
                        quoteClosed = true;
                    }
                } else {
                    field.append(character);
                }
                continue;
            }

            if (quoteClosed && character != COMMA
                    && character != '\n' && character != '\r') {
                throw new CsvRepositoryException(
                        "Se encontró un carácter inválido después de una comilla de cierre");
            }
            if (character == QUOTE) {
                if (field.length() != 0) {
                    throw new CsvRepositoryException(
                            "Se encontró una comilla dentro de un campo sin escapar");
                }
                inQuotes = true;
                recordStarted = true;
            } else if (character == COMMA) {
                record.add(field.toString());
                field.setLength(0);
                quoteClosed = false;
                recordStarted = true;
            } else if (character == '\n' || character == '\r') {
                if (character == '\r' && index + 1 < content.length()
                        && content.charAt(index + 1) == '\n') {
                    index++;
                }
                record.add(field.toString());
                addRecord(records, record);
                record = new ArrayList<>();
                field.setLength(0);
                quoteClosed = false;
                recordStarted = false;
            } else {
                field.append(character);
                recordStarted = true;
            }
        }

        if (inQuotes) {
            throw new CsvRepositoryException(
                    "El archivo termina dentro de un campo entrecomillado");
        }
        if (recordStarted || !record.isEmpty() || field.length() > 0) {
            record.add(field.toString());
            addRecord(records, record);
        }
        return List.copyOf(records);
    }

    /**
     * Agrega un registro inmutable y rechaza líneas completamente vacías.
     *
     * @param records destino de los registros analizados
     * @param record registro que acaba de terminar
     */
    private static void addRecord(
            List<List<String>> records, List<String> record) {
        if (record.size() == 1 && record.getFirst().isEmpty()) {
            throw new CsvRepositoryException(
                    "El archivo CSV contiene una línea vacía");
        }
        records.add(List.copyOf(record));
    }
}
