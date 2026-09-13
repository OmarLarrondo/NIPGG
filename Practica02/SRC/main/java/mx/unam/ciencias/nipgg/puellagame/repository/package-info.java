/**
 * Contratos y componentes para persistir entidades de PuellaGame en archivos
 * CSV. El paquete ofrece operaciones CRUD síncronas y asíncronas, conserva el
 * orden de los registros y protege cada archivo frente a accesos concurrentes.
 *
 * <p>La persistencia es independiente de los modelos concretos: cada entidad
 * aporta sus funciones de conversión mediante
 * {@link mx.unam.ciencias.nipgg.puellagame.repository.CsvSchema}.</p>
 *
 * @since 1.0
 */
package mx.unam.ciencias.nipgg.puellagame.repository;
