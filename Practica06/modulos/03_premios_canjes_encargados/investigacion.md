# Investigación: SET NULL

**Autor:** Ana Lilia Carballido Camacateco
Fundamentos de Bases de Datos · Práctica 06 · Equipo ÑIPGG
**Fecha de preparación:** 2 de noviembre de 2026.

## 2. ¿Cómo se indica SET NULL en SQL?

`ON DELETE SET NULL` y `ON UPDATE SET NULL` son políticas de restricción que se declaran cuando se define de una llave foránea. Sirven para indicar el comportamiento que PostgreSQL debe seguir cuando se hace la eliminación de una tabla o columa que contiene una llave primaria que es referenciada en otra tabla hija.
Se utiliza cuando las columnas de la llave foránea permiten valores nulos, es decir, cuando la relación es opcional y la fila hija puede conservar sus valores sin su padre necesariamente.

**Sintaxis**

```sql
-- Como restricción de columna
"idPremio" integer REFERENCES "Premio" ("idPremio")
    ON DELETE SET NULL
    ON UPDATE SET NULL

-- Como restricción de tabla
CONSTRAINT fk_canje_premio
    FOREIGN KEY ("idPremio") REFERENCES "Premio" ("idPremio")
    ON DELETE SET NULL
    ON UPDATE SET NULL
```

**Sintaxis sobre una tabla existente:**

```sql
ALTER TABLE "Canje"
    ADD CONSTRAINT fk_canje_premio
    FOREIGN KEY ("idPremio") REFERENCES "Premio" ("idPremio")
    ON DELETE SET NULL
    ON UPDATE SET NULL;
```

Si no se especifica ninguna acción, PostgreSQL aplica `NO ACTION` por defecto.

## 3. Objeto y funcionamiento
SET NULL forma parte de una restricción de llave foránea. Tiene objetivo es mantener la integridad referencial cuando se borra una una fila padre sin que esto afecte a las filas hijas que hacen referencia a él.
Cuando se indica la acción ON DELETE SET NULL, significa que, si se borra una fila del padre, no se eliminan las filas de las tablas hijas ni se bloquea la operación, sino que se pone NULL en la columna de la llave foránea que tenía la fila hija.
Cuando se indica la acción ON UPDATE SET NULL, significa que si cambias el valor de la llave que está siendo referenciada de la tabla padre, las filas de tablas hijas que hacen referencia a él, obtienen un valor NULL. Es decir, que el valor no se propaga.

### Ejemplo reproducible independiemntemente de las reglas de negocio
En el siguiente ejemplo podemos observar el comportamiento de SET NULL en 'Canje' y el contraste con el comportamiento de CASCADE en 'Disponer'. Sus tablas temporales no reemplazan las decisiones conservadoras del esquema real.

```sql
BEGIN;
CREATE TEMP TABLE "Premio_demo" (
    "idPremio" integer PRIMARY KEY,
    "valorAproximado" integer,
    "puntosNecesarios" integer,
    "nombre" varchar(50),
    "categoría" varchar(50),
    "rangoEdad" varchar(50)
);
CREATE TEMP TABLE "Canje_demo" (
    "idCanje" integer PRIMARY KEY,
    "idSucursal" integer,
    "idCliente" integer,
    "idPremio" integer NOT NULL,  -- obligatoria, como en el script de la práctica
    "CURP" char(18),
    "hora" time,
    "puntosUtilizados" integer,
    "cantidadPremios" integer,
    "fecha" date,
    FOREIGN KEY ("idPremio") REFERENCES "Premio_demo"("idPremio")
        ON DELETE SET NULL ON UPDATE SET NULL
);
CREATE TEMP TABLE "Disponer_demo" (
    "idSucursal" integer,
    "idPremio" integer,
    "cantidadDisponible" integer,
    PRIMARY KEY ("idSucursal", "idPremio"),
    FOREIGN KEY ("idPremio") REFERENCES "Premio_demo"("idPremio")
        ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "Premio_demo" VALUES
    (1, 150, 500, 'Bicicleta', 'Juguetes', '6-12'),
    (2,  80, 200, 'Balón',     'Deportes', '8-14');
INSERT INTO "Canje_demo" VALUES
    (1, 1, 10, 1, 'PEGJ900101HDFRRN09', '10:30', 500, 1, '2026-10-15'),
    (2, 1, 11, 1, 'LOMA850505MDFPRN03', '12:15', 500, 1, '2026-10-20'),
    (3, 2, 12, 2, 'GARC000202HJCLLR05', '16:45', 200, 1, '2026-10-22');
INSERT INTO "Disponer_demo" VALUES (1, 1, 10), (1, 2, 5);

-- Con "idPremio" NOT NULL, SET NULL no puede ejecutarse.
DO $$
BEGIN
    DELETE FROM "Premio_demo" WHERE "idPremio" = 1;
EXCEPTION WHEN not_null_violation THEN
    RAISE NOTICE 'Falla: %', SQLERRM;
END $$;
-- NOTICE: Falla: null value in column "idPremio" of relation "Canje_demo"
--         violates not-null constraint
SELECT count(*) FROM "Premio_demo";  -- 2. El DELETE completo se revirtió.

--Si la columna admite NULL, ON DELETE SET NULL anula la referencia.
ALTER TABLE "Canje_demo" ALTER COLUMN "idPremio" DROP NOT NULL;
DELETE FROM "Premio_demo" WHERE "idPremio" = 1;
SELECT "idCanje", "idPremio", "puntosUtilizados" FROM "Canje_demo" ORDER BY 1;
-- 1 | NULL | 500
-- 2 | NULL | 500
-- 3 |    2 | 200
-- Los canjes no se borran; solo pierden el premio.
SELECT * FROM "Disponer_demo" ORDER BY 1, 2;
-- 1 | 2 | 5. La fila (1, 1) se eliminó por CASCADE.

-- ON UPDATE SET NULL no propaga el valor nuevo; CASCADE sí.
UPDATE "Premio_demo" SET "idPremio" = 20 WHERE "idPremio" = 2;
SELECT "idCanje", "idPremio" FROM "Canje_demo" WHERE "idCanje" = 3;
-- NULL. El canje no apunta a 20.
SELECT "idSucursal", "idPremio" FROM "Disponer_demo";
-- Disponer sí recibió el valor nuevo.
ROLLBACK;
```


## Pregunta 4: ventajas y desventajas

**Ventajas**
Al usar SET NULL se evita que se borre información de manera accidental al eliminar filas en cascada. También se mantiene la integridad referencial puesto que no quedan referencias a un padre inexistente ya que los valores de la fila se vuelven nulos.

**Desventajas y riesgos**
Pueden quedar muchos valores NULL que complican consultas posteriores comoo al usar JOIN o =. Además de que puede incrementar el costo de rendimiento porque borrar un padre con muchos hijos genera muchos UPDATE.
También es posible perder información si porque no se puede recuperar un valor una vez quedó en NULL.

**Límites**

- Requiere que las columnas de la FK acepten `NULL`; con `NOT NULL` el borrado del padre falla en tiempo de ejecución (Prueba 1).
- No es posible en columnas de la llave primaria (Prueba 4).
- La lista de columnas solo existe desde PostgreSQL 15 y solo aplica a `ON DELETE`.
- No es una acción diferible: se ejecuta con el comando, aunque la restricción sea `DEFERRABLE`.
- Los `CHECK` no impiden el `NULL` (Prueba 2); solo `NOT NULL` y la llave primaria lo hacen.
- No sustituye las restricciones de negocio: si la hija debe tener siempre un padre, esta política no es la adecuada.

**Alternativas**

| Alternativa | Cuándo conviene | Ejemplo en este módulo |
|---|---|---|
| `ON DELETE CASCADE` | La hija carece de sentido sin el padre | `"Disponer"` sin su premio |
| `ON DELETE RESTRICT` / `NO ACTION` | No se debe poder borrar un padre con hijos; el error es deseable | `"Canje"` es un registro histórico de un premio |
| `ON DELETE SET DEFAULT` | Se quiere reasignar a un padre "por defecto", que debe existir | Un premio "Descontinuado" (la práctica no define valores predeterminados) |
| Borrado lógico (columna `activo` o `eliminado_en`) | Hay que conservar el vínculo histórico | Desactivar un premio en lugar de borrarlo |
| Tabla de auditoría o historial | Se acepta `SET NULL`, pero se necesita rastrear qué padre tenía cada fila | Historial de canjes |

## Compatibilidad con el esquema

En este caso las columnas de cada módulo son NOT NULL por lo que no tendría sentido usar SET NULL según el esquema propuesto.

## Fuentes oficiales
La lista de columnas en `SET NULL` requiere **PostgreSQL 15 o superior**.

| Fuente | Sección consultada | Enlace |
|---|---|---|
| Documentación de PostgreSQL, Data Definition | 5.5 Constraints, Foreign Keys (acciones referenciales, `SET NULL`, `SET DEFAULT`, `MATCH SIMPLE`) | https://www.postgresql.org/docs/current/ddl-constraints.html |
| Documentación de PostgreSQL, SQL Commands | `CREATE TABLE`, cláusula `REFERENCES` (sintaxis, `ON DELETE`/`ON UPDATE`, lista de columnas, `DEFERRABLE`) | https://www.postgresql.org/docs/current/sql-createtable.html |
