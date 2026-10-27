-- Práctica 05 | Sucursales y operaciones
-- Responsable: Yahir
-- Tablas asignadas: Sucursal, HorarioSucursal, Visita, Recarga
-- Preparar casos válidos y casos que deban rechazarse. Documentar resultado esperado y aislar cada fallo esperado para que no oculte otras pruebas. Este archivo no forma parte de DDL.sql.
-- Desde esta carpeta: psql -X -v ON_ERROR_STOP=1 -d BASE_DE_PRUEBAS -f pruebas.sql
-- Los comandos \ir son propios de psql, no del editor SQL de DBeaver.
-- Se crea un esquema aislado y se revierte todo al terminar.

\set ON_ERROR_STOP on
BEGIN;
CREATE SCHEMA prueba_sucursales_01;
SET LOCAL search_path TO prueba_sucursales_01, pg_temp;
SET LOCAL TIME ZONE 'UTC';

-- Dependencias mínimas de otros módulos, solo para estas pruebas.
CREATE TABLE "Cliente" ("idCliente" integer PRIMARY KEY);
CREATE TABLE "Tarjeta" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    PRIMARY KEY ("idCliente", "numeroTarjeta")
);
CREATE TABLE "Cajero" ("CURP" char(18) PRIMARY KEY);

-- Inclusión de tus archivos DDL y restricciones
\ir tablas.sql
\ir dominios.sql
\ir claves.sql
\ir referencias.sql

-- Inserciones de datos válidos para pruebas iniciales
INSERT INTO "Cliente" VALUES (1), (2);
INSERT INTO "Tarjeta" VALUES (1, 1), (2, 1);
INSERT INTO "Cajero" VALUES ('AAAA000101HDFBBB01');

-- Cambié '06000' por 'CDMX' en el estado
INSERT INTO "SUCURSAL" VALUES 
    (1, 'Sucursal Centro', '5512345678', 'Av. Juárez', 10, 2, 'Centro', 'CDMX'),
    (2, 'Sucursal Norte', '5587654321', 'Paseo de la Reforma', 100, 0, 'Cuauhtémoc', 'CDMX');

INSERT INTO "HORARIO_SUCURSAL" VALUES 
    (1, 'Lunes a Viernes 09:00 - 20:00'),
    (2, 'Lunes a Domingo 10:00 - 22:00');

INSERT INTO "VISITA" VALUES 
    (1, 1, 1, 1, '2026-01-02'),
    (2, 1, 1, 2, '2026-01-02'); -- Corregí el idVisita duplicado de la prueba original

INSERT INTO "RECARGA" VALUES 
    (1, 1, 1, 1, 'AAAA000101HDFBBB01', 100, '2026-01-02', '12:00:00-06:00', 'Efectivo');

CREATE TEMP TABLE resultados_sucursales (caso text, resultado text);
INSERT INTO resultados_sucursales VALUES 
    ('Inserciones válidas en sucursales y operaciones', 'aceptadas');

SAVEPOINT limites_validos;
UPDATE "SUCURSAL" SET "nombre" = 'Sucursal Actualizada', "númeroInterior" = 5;
UPDATE "RECARGA" SET "monto" = 500;
ROLLBACK TO SAVEPOINT limites_validos;
RELEASE SAVEPOINT limites_validos;
INSERT INTO resultados_sucursales VALUES ('Límites válidos de dominio', 'aceptados');

-- Función auxiliar para capturar y validar errores esperados
CREATE FUNCTION pg_temp.esperar_error(caso text, sentencia text, estado text,
        restriccion text DEFAULT NULL)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE observado text; nombre_restriccion text;
BEGIN
    BEGIN
        EXECUTE sentencia;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS observado = RETURNED_SQLSTATE,
            nombre_restriccion = CONSTRAINT_NAME;
        IF observado <> estado OR
           (restriccion IS NOT NULL AND nombre_restriccion <> restriccion) THEN
            RAISE EXCEPTION 'FALLO %: esperado % / %, obtenido % / %',
                caso, estado, restriccion, observado, nombre_restriccion;
        END IF;
        INSERT INTO resultados_sucursales VALUES (caso, 'rechazado: ' || observado);
        RETURN;
    END;
    RAISE EXCEPTION 'FALLO %: se aceptó una operación inválida', caso;
END;
$$;

-- Comprobación de columnas obligatorias (NOT NULL -> SQLSTATE 23502)
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT table_name, column_name FROM information_schema.columns
             WHERE table_schema = 'prueba_sucursales_01'
               AND table_name IN ('SUCURSAL', 'HORARIO_SUCURSAL', 'VISITA', 'RECARGA')
    LOOP
        PERFORM pg_temp.esperar_error('NULL en ' || c.table_name || '.' || c.column_name,
            format('UPDATE %I SET %I = NULL', c.table_name, c.column_name), '23502');
    END LOOP;
END;
$$;

-- Comprobación de restricciones específicas (CHECK, PK, FK, etc.)
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT * FROM (VALUES
        ('Sucursal con identificador cero', $q$UPDATE "SUCURSAL" SET "idSucursal" = 0$q$, '23514', 'ck_sucursal_id'),
        ('Teléfono de sucursal corto', $q$UPDATE "SUCURSAL" SET "teléfono" = '123'$q$, '23514', 'ck_sucursal_telefono'),
        ('Teléfono de sucursal con letras', $q$UPDATE "SUCURSAL" SET "teléfono" = '551234567X'$q$, '23514', 'ck_sucursal_telefono'),
        ('Número exterior negativo', $q$UPDATE "SUCURSAL" SET "númeroExterior" = -1$q$, '23514', 'ck_sucursal_num_ext'),
        ('Visita con fecha infinita', $q$UPDATE "VISITA" SET "fecha" = 'infinity'$q$, '23514', 'ck_visita_fecha'),
        ('Recarga con monto negativo', $q$UPDATE "RECARGA" SET "monto" = -50$q$, '23514', 'ck_recarga_monto'),
        ('PK de Sucursal repetida', $q$INSERT INTO "SUCURSAL" VALUES (1, 'Duplicada', '5512345678', 'Calle', 1, 1, 'Col', 'CDMX')$q$, '23505', 'pk_sucursal'),
        ('Visita con sucursal inexistente', $q$INSERT INTO "VISITA" VALUES (1, 1, 99, 3, '2026-01-02')$q$, '23503', 'fk_visita_sucursal'),
        ('Recarga con cajero inexistente', $q$UPDATE "RECARGA" SET "CURP" = 'ZZZZ000101HDFBBB01'$q$, '23503', 'fk_recarga_cajero'),
        -- Aquí dejé el nombre de la restricción en NULL porque puede saltar primero la de horario_sucursal o visita_sucursal
        ('Borrar sucursal con dependencias activas', $q$DELETE FROM "SUCURSAL" WHERE "idSucursal" = 1$q$, '23503', NULL)
    ) AS casos(caso, sentencia, estado, restriccion)
    LOOP
        PERFORM pg_temp.esperar_error(c.caso, c.sentencia, c.estado, c.restriccion);
    END LOOP;
END;
$$;

SELECT caso, resultado FROM resultados_sucursales ORDER BY caso;
ROLLBACK;
