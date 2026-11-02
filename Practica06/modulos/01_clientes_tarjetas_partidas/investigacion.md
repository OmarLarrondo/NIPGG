# Mantenimiento de llaves foráneas: NO ACTION

**Autor:** Omar Alejandro Juárez Larrondo · **Cuenta:** 322245244
Fundamentos de Bases de Datos · Práctica 06 · Equipo ÑIPGG
**Entorno comprobado:** PostgreSQL 18.6 · 2 de noviembre de 2026.

## 1. ¿Qué es una política de mantenimiento de llaves foráneas?

Es la acción referencial que una restricción FOREIGN KEY define para mantener
la relación entre una fila hija y su fila referenciada cuando esta última se
elimina o cambia su clave. Se especifican por separado ON DELETE y ON UPDATE.
La acción corresponde a operaciones sobre las filas, no a DROP TABLE.
Eliminar una tabla tiene reglas de dependencias distintas.

En este esquema, Partida referencia la pareja (idCliente, numeroTarjeta) de
Tarjeta. La integridad exige que esa pareja exista completa. La política decide
qué ocurre al borrar la tarjeta o corregir alguno de esos componentes. No basta
con que cada componente aparezca por separado en tarjetas diferentes.

PostgreSQL ofrece NO ACTION, RESTRICT, CASCADE, SET NULL y SET DEFAULT. No es
necesario elegir una única acción para toda la base: la decisión depende de la
relación y de si se está borrando o actualizando. Las acciones no permiten
insertar referencias inexistentes. [1]

## 2. ¿Cómo se indica NO ACTION en SQL?

```sql
ALTER TABLE "Partida" DROP CONSTRAINT fk_partida_tarjeta;
ALTER TABLE "Partida" ADD CONSTRAINT fk_partida_tarjeta
    FOREIGN KEY ("idCliente", "numeroTarjeta")
    REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    NOT DEFERRABLE;
```

El ejemplo ilustra ambas operaciones con NO ACTION; no es la elección final de
UPDATE para Partida. En mi implementación utilizo ON DELETE NO ACTION y
ON UPDATE CASCADE. Cuando se omiten las acciones, el valor predeterminado es
NO ACTION; las escribo explícitamente para que el criterio sea revisable. [1]

## 3. Objeto y funcionamiento

NO ACTION conserva la comprobación de la referencia y rechaza la operación si,
al comprobar la FK, quedan hijos sin padre. No borra hijos ni les asigna un valor
alternativo. NOT DEFERRABLE es el comportamiento de las FK de mi módulo: la
violación no puede mantenerse entre sentencias para repararla más tarde.

Una FK con NO ACTION puede declararse DEFERRABLE. Si se difiere, se permite
reparar una inconsistencia temporal antes de comprobarla; una inconsistencia
que persiste no puede confirmarse. RESTRICT no permite posponer su acción sobre
el padre. No se debe confundir NO ACTION con ignorar la integridad. [1][2]

### Ejemplo reproducible de comprobación diferida

Ejecutar esta secuencia en una sesión de prueba. Son tablas temporales,
independientes del modelo de negocio.

```sql
BEGIN;
CREATE TEMP TABLE padre_demo(id integer PRIMARY KEY);
CREATE TEMP TABLE hijo_demo(
    id integer PRIMARY KEY,
    padre integer NOT NULL,
    CONSTRAINT fk_demo FOREIGN KEY(padre) REFERENCES padre_demo(id)
        ON DELETE NO ACTION ON UPDATE NO ACTION
        DEFERRABLE INITIALLY IMMEDIATE
);
INSERT INTO padre_demo VALUES (1);
INSERT INTO hijo_demo VALUES (1, 1);

-- Sin diferir, cambiar 1 por 2 en el padre viola fk_demo.
SET CONSTRAINTS fk_demo DEFERRED;
UPDATE padre_demo SET id = 2 WHERE id = 1;
UPDATE hijo_demo SET padre = 2 WHERE padre = 1;
SET CONSTRAINTS fk_demo IMMEDIATE; -- La pareja reparada es válida.
SELECT p.id, h.padre FROM padre_demo p JOIN hijo_demo h ON h.padre=p.id;
-- Resultado: 2 | 2.
ROLLBACK;
```

Las pruebas del módulo ejecutan además el caso inmediato, que rechaza el cambio,
y una FK RESTRICT declarada diferible, cuya acción sigue rechazándolo.

## 4. Ventajas y desventajas

**Ventajas.** En las relaciones que decido proteger, impide borrar el padre
mientras se conserve historial asociado. Hace visible la necesidad de resolver
las dependencias antes de borrar. No elimina saldo, puntos ni partidas como
efecto secundario. Cuando se requiere una corrección coordinada de claves,
NO ACTION con una FK diferible permite organizarla dentro de una transacción.

**Desventajas.** El borrado puede requerir intervención explícita sobre las
referencias y fallar al existir dependencias indirectas. Usarlo también en
UPDATE obliga a coordinar manualmente las correcciones de claves; por eso elijo
CASCADE en UPDATE. Diferir la comprobación introduce estados temporales que
requieren disciplina transaccional. Una FK tampoco evita que alguien elimine
explícitamente el historial: esa protección adicional corresponde a permisos y
reglas de negocio.

## Compatibilidad y aplicación

Las columnas del módulo son NOT NULL y no tienen DEFAULT. NO ACTION y CASCADE
son compatibles con ese diseño. SET NULL chocaría con la obligatoriedad;
SET DEFAULT no proporciona un padre válido por sí mismo. No cambio dominios,
claves ni nombres de la práctica anterior. Las seis sustituciones se hacen con
ALTER TABLE dentro de una transacción.

Los contactos usan DELETE CASCADE porque son dependientes del cliente; Tarjeta
y Partida usan DELETE NO ACTION porque la tarjeta conserva recursos y la
partida registra actividad. Las seis FK usan UPDATE CASCADE para mantener sus
referencias ante correcciones de identificadores. La decisión completa por
relación se presenta en la justificación.

## Documentación con COMMENT

Los comentarios se guardan como metadatos de PostgreSQL con COMMENT ON TABLE,
COMMENT ON COLUMN y COMMENT ON CONSTRAINT. Se aplican después de sustituir las
FK, porque borrar una restricción elimina también su comentario. Se comprueban
con obj_description y col_description. [3]

En PostgreSQL 18 las restricciones NOT NULL aparecen también en pg_constraint;
se comentan las 26, además de las 36 restricciones PK, UNIQUE, CHECK y FK. [4]

## Fuentes oficiales

Consulta: 2 de noviembre de 2026; documentación correspondiente a PostgreSQL 18.

1. PostgreSQL, §5.5.5, Foreign Keys: acciones referenciales.
   https://www.postgresql.org/docs/18/ddl-constraints.html#DDL-CONSTRAINTS-FK
2. PostgreSQL, SET CONSTRAINTS: comprobación inmediata y diferida.
   https://www.postgresql.org/docs/18/sql-set-constraints.html
3. PostgreSQL, COMMENT: sintaxis, persistencia y consulta de comentarios.
   https://www.postgresql.org/docs/18/sql-comment.html
4. PostgreSQL, pg_constraint: catálogo de restricciones.
   https://www.postgresql.org/docs/18/catalog-pg-constraint.html
