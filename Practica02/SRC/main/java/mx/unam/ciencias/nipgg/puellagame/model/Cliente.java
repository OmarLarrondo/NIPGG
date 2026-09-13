package mx.unam.ciencias.nipgg.puellagame.model;

import java.util.Objects;

/**
 * Representa la entidad Cliente dentro del sistema PuellaGame.
 * Esta clase modela la información de los clientes que ingresan al centro de
 * entretenimiento. Implementa la interfaz {@link Identificable} utilizando
 * {@code Integer} como tipo de dato para su llave primaria (ID).
 */
public class Cliente implements Identificable<Integer> {

    /** Identificador único del cliente. */
    private Integer idCliente;
    
    /** Nombre completo del cliente. */
    private String nombre;
    
    /** Correo electrónico de contacto del cliente. */
    private String correo;
    
    /** Número telefónico de contacto del cliente. */
    private String telefono;
    
    /** Puntos acumulados por el cliente en el centro. */
    private Integer puntosAcumulados;

    /**
     * Constructor por defecto.
     * Crea una instancia vacía de la entidad. 
     */
    public Cliente() {
    }

    /**
     * Constructor parametrizado.
     * Crea una instancia de la entidad con todos sus atributos inicializados.
     *
     * @param idCliente        El identificador único de la entidad.
     * @param nombre           El nombre de la entidad.
     * @param correo           El correo electrónico asociado.
     * @param telefono         El número telefónico de contacto.
     * @param puntosAcumulados Los puntos acumulados.
     */
    public Cliente(Integer idCliente, String nombre, String correo, String telefono, Integer puntosAcumulados) {
        this.idCliente = idCliente;
        this.nombre = nombre;
        this.correo = correo;
        this.telefono = telefono;
        this.puntosAcumulados = puntosAcumulados;
    }

    /**
     * Obtiene el identificador único de la entidad.
     *
     * @return El ID de la entidad.
     */
    @Override
    public Integer getId() {
        return this.idCliente;
    }

    /**
     * Establece el identificador único de la entidad.
     *
     * @param id El ID a establecer.
     */
    @Override
    public void setId(Integer id) {
        this.idCliente = id;
    }

    /**
     * Obtiene el identificador único del cliente.
     * 
     * @return El ID del cliente.
     */
    public Integer getIdCliente() { return idCliente; }

    /**
     * Establece el identificador único del cliente.
     * 
     * @param idCliente El ID a establecer.
     */
    public void setIdCliente(Integer idCliente) { this.idCliente = idCliente; }

    /**
     * Obtiene el nombre del cliente.
     *
     * @return El nombre del cliente.
     */
    public String getNombre() { return nombre; }

    /**
     * Establece el nombre del cliente.
     *
     * @param nombre El nombre a establecer.
     */
    public void setNombre(String nombre) { this.nombre = nombre; }

    /**
     * Obtiene el correo electrónico del cliente.
     *
     * @return El correo electrónico del cliente.
     */
    public String getCorreo() { return correo; }

    /**
     * Establece el correo electrónico del cliente.
     *
     * @param correo El correo electrónico a establecer.
     */
    public void setCorreo(String correo) { this.correo = correo; }

    /**
     * Obtiene el número telefónico del cliente.
     *
     * @return El número telefónico del cliente.
     */
    public String getTelefono() { return telefono; }

    /**
     * Establece el número telefónico del cliente.
     *
     * @param telefono El número telefónico a establecer.
     */
    public void setTelefono(String telefono) { this.telefono = telefono; }

    /**
     * Obtiene los puntos acumulados del cliente.
     *
     * @return Los puntos acumulados del cliente.
     */
    public Integer getPuntosAcumulados() { return puntosAcumulados; }

    /**
     * Establece los puntos acumulados del cliente.
     *
     * @param puntosAcumulados Los puntos acumulados a establecer.
     */
    public void setPuntosAcumulados(Integer puntosAcumulados) { this.puntosAcumulados = puntosAcumulados; }

    /**
     * Compara esta entidad con otro objeto para determinar si son iguales.
     * La igualdad se basa <b>únicamente</b> en el identificador único (ID).
     * Dos objetos con el mismo ID se consideran la misma entidad
     *
     * @param o El objeto con el cual comparar.
     * @return {@code true} si los IDs coinciden; {@code false} en caso contrario.
     */
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Cliente cliente = (Cliente) o;
        return Objects.equals(idCliente, cliente.idCliente);
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
        return Objects.hash(idCliente);
    }

    /**
     * Devuelve una representación en cadena de texto de la entidad.
     * El formato incluye el ID, el nombre, el correo y los puntos acumulados.
     *
     * @return Una cadena con la información principal de la entidad.
     */
    @Override
    public String toString() {
        return String.format("Cliente [ID=%d, Nombre='%s', Correo='%s', Puntos=%d]", 
                idCliente, nombre, correo, puntosAcumulados);
    }
}
