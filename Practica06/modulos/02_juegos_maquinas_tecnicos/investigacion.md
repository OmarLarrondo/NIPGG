# Mantenimiento de llaves foráneas: CASCADE

**Autor:** Miguel Ángel Jiménez Ramírez · **Cuenta:** 119000887
Fundamentos de Bases de Datos · Práctica 06 · Equipo ÑIPGG
**Fecha de preparación:** 2 de noviembre de 2026.

## 2. ¿Cómo se indica CASCADE en SQL?

Las acciones se declaran en la FK de la tabla hija, por separado para DELETE
y UPDATE del padre. La siguiente definición es una elección real del módulo:

```sql
BEGIN;
ALTER TABLE "Certificaciones"
    DROP CONSTRAINT fk_certificacion_tecnico;
ALTER TABLE "Certificaciones"
    ADD CONSTRAINT fk_certificacion_tecnico
    FOREIGN KEY ("CURP") REFERENCES "Técnico" ("CURP")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;
COMMIT;
```

ON DELETE CASCADE elimina los hijos que referencian la fila borrada;
ON UPDATE CASCADE copia a sus referencias el nuevo valor de la clave del padre.
Las acciones no se aplican a una columna del padre que no participa en la
referencia. Cada FK conserva sus propias acciones. (PostgreSQL Global
Development Group, s. f.-a, s. f.-b).

El archivo politicas.sql sustituye las nueve FK con ALTER TABLE y conserva
nombres y columnas. DROP y ADD se agrupan en una transacción; después se
aplican los comentarios de las restricciones recreadas. (PostgreSQL Global
Development Group, s. f.-c).

## 3. Objeto y funcionamiento

CASCADE automatiza la conservación de referencias al modificar o eliminar
un padre. Actúa del padre hacia los hijos: borrar una certificación no borra al
técnico. Si otra FK impide borrar al técnico, la sentencia completa falla y se
revierten también los borrados que hubiera propagado. No sustituye la validación
de INSERT o UPDATE del hijo con un padre inexistente. (PostgreSQL Global
Development Group, s. f.-a, s. f.-b).

### Ejemplo reproducible independiente del modelo de negocio

Este ejemplo ilustra el riesgo de borrar una cadena completa. Sus tablas
temporales no reemplazan las decisiones conservadoras del esquema real.

```sql
BEGIN;
CREATE TEMP TABLE tipo_demo(id integer PRIMARY KEY);
CREATE TEMP TABLE juego_demo(
    id integer PRIMARY KEY, tipo integer NOT NULL,
    FOREIGN KEY(tipo) REFERENCES tipo_demo(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TEMP TABLE maquina_demo(
    id integer PRIMARY KEY, juego integer NOT NULL,
    FOREIGN KEY(juego) REFERENCES juego_demo(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TEMP TABLE mantenimiento_demo(
    id integer PRIMARY KEY, maquina integer NOT NULL,
    FOREIGN KEY(maquina) REFERENCES maquina_demo(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO tipo_demo VALUES(1);
INSERT INTO juego_demo VALUES(10,1);
INSERT INTO maquina_demo VALUES(100,10);
INSERT INTO mantenimiento_demo VALUES(1000,100);

UPDATE tipo_demo SET id=2 WHERE id=1;
SELECT id,tipo FROM juego_demo; -- 10 | 2.
SELECT id,juego FROM maquina_demo; -- 100 | 10.
-- La PK independiente del juego no cambió; la actualización no salta niveles.

DELETE FROM tipo_demo WHERE id=2;
SELECT (SELECT count(*) FROM tipo_demo) AS tipos,
       (SELECT count(*) FROM juego_demo) AS juegos,
       (SELECT count(*) FROM maquina_demo) AS maquinas,
       (SELECT count(*) FROM mantenimiento_demo) AS mantenimientos;
-- Resultado: 0 | 0 | 0 | 0. Cada FK DELETE CASCADE propaga el borrado.
ROLLBACK;
```

El ejemplo y la diferencia entre actualizar una FK y actualizar una PK propia
también se comprueban en pruebas.sql. Las tablas TEMP están limitadas a la
sesión y la transacción revierte todos los cambios.

## 4. Ventajas y desventajas

**Ventajas.** Para contactos y certificaciones, DELETE CASCADE evita dejar
valores sin propietario y elimina pasos manuales de limpieza. UPDATE CASCADE
permite corregir una CURP sin reasignar manualmente cada contacto y cada
mantenimiento. Cuando la referencia es parte de una PK compuesta, conserva
los otros componentes: corregir idMaquina no cambia idMantenimiento.

**Desventajas.** Un borrado aparentemente pequeño puede alcanzar numerosas
filas dependientes; no equivale a conservar una auditoría. Por eso no elijo
borrar máquinas ni mantenimientos al borrar un catálogo o una sucursal. Las
cadenas también pueden quedar bloqueadas por FK de otro módulo. El equipo debe
conocer todas las dependencias para prever el resultado.

CASCADE no elimina CHECK, NOT NULL, PK ni UNIQUE: una actualización que genere
una clave duplicada sigue siendo inválida. Tampoco corrige referencias ya
inexistentes ni resuelve por sí mismo la concurrencia o la trazabilidad de las
correcciones. El diseño necesita decidir qué relaciones representan valores
dependientes y cuáles representan entidades o historial.

## Compatibilidad con el esquema

El módulo tiene 8 tablas, 34 columnas y 9 FK. Sus 34 columnas son NOT NULL,
ninguna tiene DEFAULT. Elijo DELETE CASCADE para los tres dependientes del
técnico y DELETE NO ACTION en las otras seis FK. Todas usan UPDATE CASCADE.
Conservo NOT DEFERRABLE, tipos, nombres, PK y CHECK, incluido TeléfonoTécnivo.
Son decisiones justificadas de diseño, no políticas impuestas por el enunciado.

SET NULL no es compatible con la obligatoriedad actual; en contactos,
certificaciones y el vínculo Mantenimiento-Máquina también rompería la PK.
SET DEFAULT requeriría valores y padres válidos que esta base no define.
NO ACTION permite conservar historial sin eliminarlo como efecto lateral.

## Documentación con COMMENT

comentarios.sql documenta finalidad, significado y obligatoriedad de cada
columna, y las 49 restricciones explícitas. Añade comentarios a las 34
restricciones NOT NULL de PostgreSQL 18 consultando sus nombres reales en el
catálogo. En total se verifican 8 tablas, 34 columnas y 83 constraints.
COMMENT guarda metadatos; un comentario no agrega una regla de integridad.
Se consulta su persistencia con obj_description y col_description.
(PostgreSQL Global Development Group, s. f.-d, s. f.-e).

## Fuentes oficiales

Referencias en formato APA, documentación de PostgreSQL 18. Consulta:
2 de noviembre de 2026. Los ejemplos y las elecciones del módulo son elaboración
para este esquema; las fuentes sustentan la semántica de PostgreSQL.

- PostgreSQL Global Development Group. (s. f.-a). Constraints. PostgreSQL 18 documentation. https://www.postgresql.org/docs/18/ddl-constraints.html
- PostgreSQL Global Development Group. (s. f.-b). CREATE TABLE. PostgreSQL 18 documentation. https://www.postgresql.org/docs/18/sql-createtable.html
- PostgreSQL Global Development Group. (s. f.-c). ALTER TABLE. PostgreSQL 18 documentation. https://www.postgresql.org/docs/18/sql-altertable.html
- PostgreSQL Global Development Group. (s. f.-d). COMMENT. PostgreSQL 18 documentation. https://www.postgresql.org/docs/18/sql-comment.html
- PostgreSQL Global Development Group. (s. f.-e). pg_constraint. PostgreSQL 18 documentation. https://www.postgresql.org/docs/18/catalog-pg-constraint.html
- PostgreSQL Global Development Group. (s. f.-f). Control structures. PostgreSQL 18 documentation. https://www.postgresql.org/docs/18/plpgsql-control-structures.html
