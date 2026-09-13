package mx.unam.ciencias.nipgg.puellagame.model;

/**
 * Interfaz genérica que define el contrato para aquellas entidades del modelo
 * que poseen un identificador único.
 * Esta interfaz permite que clases como Cliente, Sucursal o Premio
 * puedan ser tratadas de manera polimórfica en cuanto a la obtención y
 * asignación de su llave primaria (ID).
 *
 * @param <K> El tipo de dato que se utilizará como identificador único
 */
public interface Identificable<K> {

    /**
     * Obtiene el identificador único de la entidad.
     *
     * @return El valor de la llave primaria (ID) de tipo {@code K}.
     */
    K getId();

    /**
     * Establece o actualiza el identificador único de la entidad.
     *
     * @param id El nuevo valor que se asignará como llave primaria. 
     *           Debe ser del tipo {@code K}.
     */
    void setId(K id);
}