package mx.unam.ciencias.nipgg.puellagame.repository;

import java.util.List;
import java.util.Objects;
import java.util.function.Function;

/**
 * Describe cómo convertir una entidad a una fila CSV y reconstruirla.
 *
 * <p>Las funciones permiten integrar modelos concretos sin acoplar la capa de
 * persistencia a sus constructores o métodos de acceso.</p>
 *
 * @param <T> tipo de entidad
 * @param <K> tipo de la llave única
 * @since 1.0
 */
public final class CsvSchema<T, K> {

    /** Nombres de las columnas en el orden persistido. */
    private final List<String> header;

    /** Función pura que obtiene la llave de una entidad. */
    private final Function<T, K> keyExtractor;

    /** Función pura que transforma una entidad en campos. */
    private final Function<T, List<String>> encoder;

    /** Función pura que transforma campos en una entidad. */
    private final Function<List<String>, T> decoder;

    /**
     * Construye un esquema funcional de persistencia.
     *
     * @param header columnas esperadas, en su orden exacto
     * @param keyExtractor función que obtiene la llave de una entidad
     * @param encoder función que convierte una entidad a campos de texto
     * @param decoder función que reconstruye una entidad a partir de campos
     * @throws NullPointerException si algún argumento o columna es nulo
     * @throws IllegalArgumentException si no hay columnas, una columna está
     *         vacía o existen nombres repetidos
     */
    public CsvSchema(
            List<String> header,
            Function<T, K> keyExtractor,
            Function<T, List<String>> encoder,
            Function<List<String>, T> decoder) {
        Objects.requireNonNull(header, "El encabezado no puede ser nulo");
        this.header = List.copyOf(header);
        this.keyExtractor = Objects.requireNonNull(
                keyExtractor, "La función de llave no puede ser nula");
        this.encoder = Objects.requireNonNull(
                encoder, "La función de codificación no puede ser nula");
        this.decoder = Objects.requireNonNull(
                decoder, "La función de decodificación no puede ser nula");
        validateHeader();
    }

    /**
     * Devuelve las columnas inmutables del esquema.
     *
     * @return encabezado esperado
     */
    public List<String> header() {
        return header;
    }

    /**
     * Obtiene la llave no nula de una entidad.
     *
     * @param entity entidad que se desea identificar
     * @return llave de la entidad
     * @throws NullPointerException si la entidad o su llave son nulas
     */
    public K keyOf(T entity) {
        Objects.requireNonNull(entity, "La entidad no puede ser nula");
        return Objects.requireNonNull(
                keyExtractor.apply(entity), "La llave no puede ser nula");
    }

    /**
     * Codifica y valida el número de campos de una entidad.
     *
     * @param entity entidad que se desea convertir
     * @return campos inmutables listos para escribirse
     * @throws CsvRepositoryException si la función falla o produce una fila
     *         incompatible con el encabezado
     */
    public List<String> encode(T entity) {
        try {
            var fields = List.copyOf(Objects.requireNonNull(
                    encoder.apply(Objects.requireNonNull(entity,
                            "La entidad no puede ser nula")),
                    "La fila codificada no puede ser nula"));
            validateColumnCount(fields);
            return fields;
        } catch (CsvRepositoryException exception) {
            throw exception;
        } catch (RuntimeException exception) {
            throw new CsvRepositoryException(
                    "No fue posible convertir la entidad a CSV", exception);
        }
    }

    /**
     * Decodifica una fila después de validar su número de columnas.
     *
     * @param fields campos leídos del archivo
     * @return entidad reconstruida
     * @throws CsvRepositoryException si la función falla o la fila no tiene
     *         el número esperado de columnas
     */
    public T decode(List<String> fields) {
        try {
            var immutableFields = List.copyOf(Objects.requireNonNull(
                    fields, "La fila no puede ser nula"));
            validateColumnCount(immutableFields);
            return Objects.requireNonNull(decoder.apply(immutableFields),
                    "La entidad decodificada no puede ser nula");
        } catch (CsvRepositoryException exception) {
            throw exception;
        } catch (RuntimeException exception) {
            throw new CsvRepositoryException(
                    "No fue posible convertir una fila CSV en una entidad",
                    exception);
        }
    }

    /**
     * Verifica que el encabezado sea utilizable y no tenga duplicados.
     */
    private void validateHeader() {
        if (header.isEmpty()) {
            throw new IllegalArgumentException(
                    "El encabezado debe contener al menos una columna");
        }
        if (header.stream().anyMatch(Objects::isNull)) {
            throw new NullPointerException(
                    "Las columnas del encabezado no pueden ser nulas");
        }
        if (header.stream().anyMatch(String::isBlank)) {
            throw new IllegalArgumentException(
                    "Las columnas del encabezado no pueden estar vacías");
        }
        if (header.stream().distinct().count() != header.size()) {
            throw new IllegalArgumentException(
                    "El encabezado no puede contener columnas repetidas");
        }
    }

    /**
     * Comprueba que una fila coincida con el ancho del esquema.
     *
     * @param fields campos que se desean validar
     */
    private void validateColumnCount(List<String> fields) {
        if (fields.size() != header.size()) {
            throw new CsvRepositoryException(
                    "La fila contiene " + fields.size() + " columnas; se esperaban "
                            + header.size());
        }
    }
}
