# Investigación: RESTRICT y comparación con NO ACTION

**Autor:** Yahir · 
**Entorno de referencia:** PostgreSQL 18 · 
**Documentación consultada:** 2 de noviembre de 2026  

## 1. ¿Qué es RESTRICT dentro de las políticas de mantenimiento?

`RESTRICT` es una acción referencial que se especifica por separado en `ON DELETE` y `ON UPDATE` dentro de una restricción `FOREIGN KEY`. Su función es impedir que se elimine o actualice una fila padre si existe al menos una fila hija que la referencia, incluso si el estado resultante de la operación no violaría la restricción de clave externa. Dicho de otro modo, `RESTRICT` no permite siquiera que la operación del padre se ejecute cuando hay dependencias; no espera a comprobar si el hijo se “arregla” después dentro de la misma transacción.

Esta política encaja en relaciones donde las tablas representan objetos independientes y se quiere obligar a que la aplicación sea explícita: primero se resuelven las referencias y luego se elimina el padre.

## 2. Sintaxis SQL de RESTRICT

La acción se declara directamente en la definición de la FK o al sustituirla con `ALTER TABLE`. A continuación se muestra la forma completa para una FK simple y para una FK compuesta, tomando como referencia las relaciones de tu módulo.

### FK simple:

```sql
ALTER TABLE "HORARIO_SUCURSAL" 
  DROP CONSTRAINT fk_horario_sucursal;

ALTER TABLE "HORARIO_SUCURSAL" 
  ADD CONSTRAINT fk_horario_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
    NOT DEFERRABLE;
```

### FK compuesta:

```sql
ALTER TABLE "VISITA" 
  DROP CONSTRAINT fk_visita_tarjeta;

ALTER TABLE "VISITA" 
  ADD CONSTRAINT fk_visita_tarjeta
    FOREIGN KEY ("idCliente", "numeroTarjeta")
    REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
    ON DELETE RESTRICT
    ON UPDATE RESTRICT
    NOT DEFERRABLE;
```

## 3. Objeto y funcionamiento de RESTRICT

**Objeto.** `RESTRICT` existe para bloquear la operación sobre el padre cuando hay hijos que lo referencian. No borra hijos, no les asigna un valor alternativo y no propaga la eliminación. La operación del padre falla con un error de violación de clave externa. La comprobación se hace contra la existencia de filas hijas, sin importar si después, dentro de la misma transacción, esas filas podrían llegar a ser válidas mediante otra sentencia.

**Diferencia esencial con NO ACTION.** Ambos rechazan la operación cuando quedan hijos sin padre, pero difieren en el momento de la comprobación:
- **`NO ACTION`** es la acción predeterminada. Permite que la restricción se declare `DEFERRABLE` y que la comprobación se posponga hasta el final de la transacción. Así, se puede eliminar el padre y luego reparar la situación insertando otro padre válido o borrando los hijos huérfanos antes de que la restricción se verifique.
- **`RESTRICT`** es más estricto: no permite diferir la comprobación. La operación del padre se rechaza en el momento, aunque la restricción sea diferible.

**Diferencia adicional en ON UPDATE.** En una actualización del padre, `NO ACTION` deja que la actualización se ejecute y luego comprueba la FK contra el estado resultante. `RESTRICT` impide la actualización incluso si el estado posterior seguiría satisfaciendo la restricción; esto evita, por ejemplo, actualizar una clave a un valor distinto pero que compara como igual (por ejemplo, una cadena con otra variante de mayúsculas bajo una colación insensible a mayúsculas).

### Ejemplo : RESTRICT frente a NO ACTION diferible

El siguiente ejemplo usa tablas temporales y muestra que una FK `RESTRICT` no se puede diferir aunque se declare `DEFERRABLE`, mientras que una FK `NO ACTION` sí.
```sql
BEGIN;

-- Tablas de demostración
CREATE TEMP TABLE padre_restrict (id integer PRIMARY KEY);

CREATE TEMP TABLE hijo_restrict (
    id integer PRIMARY KEY,
    padre integer NOT NULL,
    CONSTRAINT fk_restrict FOREIGN KEY (padre)
        REFERENCES padre_restrict (id)
        ON DELETE RESTRICT ON UPDATE RESTRICT
        DEFERRABLE INITIALLY IMMEDIATE  -- Aunque se declare diferible
);

INSERT INTO padre_restrict VALUES (1);
INSERT INTO hijo_restrict VALUES (1, 1);

-- Intentar diferir una FK RESTRICT no evita el error
SET CONSTRAINTS fk_restrict DEFERRED;

DELETE FROM padre_restrict WHERE id = 1;
-- ERROR:  update or delete on table "padre_restrict" violates foreign key constraint "fk_restrict" on table "hijo_restrict"
-- DETALLE:  Key (id)=(1) is still referenced from table "hijo_restrict".

ROLLBACK;

-- Comparación con NO ACTION diferible
BEGIN;

CREATE TEMP TABLE padre_no_action (id integer PRIMARY KEY);

CREATE TEMP TABLE hijo_no_action (
    id integer PRIMARY KEY,
    padre integer NOT NULL,
    CONSTRAINT fk_no_action FOREIGN KEY (padre)
        REFERENCES padre_no_action (id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
        DEFERRABLE INITIALLY IMMEDIATE
);

INSERT INTO padre_no_action VALUES (1);
INSERT INTO hijo_no_action VALUES (1, 1);

SET CONSTRAINTS fk_no_action DEFERRED;

DELETE FROM padre_no_action WHERE id = 1;       -- Se permite porque la comprobación está diferida
DELETE FROM hijo_no_action WHERE padre = 1;      -- Se repara antes de la comprobación

SET CONSTRAINTS fk_no_action IMMEDIATE;          -- La restricción se verifica y es válida

SELECT * FROM padre_no_action;                   -- Resultado: 0 filas (padre eliminado)
SELECT * FROM hijo_no_action;                    -- Resultado: 0 filas (hijo eliminado)

ROLLBACK;
```

En el primer bloque, `SET CONSTRAINTS ... DEFERRED` no logra diferir la acción de `RESTRICT`: el `DELETE` sobre el padre falla inmediatamente. En el segundo, `NO ACTION` sí permite reparar la inconsistencia dentro de la transacción. Este contraste es justamente el que se debe documentar en la pregunta 3 del informe.

## 4. Ventajas y desventajas de RESTRICT
### Ventajas
* **Protección estricta e inmediata:** Bloquea instantáneamente modificaciones no deseadas en la fila padre al ejecutar la sentencia, haciendo visible la dependencia de inmediato.
* **Comportamiento concurrente predecible:** Al no diferir la validación al `COMMIT`, evita que otras sesiones observen estados temporales inconsistentes.
* **Ideal para entidades independientes:** Fuerza a la aplicación a gestionar explícitamente el orden de eliminación/actualización en objetos con ciclo de vida propio.
* **Sin ambigüedad en `ON UPDATE`:** Impide actualizaciones en la clave del padre incluso cuando el valor resultante compare como idéntico (p. ej., variaciones de mayúsculas bajo colaciones insensibles).
### Desventajas
* **Sin correcciones diferidas:** Impide realizar actualizaciones cruzadas dentro de la misma transacción (obliga a modificar primero a los hijos o remover temporalmente la FK).
* **Posibles bloqueos en cascada cruzados:** En esquemas complejos (como de 38 FK), una modificación puede fallar debido a dependencias de módulos externos no contemplados a simple vista.
* **No protege borrados directos del hijo:** Evita la eliminación desde el padre, pero no detiene sentencias `DELETE` ejecutadas directamente en las tablas hijas.
* **Ineficiente en dependencias fuertes:** En relaciones dependientes (ej. detalles/contactos), resulta menos práctico que `CASCADE`, sobrecargando la lógica de la aplicación.

## 5. Compatibilidad

* **Compatibilidad directa:** No exige columnas anulables (`NULL`) ni valores predeterminados; se adapta perfectamente a las FK sin alterar el diseño de dominios o columnas.
* **Claves compuestas e integrales:** En FK compuestas, `RESTRICT` debe aplicarse a la clave completa en el `ALTER TABLE`, no por columna individual.
* **Comprobación inmediata por sentencia:** Aunque la restricción se marque como `DEFERRABLE`, `RESTRICT` evaluará la integridad al terminar la sentencia, influyendo en la arquitectura de transacciones.
* **Criterio de aplicación:** Recomendado para entidades independientes y registros históricos; poco conveniente frente a dependencias subordinadas donde `CASCADE` simplifica el mantenimiento.
* **Integración multimodular:** Exige pruebas de integración globales, ya que un rechazo por `RESTRICT` al modificar un padre puede provenir de FK configuradas por otros módulos.

## 6. Fuentes oficiales

1. PostgreSQL, `CREATE TABLE`, sección de acciones referenciales (`NO ACTION`, `RESTRICT`, `CASCADE`, `SET NULL`, `SET DEFAULT`) y cláusulas de diferibilidad.  
   [https://www.postgresql.org/docs/18/sql-createtable.html](https://www.postgresql.org/docs/18/sql-createtable.html)
2. PostgreSQL, 5.5.5. Foreign Keys, diferencia esencial entre `NO ACTION` y `RESTRICT`.  
   [https://www.postgresql.org/docs/18/ddl-constraints.html#DDL-CONSTRAINTS-FK](https://www.postgresql.org/docs/18/ddl-constraints.html#DDL-CONSTRAINTS-FK)
3. PostgreSQL, `SET CONSTRAINTS`, comprobación inmediata y diferida de restricciones.  
   [https://www.postgresql.org/docs/18/sql-set-constraints.html](https://www.postgresql.org/docs/18/sql-set-constraints.html)
4. PostgreSQL, `pg_constraint`, catálogo de restricciones (para verificar el estado de las FK y sus acciones).  
   [https://www.postgresql.org/docs/18/catalog-pg-constraint.html](https://www.postgresql.org/docs/18/catalog-pg-constraint.html)
