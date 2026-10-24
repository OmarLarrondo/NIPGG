-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Desde esta carpeta: psql -X -v ON_ERROR_STOP=1 -d BASE_DE_PRUEBAS -f pruebas.sql
-- Los comandos \ir son propios de psql, no del editor SQL de DBeaver.
-- Se prueba en un esquema aislado y se revierte todo al terminar.
-- Si el esquema ya existe, se detiene sin borrarlo ni usar sus objetos.
-- Este archivo se ejecuta por separado y no forma parte de DDL.sql.
\set ON_ERROR_STOP on
BEGIN;
CREATE SCHEMA prueba_clientes_01;
SET LOCAL search_path TO prueba_clientes_01, pg_temp;
SET LOCAL TIME ZONE 'UTC';

-- Dependencias mínimas de los módulos 02 y 05, solo para estas pruebas.
-- No sustituyen las implementaciones reales ni prueban la integración global.
CREATE TABLE "Empleado" ("CURP" char(18) PRIMARY KEY);
CREATE TABLE "Cajero" ("CURP" char(18) PRIMARY KEY REFERENCES "Empleado" ("CURP"));
CREATE TABLE "Máquina" ("idMaquina" integer PRIMARY KEY);
\ir tablas.sql
\ir dominios.sql
\ir claves.sql
\ir referencias.sql

-- Datos sintéticos. Solo los dos primeros empleados son cajeros.
INSERT INTO "Empleado" VALUES
    ('AAAA000101HDFBBB01'), ('BBBB000101HDFBBB01'), ('CCCC000101HDFBBB01');
INSERT INTO "Cajero" VALUES ('AAAA000101HDFBBB01'), ('BBBB000101HDFBBB01');
INSERT INTO "Máquina" VALUES (1), (2);
INSERT INTO "Cliente" VALUES
    (1, '2000-01-01', 'Ana', 'Prueba', 'Uno', 'descriptor de prueba'),
    (2, '2000-01-01', 'Beto', 'Prueba', 'Dos', 'sin catálogo cerrado'),
    (3, '2000-01-01', 'Ceci', 'Prueba', 'Tres', 'descriptor de prueba');
INSERT INTO "CorreoCliente" VALUES
    (1, 'uno@example.test'), (1, 'otro@example.test'), (2, 'uno@example.test');
INSERT INTO "TelefonoCliente" VALUES
    (1, '0012345678'), (1, '5512345678'), (2, '0012345678');
INSERT INTO "Tarjeta" VALUES
    (1, 1, 0, '2026-01-01', 0, 'estado de prueba', 0, 'AAAA000101HDFBBB01'),
    (2, 1, 50, '2026-01-01', 100, 'otro estado de prueba', 10, 'BBBB000101HDFBBB01');
-- idPartida = 1 se reutiliza en contextos distintos; las tres PK difieren.
INSERT INTO "Partida" VALUES
    (1, 1, 1, '2026-01-02', '09:00:00-06:00', 0, 0),
    (1, 2, 1, '2026-01-02', '10:00:00-06:00', 10, 100),
    (2, 1, 1, '2026-01-02', '11:00:00-06:00', 20, 200);
INSERT INTO "CorreoEmpleado" VALUES
    ('AAAA000101HDFBBB01', 'uno@example.test'),
    ('AAAA000101HDFBBB01', 'otro@example.test'),
    ('BBBB000101HDFBBB01', 'uno@example.test'),
    ('CCCC000101HDFBBB01', 'solo@example.test');
INSERT INTO "TelefonoEmpleado" VALUES
    ('AAAA000101HDFBBB01', '0012345678'), ('AAAA000101HDFBBB01', '5512345678'),
    ('BBBB000101HDFBBB01', '0012345678'), ('CCCC000101HDFBBB01', '5599999999');

CREATE TEMP TABLE resultados_clientes (caso text, resultado text);
INSERT INTO resultados_clientes VALUES
    ('Inserciones válidas y valores cero', 'aceptadas'),
    ('Varios contactos y contactos compartidos entre propietarios', 'aceptados'),
    ('Discriminantes reutilizados en contextos distintos', 'aceptados');

SAVEPOINT limites_validos;
UPDATE "Cliente" SET "fechaNacimiento" = CURRENT_DATE,
    "nombre" = 'José Ángel', "apellidoMaterno" = 'Muñoz';
UPDATE "Tarjeta" SET "saldo" = 2147483647, "puntosAcumulados" = 2147483647;
INSERT INTO "CorreoCliente" VALUES (1, repeat('a', 95) || '@b.co');
INSERT INTO "CorreoEmpleado" VALUES ('AAAA000101HDFBBB01', repeat('a', 45) || '@b.co');
ROLLBACK TO SAVEPOINT limites_validos;
RELEASE SAVEPOINT limites_validos;
INSERT INTO resultados_clientes VALUES ('Límites válidos de dominio', 'aceptados');

-- Cada fallo esperado se aísla en su propio bloque de excepción.
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
        INSERT INTO resultados_clientes VALUES (caso, 'rechazado: ' || observado);
        RETURN;
    END;
    RAISE EXCEPTION 'FALLO %: se aceptó una operación inválida', caso;
END;
$$;

-- Las 29 columnas del módulo deben rechazar NULL (SQLSTATE 23502).
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT table_name, column_name FROM information_schema.columns
             WHERE table_schema = 'prueba_clientes_01'
               AND table_name IN ('Cliente', 'CorreoCliente', 'TelefonoCliente',
                   'Tarjeta', 'Partida', 'CorreoEmpleado', 'TelefonoEmpleado')
    LOOP
        PERFORM pg_temp.esperar_error('NULL en ' || c.table_name || '.' || c.column_name,
            format('UPDATE %I SET %I = NULL', c.table_name, c.column_name), '23502');
    END LOOP;
END;
$$;

-- Estados esperados: 23514 CHECK; 23505 PK; 23503 FK;
-- 22001 longitud; 22003 rango numérico; 22008 fecha/hora inválida.
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT * FROM (VALUES
        ('Cliente con identificador cero', $q$UPDATE "Cliente" SET "idCliente" = 0$q$, '23514', 'ck_cliente_id'),
        ('Nacimiento futuro', $q$UPDATE "Cliente" SET "fechaNacimiento" = CURRENT_DATE + 1$q$, '23514', 'ck_cliente_nacimiento'),
        ('Nacimiento infinito', $q$UPDATE "Cliente" SET "fechaNacimiento" = '-infinity'$q$, '23514', 'ck_cliente_nacimiento'),
        ('Fecha inexistente', $q$UPDATE "Cliente" SET "fechaNacimiento" = '2000-02-30'$q$, '22008', NULL),
        ('Nombre vacío', $q$UPDATE "Cliente" SET "nombre" = ''$q$, '23514', 'ck_cliente_nombre'),
        ('Nombre demasiado largo', $q$UPDATE "Cliente" SET "nombre" = repeat('A', 51)$q$, '22001', NULL),
        ('Apellido materno en blanco', $q$UPDATE "Cliente" SET "apellidoMaterno" = '   '$q$, '23514', 'ck_cliente_apellido_materno'),
        ('Apellido paterno en blanco', $q$UPDATE "Cliente" SET "apellidoPaterno" = E'\t'$q$, '23514', 'ck_cliente_apellido_paterno'),
        ('Sexo vacío', $q$UPDATE "Cliente" SET "sexo" = ''$q$, '23514', 'ck_cliente_sexo'),
        ('Correo de cliente con propietario cero', $q$UPDATE "CorreoCliente" SET "idCliente" = 0$q$, '23514', 'ck_correo_cliente_id'),
        ('Correo de cliente sin arroba', $q$UPDATE "CorreoCliente" SET "correoElectrónico" = 'sin-arroba'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente sin parte local', $q$UPDATE "CorreoCliente" SET "correoElectrónico" = '@example.test'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente sin dominio', $q$UPDATE "CorreoCliente" SET "correoElectrónico" = 'uno@'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente con espacios', $q$UPDATE "CorreoCliente" SET "correoElectrónico" = 'uno @example.test'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente con dos arrobas', $q$UPDATE "CorreoCliente" SET "correoElectrónico" = 'uno@@example.test'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente demasiado largo', $q$UPDATE "CorreoCliente" SET "correoElectrónico" = repeat('a', 96) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de cliente con propietario cero', $q$UPDATE "TelefonoCliente" SET "idCliente" = 0$q$, '23514', 'ck_telefono_cliente_id'),
        ('Teléfono de cliente corto', $q$UPDATE "TelefonoCliente" SET "teléfono" = '123'$q$, '23514', 'ck_telefono_cliente_numero'),
        ('Teléfono de cliente con letras', $q$UPDATE "TelefonoCliente" SET "teléfono" = '551234567X'$q$, '23514', 'ck_telefono_cliente_numero'),
        ('Teléfono de cliente demasiado largo', $q$UPDATE "TelefonoCliente" SET "teléfono" = '55123456789'$q$, '22001', NULL),
        ('Tarjeta con propietario cero', $q$UPDATE "Tarjeta" SET "idCliente" = 0$q$, '23514', 'ck_tarjeta_cliente'),
        ('Número de tarjeta cero', $q$UPDATE "Tarjeta" SET "numeroTarjeta" = 0$q$, '23514', 'ck_tarjeta_numero'),
        ('Costo negativo', $q$UPDATE "Tarjeta" SET "costoAdquisición" = -1$q$, '23514', 'ck_tarjeta_costo'),
        ('Compra con fecha infinita', $q$UPDATE "Tarjeta" SET "fechaCompra" = 'infinity'$q$, '23514', 'ck_tarjeta_fecha_compra'),
        ('Saldo negativo', $q$UPDATE "Tarjeta" SET "saldo" = -1$q$, '23514', 'ck_tarjeta_saldo'),
        ('Saldo fuera del rango entero', $q$UPDATE "Tarjeta" SET "saldo" = 2147483648$q$, '22003', NULL),
        ('Estado de tarjeta vacío', $q$UPDATE "Tarjeta" SET "estado" = ''$q$, '23514', 'ck_tarjeta_estado'),
        ('Puntos acumulados negativos', $q$UPDATE "Tarjeta" SET "puntosAcumulados" = -1$q$, '23514', 'ck_tarjeta_puntos'),
        ('CURP vendedora demasiado larga', $q$UPDATE "Tarjeta" SET "CURP" = 'AAAA000101HDFBBB012'$q$, '22001', NULL),
        ('Partida con cliente cero', $q$UPDATE "Partida" SET "idCliente" = 0$q$, '23514', 'ck_partida_cliente'),
        ('Partida con máquina cero', $q$UPDATE "Partida" SET "idMaquina" = 0$q$, '23514', 'ck_partida_maquina'),
        ('Identificador de partida cero', $q$UPDATE "Partida" SET "idPartida" = 0$q$, '23514', 'ck_partida_id'),
        ('Partida con fecha infinita', $q$UPDATE "Partida" SET "fecha" = 'infinity'$q$, '23514', 'ck_partida_fecha'),
        ('Hora de partida inválida', $q$UPDATE "Partida" SET "hora" = '25:00:00+00'$q$, '22008', NULL),
        ('Puntos ganados negativos', $q$UPDATE "Partida" SET "puntosGanados" = -1$q$, '23514', 'ck_partida_puntos'),
        ('Puntaje obtenido negativo', $q$UPDATE "Partida" SET "puntajeObtenido" = -1$q$, '23514', 'ck_partida_puntaje'),
        ('Correo de empleado sin arroba', $q$UPDATE "CorreoEmpleado" SET "correoElectrónico" = 'sin-arroba'$q$, '23514', 'ck_correo_empleado_direccion'),
        ('Correo de empleado con espacios', $q$UPDATE "CorreoEmpleado" SET "correoElectrónico" = 'uno@ example.test'$q$, '23514', 'ck_correo_empleado_direccion'),
        ('Correo de empleado demasiado largo', $q$UPDATE "CorreoEmpleado" SET "correoElectrónico" = repeat('a', 46) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de empleado corto', $q$UPDATE "TelefonoEmpleado" SET "teléfono" = '123'$q$, '23514', 'ck_telefono_empleado_numero'),
        ('Teléfono de empleado con letras', $q$UPDATE "TelefonoEmpleado" SET "teléfono" = '551234567X'$q$, '23514', 'ck_telefono_empleado_numero'),
        ('Teléfono de empleado demasiado largo', $q$UPDATE "TelefonoEmpleado" SET "teléfono" = '55123456789'$q$, '22001', NULL),
        ('PK de Cliente repetida', $q$INSERT INTO "Cliente" SELECT * FROM "Cliente" WHERE "idCliente" = 1$q$, '23505', 'pk_cliente'),
        ('PK de CorreoCliente repetida', $q$INSERT INTO "CorreoCliente" VALUES (1, 'uno@example.test')$q$, '23505', 'pk_correo_cliente'),
        ('PK de TelefonoCliente repetida', $q$INSERT INTO "TelefonoCliente" VALUES (1, '0012345678')$q$, '23505', 'pk_telefono_cliente'),
        ('Cliente con dos tarjetas', $q$INSERT INTO "Tarjeta" VALUES (1, 2, 0, '2026-01-01', 0, 'otro estado', 0, 'AAAA000101HDFBBB01')$q$, '23505', 'pk_tarjeta'),
        ('PK de Partida repetida', $q$INSERT INTO "Partida" VALUES (1, 1, 1, '2026-01-03', '15:00:00+00', 30, 300)$q$, '23505', 'pk_partida'),
        ('PK de CorreoEmpleado repetida', $q$INSERT INTO "CorreoEmpleado" VALUES ('AAAA000101HDFBBB01', 'uno@example.test')$q$, '23505', 'pk_correo_empleado'),
        ('PK de TelefonoEmpleado repetida', $q$INSERT INTO "TelefonoEmpleado" VALUES ('AAAA000101HDFBBB01', '0012345678')$q$, '23505', 'pk_telefono_empleado'),
        ('Correo sin cliente existente', $q$INSERT INTO "CorreoCliente" VALUES (999, 'nuevo@example.test')$q$, '23503', 'fk_correo_cliente'),
        ('Teléfono sin cliente existente', $q$INSERT INTO "TelefonoCliente" VALUES (999, '5512345678')$q$, '23503', 'fk_telefono_cliente'),
        ('Tarjeta sin cliente existente', $q$INSERT INTO "Tarjeta" VALUES (999, 2, 0, '2026-01-01', 0, 'prueba', 0, 'AAAA000101HDFBBB01')$q$, '23503', 'fk_tarjeta_cliente'),
        ('Vendedor que solo es empleado', $q$UPDATE "Tarjeta" SET "CURP" = 'CCCC000101HDFBBB01'$q$, '23503', 'fk_tarjeta_cajero'),
        ('Cliente de partida sin tarjeta', $q$INSERT INTO "Partida" VALUES (3, 1, 1, '2026-01-02', '09:00:00+00', 0, 0)$q$, '23503', 'fk_partida_tarjeta'),
        ('Partida sin máquina existente', $q$INSERT INTO "Partida" VALUES (1, 999, 1, '2026-01-02', '09:00:00+00', 0, 0)$q$, '23503', 'fk_partida_maquina'),
        ('Correo sin empleado existente', $q$INSERT INTO "CorreoEmpleado" VALUES ('ZZZZ000101HDFBBB01', 'nuevo@example.test')$q$, '23503', 'fk_correo_empleado'),
        ('Teléfono sin empleado existente', $q$INSERT INTO "TelefonoEmpleado" VALUES ('ZZZZ000101HDFBBB01', '5512345678')$q$, '23503', 'fk_telefono_empleado'),
        ('Borrar cliente referenciado', $q$DELETE FROM "Cliente" WHERE "idCliente" = 1$q$, '23503', NULL),
        ('Borrar tarjeta con partidas', $q$DELETE FROM "Tarjeta" WHERE "idCliente" = 1$q$, '23503', 'fk_partida_tarjeta'),
        ('Borrar cajero vendedor', $q$DELETE FROM "Cajero" WHERE "CURP" = 'AAAA000101HDFBBB01'$q$, '23503', 'fk_tarjeta_cajero'),
        ('Borrar máquina con partidas', $q$DELETE FROM "Máquina" WHERE "idMaquina" = 1$q$, '23503', 'fk_partida_maquina'),
        ('Borrar empleado con contactos', $q$DELETE FROM "Empleado" WHERE "CURP" = 'CCCC000101HDFBBB01'$q$, '23503', NULL),
        ('Cambiar dueño de tarjeta referenciada', $q$UPDATE "Tarjeta" SET "idCliente" = 3 WHERE "idCliente" = 1$q$, '23503', 'fk_partida_tarjeta'),
        ('Cambiar identificador de cliente referenciado', $q$UPDATE "Cliente" SET "idCliente" = 4 WHERE "idCliente" = 1$q$, '23503', NULL)
    ) AS casos(caso, sentencia, estado, restriccion)
    LOOP
        PERFORM pg_temp.esperar_error(c.caso, c.sentencia, c.estado, c.restriccion);
    END LOOP;
END;
$$;

SELECT caso, resultado FROM resultados_clientes ORDER BY caso;
SELECT count(*) FILTER (WHERE resultado LIKE 'aceptad%') AS grupos_validos,
       count(*) FILTER (WHERE resultado LIKE 'rechazado:%') AS rechazos_correctos
FROM resultados_clientes;
ROLLBACK;
