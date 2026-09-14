package mx.unam.ciencias.nipgg.puellagame.model;

import java.util.Objects;

/**
 * Representa la entidad Sucursal dentro del sistema PuellaGame.
 * Esta clase modela la información de las sucursales del centro de
 * entretenimiento. Implementa la interfaz {@link Identificable}
 * utilizando {@code Integer} como tipo de dato para su llave primaria (ID).
 */
public class Sucursal implements Identificable<Integer> {

    /** Identificador único de la sucursal. */
    private Integer id;

    /** Nombre de la sucursal. */
    private String nombre;

    /** Dirección física de la sucursal. */
    private String direccion;

    /** Número telefónico de contacto de la sucursal. */
    private String telefono;

    /**
     * Constructor por defecto.
     * Crea una instancia vacía de la entidad Sucursal.
     */
    public Sucursal() {
    }

    /**
     * Constructor parametrizado.
     * Crea una instancia de la entidad Sucursal con todos sus atributos inicializados.
     *
     * @param id El identificador único de la sucursal.
     * @param nombre     El nombre de la sucursal.
     * @param direccion  La dirección física de la sucursal.
     * @param telefono   El número telefónico de contacto de la sucursal.
     */
    public Sucursal(Integer id, String nombre, String direccion, String telefono) {
        this.id = id;
        this.nombre = nombre;
        this.direccion = direccion;
        this.telefono = telefono;
    }

    /**
     * Obtiene el identificador único de la sucursal.
     *
     * @return El ID de la sucursal.
     */
    @Override
    public Integer getId() {
        return this.id;
    }

    /**
     * Establece el identificador único de la sucursal.
     *
     * @param id El ID a establecer.
     */
    @Override
    public void setId(Integer id) {
        this.id = id;
    }
    
    /**
     * Obtiene el nombre de la sucursal.
     *
     * @return El nombre de la sucursal.
     */
    public String getNombre() { return nombre; }

    /**
     * Establece el nombre de la sucursal.
     *
     * @param nombre El nombre de la sucursal a establecer.
     */
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    /**
     * Obtiene la dirección física de la sucursal.
     *
     * @return La dirección de la sucursal.
     */
    public String getDireccion() { return direccion; }

    /**
     * Establece la dirección física de la sucursal.
     *
     * @param direccion La dirección de la sucursal a establecer.
     */
    public void setDireccion(String direccion) { this.direccion = direccion; }
    
    /**
     * Obtiene el número telefónico de contacto de la sucursal.
     *
     * @return El teléfono de la sucursal.
     */
    public String getTelefono() { return telefono; }
    
    /**
     * Establece el número telefónico de contacto de la sucursal.
     *
     * @param telefono El teléfono de la sucursal a establecer.
     */
    public void setTelefono(String telefono) { this.telefono = telefono; }

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
        Sucursal sucursal = (Sucursal) o;
        return Objects.equals(id, sucursal.id);
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
     * El formato incluye el ID, el nombre, la dirección y el teléfono.
     *
     * @return Una cadena con la información principal de la entidad.
     */
    @Override
    public String toString() {
        return String.format("Sucursal [ID=%d, Nombre='%s', Dirección='%s', Teléfono='%s']", 
                id, nombre, direccion, telefono);
    }
}