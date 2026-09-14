package mx.unam.ciencias.nipgg.puellagame.model;

import java.util.Objects;

/**
 * Representa la entidad Premio dentro del sistema PuellaGame.
 * Esta clase modela la información de los premios que los clientes pueden
 * canjear con sus puntos acumulados. Implementa la interfaz {@link Identificable}
 * utilizando {@code Integer} como tipo de dato para su llave primaria (ID).
 */
public class Premio implements Identificable<Integer> {

    /** Identificador único del premio. */
    private Integer id;

    /** Nombre del premio. */
    private String nombre;

    /** Descripción del premio. */
    private String descripcion;

    /** Puntos requeridos para canjear el premio. */
    private Integer puntosRequeridos;

    /** Existencias disponibles del premio. */
    private Integer existencias;

    /**
     * Constructor por defecto.
     * Crea una instancia vacía de la entidad Premio.
     */
    public Premio() {
    }

    /**
     * Constructor parametrizado.
     * Crea una instancia de la entidad Premio con todos sus atributos inicializados.
     *
     * @param id        El identificador único del premio.
     * @param nombre          El nombre del premio.
     * @param descripcion     La descripción del premio.
     * @param puntosRequeridos Los puntos requeridos para canjear el premio.
     * @param existencias      Las existencias disponibles del premio.
     */
    public Premio(Integer id, String nombre, String descripcion, Integer puntosRequeridos, Integer existencias) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.puntosRequeridos = puntosRequeridos;
        this.existencias = existencias;
    }

    /**
     * Obtiene el identificador único del premio.
     *
     * @return El ID del premio.
     */
    @Override
    public Integer getId() {
        return this.id;
    }

    /**
     * Establece el identificador único del premio.
     *
     * @param id El ID a establecer.
     */
    @Override
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Obtiene el nombre del premio.
     *
     * @return El nombre del premio.
     */
    public String getNombre() { return nombre; }

    /**
     * Establece el nombre del premio.
     *
     * @param nombre El nombre a establecer.
     */
    public void setNombre(String nombre) { this.nombre = nombre; }

    /**
     * Obtiene la descripción del premio.
     *
     * @return La descripción del premio.
     */
    public String getDescripcion() { return descripcion; }

    /**
     * Establece la descripción del premio.
     *
     * @param descripcion La descripción a establecer.
     */
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }

    /**
     * Obtiene los puntos requeridos para canjear el premio.
     *
     * @return Los puntos requeridos.
     */
    public Integer getPuntosRequeridos() { return puntosRequeridos; }

    /**
     * Establece los puntos requeridos para canjear el premio.
     *
     * @param puntosRequeridos Los puntos a establecer.
     */
    public void setPuntosRequeridos(Integer puntosRequeridos) { this.puntosRequeridos = puntosRequeridos; }

    /**
     * Obtiene las existencias disponibles del premio.
     *
     * @return Las existencias disponibles.
     */
    public Integer getExistencias() { return existencias; }

    /**
     * Establece las existencias disponibles del premio.
     *
     * @param existencias Las existencias a establecer.
     */
    public void setExistencias(Integer existencias) { this.existencias = existencias; }

    /**
     * Compara esta entidad con otro objeto para determinar si son iguales.
     * La igualdad se basa <b>únicamente</b> en el identificador único (ID).
     * Dos objetos con el mismo ID se consideran la misma entidad.
     *
     * @param o El objeto con el cual comparar.
     * @return {@code true} si los IDs coinciden; {@code false} en caso contrario.
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Premio premio = (Premio) o;
        return Objects.equals(id, premio.id);
    }

    /**
     * Genera un código hash para la entidad.
     * El hash se calcula basándose exclusivamente en el identificador único (ID),
     * para mantener la consistencia con el método {@link #equals(Object)}.
     *
     * @return El código hash de la entidad.
     */
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    /**
     * Devuelve una representación en cadena de texto de la entidad.
     * El formato incluye el ID, el nombre, los puntos requeridos y las existencias.
     *
     * @return Una cadena con la información principal de la entidad.
     */
    @Override
    public String toString() {
        return String.format("Premio [ID=%d, Nombre='%s', Puntos=%d, Existencias=%d]", 
                id, nombre, puntosRequeridos, existencias);
    }
}