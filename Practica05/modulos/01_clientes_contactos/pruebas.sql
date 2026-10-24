-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Desde esta carpeta: psql -X -v ON_ERROR_STOP=1 -d BASE_DE_PRUEBAS -f pruebas.sql
-- Los comandos \ir son propios de psql, no del editor SQL de DBeaver.
-- Se crea un esquema aislado y se revierte todo al terminar.
-- Si ese esquema ya existe, se detiene sin borrarlo ni usar sus objetos.
-- Este archivo no forma parte del DDL.sql de entrega.
\set ON_ERROR_STOP on
BEGIN;
CREATE SCHEMA prueba_clientes_01;
SET LOCAL search_path TO prueba_clientes_01, pg_temp;
SET LOCAL TIME ZONE 'UTC';

-- Dependencias mínimas de los módulos 02 y 05, solo para estas pruebas.
-- Cada puesto tiene su propia tabla; no se crea una tabla general Empleado.
CREATE TABLE "Máquina" ("idMaquina" integer PRIMARY KEY);
CREATE TABLE "Gerente" ("CURP" char(18) PRIMARY KEY);
CREATE TABLE "Cajero" ("CURP" char(18) PRIMARY KEY);
CREATE TABLE "Encargado de premios" ("CURP" char(18) PRIMARY KEY);
CREATE TABLE "Técnico" ("CURP" char(18) PRIMARY KEY);

\ir tablas.sql
\ir dominios.sql
\ir claves.sql
\ir referencias.sql

INSERT INTO "Gerente" VALUES ('GGGG000101HDFBBB01'), ('GGGG000101HDFBBB02');
INSERT INTO "Cajero" VALUES ('AAAA000101HDFBBB01'), ('BBBB000101HDFBBB01');
INSERT INTO "Encargado de premios" VALUES ('EEEE000101HDFBBB01'), ('EEEE000101HDFBBB02');
INSERT INTO "Técnico" VALUES ('TTTT000101HDFBBB01'), ('TTTT000101HDFBBB02');
INSERT INTO "Máquina" VALUES (1), (2);
INSERT INTO "Cliente" VALUES
    (1, '2000-01-01', 'Ana', 'Prueba', 'Uno', 'descriptor de prueba'),
    (2, '2000-01-01', 'Beto', 'Prueba', 'Dos', 'sin catálogo cerrado'),
    (3, '2000-01-01', 'Ceci', 'Prueba', 'Tres', 'descriptor de prueba');
INSERT INTO "correoElectrónico" VALUES
    (1, 'uno@example.test'), (1, 'otro@example.test'), (2, 'uno@example.test');
INSERT INTO "teléfono" VALUES
    (1, '0012345678'), (1, '5512345678'), (2, '0012345678');
INSERT INTO "Tarjeta" ("idCliente", "numeroTarjeta", "costoAdquisición", "fechaCompra", "saldo", "estado", "puntosAcumulados", "CURP") VALUES
    (1, 1, 0, '2026-01-01', 0, 'estado de prueba', 0, 'AAAA000101HDFBBB01'),
    (2, 1, 50, '2026-01-01', 100, 'otro estado de prueba', 10, 'BBBB000101HDFBBB01');
-- idPartida = 1 se reutiliza en contextos distintos; las tres PK difieren.
INSERT INTO "Partida" ("idCliente", "numeroTarjeta", "idMaquina", "idPartida", "fecha", "hora", "puntosGanados", "puntajeObtenido") VALUES
    (1, 1, 1, 1, '2026-01-02', '09:00:00-06:00', 0, 0),
    (1, 1, 2, 1, '2026-01-02', '10:00:00-06:00', 10, 100),
    (2, 1, 1, 1, '2026-01-02', '11:00:00-06:00', 20, 200);
INSERT INTO "CorreoElectrónicoGerente" VALUES
    ('GGGG000101HDFBBB01', 'uno@example.test'), ('GGGG000101HDFBBB01', 'otro@example.test'),
    ('GGGG000101HDFBBB02', 'uno@example.test');
INSERT INTO "TeléfonoGerente" VALUES
    ('GGGG000101HDFBBB01', '0012345678'), ('GGGG000101HDFBBB01', '5512345678'),
    ('GGGG000101HDFBBB02', '0012345678');
INSERT INTO "CorreoElectrónicoCajero" VALUES
    ('AAAA000101HDFBBB01', 'uno@example.test'), ('AAAA000101HDFBBB01', 'otro@example.test'),
    ('BBBB000101HDFBBB01', 'uno@example.test');
INSERT INTO "TeléfonoCajero" VALUES
    ('AAAA000101HDFBBB01', '0012345678'), ('AAAA000101HDFBBB01', '5512345678'),
    ('BBBB000101HDFBBB01', '0012345678');
INSERT INTO "CorreoElectrónicoEncargado" VALUES
    ('EEEE000101HDFBBB01', 'uno@example.test'), ('EEEE000101HDFBBB01', 'otro@example.test'),
    ('EEEE000101HDFBBB02', 'uno@example.test');
INSERT INTO "TeléfonoEncargado" VALUES
    ('EEEE000101HDFBBB01', '0012345678'), ('EEEE000101HDFBBB01', '5512345678'),
    ('EEEE000101HDFBBB02', '0012345678');
INSERT INTO "CorreoElectrónicoTécnico" VALUES
    ('TTTT000101HDFBBB01', 'uno@example.test'), ('TTTT000101HDFBBB01', 'otro@example.test'),
    ('TTTT000101HDFBBB02', 'uno@example.test');
INSERT INTO "TeléfonoTécnivo" VALUES
    ('TTTT000101HDFBBB01', '0012345678'), ('TTTT000101HDFBBB01', '5512345678'),
    ('TTTT000101HDFBBB02', '0012345678');

CREATE TEMP TABLE resultados_clientes (caso text, resultado text);
INSERT INTO resultados_clientes VALUES
    ('Inserciones válidas y valores cero', 'aceptadas'),
    ('Varios contactos y contactos compartidos entre propietarios', 'aceptados'),
    ('Discriminantes reutilizados en contextos distintos', 'aceptados');

SAVEPOINT limites_validos;
UPDATE "Cliente" SET "fechaNacimiento" = CURRENT_DATE,
    "nombre" = 'José Ángel', "apellidoMaterno" = 'Muñoz';
UPDATE "Tarjeta" SET "saldo" = 2147483647, "puntosAcumulados" = 2147483647;
INSERT INTO "correoElectrónico" VALUES (1, repeat('a', 95) || '@b.co');
INSERT INTO "CorreoElectrónicoGerente" VALUES ('GGGG000101HDFBBB01', repeat('a', 45) || '@b.co');
INSERT INTO "CorreoElectrónicoCajero" VALUES ('AAAA000101HDFBBB01', repeat('a', 45) || '@b.co');
INSERT INTO "CorreoElectrónicoEncargado" VALUES ('EEEE000101HDFBBB01', repeat('a', 45) || '@b.co');
INSERT INTO "CorreoElectrónicoTécnico" VALUES ('TTTT000101HDFBBB01', repeat('a', 45) || '@b.co');
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

-- Las 42 columnas del módulo deben rechazar NULL (SQLSTATE 23502).
DO $$
DECLARE c record;
BEGIN
    FOR c IN SELECT table_name, column_name FROM information_schema.columns
             WHERE table_schema = 'prueba_clientes_01'
               AND table_name IN ('Cliente', 'correoElectrónico', 'teléfono', 'Tarjeta', 'Partida', 'CorreoElectrónicoGerente', 'TeléfonoGerente', 'CorreoElectrónicoCajero', 'TeléfonoCajero', 'CorreoElectrónicoEncargado', 'TeléfonoEncargado', 'CorreoElectrónicoTécnico', 'TeléfonoTécnivo')
    LOOP
        PERFORM pg_temp.esperar_error('NULL en ' || c.table_name || '.' || c.column_name,
            format('UPDATE %I SET %I = NULL', c.table_name, c.column_name), '23502');
    END LOOP;
END;
$$;

-- Estados: 23514 CHECK; 23505 PK; 23503 FK; 22001 longitud;
-- 22003 rango numérico; 22008 fecha/hora inválida.
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
        ('Correo de cliente con propietario cero', $q$UPDATE "correoElectrónico" SET "idCliente" = 0$q$, '23514', 'ck_correo_cliente_id'),
        ('Correo de cliente sin arroba', $q$UPDATE "correoElectrónico" SET "correoElectrónico" = 'sin-arroba'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente sin parte local', $q$UPDATE "correoElectrónico" SET "correoElectrónico" = '@example.test'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente sin dominio', $q$UPDATE "correoElectrónico" SET "correoElectrónico" = 'uno@'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente con espacios', $q$UPDATE "correoElectrónico" SET "correoElectrónico" = 'uno @example.test'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente con dos arrobas', $q$UPDATE "correoElectrónico" SET "correoElectrónico" = 'uno@@example.test'$q$, '23514', 'ck_correo_cliente_direccion'),
        ('Correo de cliente demasiado largo', $q$UPDATE "correoElectrónico" SET "correoElectrónico" = repeat('a', 96) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de cliente con propietario cero', $q$UPDATE "teléfono" SET "idCliente" = 0$q$, '23514', 'ck_telefono_cliente_id'),
        ('Teléfono de cliente corto', $q$UPDATE "teléfono" SET "teléfono" = '123'$q$, '23514', 'ck_telefono_cliente_numero'),
        ('Teléfono de cliente con letras', $q$UPDATE "teléfono" SET "teléfono" = '551234567X'$q$, '23514', 'ck_telefono_cliente_numero'),
        ('Teléfono de cliente demasiado largo', $q$UPDATE "teléfono" SET "teléfono" = '55123456789'$q$, '22001', NULL),
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
        ('PK de Cliente repetida', $q$INSERT INTO "Cliente" SELECT * FROM "Cliente" WHERE "idCliente" = 1$q$, '23505', 'pk_cliente'),
        ('PK de correoElectrónico repetida', $q$INSERT INTO "correoElectrónico" VALUES (1, 'uno@example.test')$q$, '23505', 'pk_correo_cliente'),
        ('PK de teléfono repetida', $q$INSERT INTO "teléfono" VALUES (1, '0012345678')$q$, '23505', 'pk_telefono_cliente'),
        ('Cliente con dos tarjetas', $q$INSERT INTO "Tarjeta" ("idCliente", "numeroTarjeta", "costoAdquisición", "fechaCompra", "saldo", "estado", "puntosAcumulados", "CURP") VALUES (1, 2, 0, '2026-01-01', 0, 'otro estado', 0, 'AAAA000101HDFBBB01')$q$, '23505', 'uq_tarjeta_cliente'),
        ('PK de Partida repetida', $q$INSERT INTO "Partida" ("idCliente", "numeroTarjeta", "idMaquina", "idPartida", "fecha", "hora", "puntosGanados", "puntajeObtenido") VALUES (1, 1, 1, 1, '2026-01-03', '15:00:00+00', 30, 300)$q$, '23505', 'pk_partida'),
        ('Correo sin cliente existente', $q$INSERT INTO "correoElectrónico" VALUES (999, 'nuevo@example.test')$q$, '23503', 'fk_correo_cliente'),
        ('Teléfono sin cliente existente', $q$INSERT INTO "teléfono" VALUES (999, '5512345678')$q$, '23503', 'fk_telefono_cliente'),
        ('Tarjeta sin cliente existente', $q$INSERT INTO "Tarjeta" ("idCliente", "numeroTarjeta", "costoAdquisición", "fechaCompra", "saldo", "estado", "puntosAcumulados", "CURP") VALUES (999, 2, 0, '2026-01-01', 0, 'prueba', 0, 'AAAA000101HDFBBB01')$q$, '23503', 'fk_tarjeta_cliente'),
        ('Vendedor de otro puesto', $q$UPDATE "Tarjeta" SET "CURP" = 'GGGG000101HDFBBB01'$q$, '23503', 'fk_tarjeta_cajero'),
        ('Cliente de partida sin tarjeta', $q$INSERT INTO "Partida" ("idCliente", "numeroTarjeta", "idMaquina", "idPartida", "fecha", "hora", "puntosGanados", "puntajeObtenido") VALUES (3, 1, 1, 1, '2026-01-02', '09:00:00+00', 0, 0)$q$, '23503', 'fk_partida_tarjeta'),
        ('Partida sin máquina existente', $q$INSERT INTO "Partida" ("idCliente", "numeroTarjeta", "idMaquina", "idPartida", "fecha", "hora", "puntosGanados", "puntajeObtenido") VALUES (1, 1, 999, 1, '2026-01-02', '09:00:00+00', 0, 0)$q$, '23503', 'fk_partida_maquina'),
        ('Borrar cliente referenciado', $q$DELETE FROM "Cliente" WHERE "idCliente" = 1$q$, '23503', NULL),
        ('Borrar tarjeta con partidas', $q$DELETE FROM "Tarjeta" WHERE "idCliente" = 1$q$, '23503', 'fk_partida_tarjeta'),
        ('Borrar cajero vendedor', $q$DELETE FROM "Cajero" WHERE "CURP" = 'AAAA000101HDFBBB01'$q$, '23503', 'fk_tarjeta_cajero'),
        ('Borrar máquina con partidas', $q$DELETE FROM "Máquina" WHERE "idMaquina" = 1$q$, '23503', 'fk_partida_maquina'),
        ('Cambiar dueño de tarjeta referenciada', $q$UPDATE "Tarjeta" SET "idCliente" = 3 WHERE "idCliente" = 1$q$, '23503', 'fk_partida_tarjeta'),
        ('Cambiar identificador de cliente referenciado', $q$UPDATE "Cliente" SET "idCliente" = 4 WHERE "idCliente" = 1$q$, '23503', NULL),
        ('Correo de gerente sin arroba', $q$UPDATE "CorreoElectrónicoGerente" SET "correoGerente" = 'sin-arroba'$q$, '23514', 'ck_correo_gerente_formato'),
        ('Correo de gerente sin parte local', $q$UPDATE "CorreoElectrónicoGerente" SET "correoGerente" = '@example.test'$q$, '23514', 'ck_correo_gerente_formato'),
        ('Correo de gerente sin dominio', $q$UPDATE "CorreoElectrónicoGerente" SET "correoGerente" = 'uno@'$q$, '23514', 'ck_correo_gerente_formato'),
        ('Correo de gerente con espacios', $q$UPDATE "CorreoElectrónicoGerente" SET "correoGerente" = 'uno @example.test'$q$, '23514', 'ck_correo_gerente_formato'),
        ('Correo de gerente con dos arrobas', $q$UPDATE "CorreoElectrónicoGerente" SET "correoGerente" = 'uno@@example.test'$q$, '23514', 'ck_correo_gerente_formato'),
        ('Correo de gerente demasiado largo', $q$UPDATE "CorreoElectrónicoGerente" SET "correoGerente" = repeat('a', 46) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de gerente corto', $q$UPDATE "TeléfonoGerente" SET "telefonoGerente" = '123'$q$, '23514', 'ck_telefono_gerente_formato'),
        ('Teléfono de gerente con letras', $q$UPDATE "TeléfonoGerente" SET "telefonoGerente" = '551234567X'$q$, '23514', 'ck_telefono_gerente_formato'),
        ('Teléfono de gerente demasiado largo', $q$UPDATE "TeléfonoGerente" SET "telefonoGerente" = '55123456789'$q$, '22001', NULL),
        ('PK de CorreoElectrónicoGerente repetida', $q$INSERT INTO "CorreoElectrónicoGerente" VALUES ('GGGG000101HDFBBB01', 'uno@example.test')$q$, '23505', 'pk_correo_gerente'),
        ('CorreoElectrónicoGerente sin propietario existente', $q$INSERT INTO "CorreoElectrónicoGerente" VALUES ('ZZZZ000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_gerente'),
        ('CorreoElectrónicoGerente con propietario de otro puesto', $q$INSERT INTO "CorreoElectrónicoGerente" VALUES ('AAAA000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_gerente'),
        ('PK de TeléfonoGerente repetida', $q$INSERT INTO "TeléfonoGerente" VALUES ('GGGG000101HDFBBB01', '0012345678')$q$, '23505', 'pk_telefono_gerente'),
        ('TeléfonoGerente sin propietario existente', $q$INSERT INTO "TeléfonoGerente" VALUES ('ZZZZ000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_gerente'),
        ('TeléfonoGerente con propietario de otro puesto', $q$INSERT INTO "TeléfonoGerente" VALUES ('AAAA000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_gerente'),
        ('Borrar gerente con contactos', $q$DELETE FROM "Gerente" WHERE "CURP" = 'GGGG000101HDFBBB02'$q$, '23503', NULL),
        ('Cambiar CURP de gerente referenciada', $q$UPDATE "Gerente" SET "CURP" = 'ZZZZ000101HDFBBB01' WHERE "CURP" = 'GGGG000101HDFBBB02'$q$, '23503', NULL),
        ('Correo de cajero sin arroba', $q$UPDATE "CorreoElectrónicoCajero" SET "correoCajero" = 'sin-arroba'$q$, '23514', 'ck_correo_cajero_formato'),
        ('Correo de cajero sin parte local', $q$UPDATE "CorreoElectrónicoCajero" SET "correoCajero" = '@example.test'$q$, '23514', 'ck_correo_cajero_formato'),
        ('Correo de cajero sin dominio', $q$UPDATE "CorreoElectrónicoCajero" SET "correoCajero" = 'uno@'$q$, '23514', 'ck_correo_cajero_formato'),
        ('Correo de cajero con espacios', $q$UPDATE "CorreoElectrónicoCajero" SET "correoCajero" = 'uno @example.test'$q$, '23514', 'ck_correo_cajero_formato'),
        ('Correo de cajero con dos arrobas', $q$UPDATE "CorreoElectrónicoCajero" SET "correoCajero" = 'uno@@example.test'$q$, '23514', 'ck_correo_cajero_formato'),
        ('Correo de cajero demasiado largo', $q$UPDATE "CorreoElectrónicoCajero" SET "correoCajero" = repeat('a', 46) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de cajero corto', $q$UPDATE "TeléfonoCajero" SET "telefonoCajero" = '123'$q$, '23514', 'ck_telefono_cajero_formato'),
        ('Teléfono de cajero con letras', $q$UPDATE "TeléfonoCajero" SET "telefonoCajero" = '551234567X'$q$, '23514', 'ck_telefono_cajero_formato'),
        ('Teléfono de cajero demasiado largo', $q$UPDATE "TeléfonoCajero" SET "telefonoCajero" = '55123456789'$q$, '22001', NULL),
        ('PK de CorreoElectrónicoCajero repetida', $q$INSERT INTO "CorreoElectrónicoCajero" VALUES ('AAAA000101HDFBBB01', 'uno@example.test')$q$, '23505', 'pk_correo_cajero'),
        ('CorreoElectrónicoCajero sin propietario existente', $q$INSERT INTO "CorreoElectrónicoCajero" VALUES ('ZZZZ000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_cajero'),
        ('CorreoElectrónicoCajero con propietario de otro puesto', $q$INSERT INTO "CorreoElectrónicoCajero" VALUES ('GGGG000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_cajero'),
        ('PK de TeléfonoCajero repetida', $q$INSERT INTO "TeléfonoCajero" VALUES ('AAAA000101HDFBBB01', '0012345678')$q$, '23505', 'pk_telefono_cajero'),
        ('TeléfonoCajero sin propietario existente', $q$INSERT INTO "TeléfonoCajero" VALUES ('ZZZZ000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_cajero'),
        ('TeléfonoCajero con propietario de otro puesto', $q$INSERT INTO "TeléfonoCajero" VALUES ('GGGG000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_cajero'),
        ('Borrar cajero con contactos', $q$DELETE FROM "Cajero" WHERE "CURP" = 'BBBB000101HDFBBB01'$q$, '23503', NULL),
        ('Cambiar CURP de cajero referenciada', $q$UPDATE "Cajero" SET "CURP" = 'ZZZZ000101HDFBBB01' WHERE "CURP" = 'BBBB000101HDFBBB01'$q$, '23503', NULL),
        ('Correo de encargado sin arroba', $q$UPDATE "CorreoElectrónicoEncargado" SET "correoEncargado" = 'sin-arroba'$q$, '23514', 'ck_correo_encargado_formato'),
        ('Correo de encargado sin parte local', $q$UPDATE "CorreoElectrónicoEncargado" SET "correoEncargado" = '@example.test'$q$, '23514', 'ck_correo_encargado_formato'),
        ('Correo de encargado sin dominio', $q$UPDATE "CorreoElectrónicoEncargado" SET "correoEncargado" = 'uno@'$q$, '23514', 'ck_correo_encargado_formato'),
        ('Correo de encargado con espacios', $q$UPDATE "CorreoElectrónicoEncargado" SET "correoEncargado" = 'uno @example.test'$q$, '23514', 'ck_correo_encargado_formato'),
        ('Correo de encargado con dos arrobas', $q$UPDATE "CorreoElectrónicoEncargado" SET "correoEncargado" = 'uno@@example.test'$q$, '23514', 'ck_correo_encargado_formato'),
        ('Correo de encargado demasiado largo', $q$UPDATE "CorreoElectrónicoEncargado" SET "correoEncargado" = repeat('a', 46) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de encargado corto', $q$UPDATE "TeléfonoEncargado" SET "telefonoEncargado" = '123'$q$, '23514', 'ck_telefono_encargado_formato'),
        ('Teléfono de encargado con letras', $q$UPDATE "TeléfonoEncargado" SET "telefonoEncargado" = '551234567X'$q$, '23514', 'ck_telefono_encargado_formato'),
        ('Teléfono de encargado demasiado largo', $q$UPDATE "TeléfonoEncargado" SET "telefonoEncargado" = '55123456789'$q$, '22001', NULL),
        ('PK de CorreoElectrónicoEncargado repetida', $q$INSERT INTO "CorreoElectrónicoEncargado" VALUES ('EEEE000101HDFBBB01', 'uno@example.test')$q$, '23505', 'pk_correo_encargado'),
        ('CorreoElectrónicoEncargado sin propietario existente', $q$INSERT INTO "CorreoElectrónicoEncargado" VALUES ('ZZZZ000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_encargado'),
        ('CorreoElectrónicoEncargado con propietario de otro puesto', $q$INSERT INTO "CorreoElectrónicoEncargado" VALUES ('AAAA000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_encargado'),
        ('PK de TeléfonoEncargado repetida', $q$INSERT INTO "TeléfonoEncargado" VALUES ('EEEE000101HDFBBB01', '0012345678')$q$, '23505', 'pk_telefono_encargado'),
        ('TeléfonoEncargado sin propietario existente', $q$INSERT INTO "TeléfonoEncargado" VALUES ('ZZZZ000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_encargado'),
        ('TeléfonoEncargado con propietario de otro puesto', $q$INSERT INTO "TeléfonoEncargado" VALUES ('AAAA000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_encargado'),
        ('Borrar encargado con contactos', $q$DELETE FROM "Encargado de premios" WHERE "CURP" = 'EEEE000101HDFBBB02'$q$, '23503', NULL),
        ('Cambiar CURP de encargado referenciada', $q$UPDATE "Encargado de premios" SET "CURP" = 'ZZZZ000101HDFBBB01' WHERE "CURP" = 'EEEE000101HDFBBB02'$q$, '23503', NULL),
        ('Correo de tecnico sin arroba', $q$UPDATE "CorreoElectrónicoTécnico" SET "correoTécnico" = 'sin-arroba'$q$, '23514', 'ck_correo_tecnico_formato'),
        ('Correo de tecnico sin parte local', $q$UPDATE "CorreoElectrónicoTécnico" SET "correoTécnico" = '@example.test'$q$, '23514', 'ck_correo_tecnico_formato'),
        ('Correo de tecnico sin dominio', $q$UPDATE "CorreoElectrónicoTécnico" SET "correoTécnico" = 'uno@'$q$, '23514', 'ck_correo_tecnico_formato'),
        ('Correo de tecnico con espacios', $q$UPDATE "CorreoElectrónicoTécnico" SET "correoTécnico" = 'uno @example.test'$q$, '23514', 'ck_correo_tecnico_formato'),
        ('Correo de tecnico con dos arrobas', $q$UPDATE "CorreoElectrónicoTécnico" SET "correoTécnico" = 'uno@@example.test'$q$, '23514', 'ck_correo_tecnico_formato'),
        ('Correo de tecnico demasiado largo', $q$UPDATE "CorreoElectrónicoTécnico" SET "correoTécnico" = repeat('a', 46) || '@b.co'$q$, '22001', NULL),
        ('Teléfono de tecnico corto', $q$UPDATE "TeléfonoTécnivo" SET "telefonoTécnico" = '123'$q$, '23514', 'ck_telefono_tecnico_formato'),
        ('Teléfono de tecnico con letras', $q$UPDATE "TeléfonoTécnivo" SET "telefonoTécnico" = '551234567X'$q$, '23514', 'ck_telefono_tecnico_formato'),
        ('Teléfono de tecnico demasiado largo', $q$UPDATE "TeléfonoTécnivo" SET "telefonoTécnico" = '55123456789'$q$, '22001', NULL),
        ('PK de CorreoElectrónicoTécnico repetida', $q$INSERT INTO "CorreoElectrónicoTécnico" VALUES ('TTTT000101HDFBBB01', 'uno@example.test')$q$, '23505', 'pk_correo_tecnico'),
        ('CorreoElectrónicoTécnico sin propietario existente', $q$INSERT INTO "CorreoElectrónicoTécnico" VALUES ('ZZZZ000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_tecnico'),
        ('CorreoElectrónicoTécnico con propietario de otro puesto', $q$INSERT INTO "CorreoElectrónicoTécnico" VALUES ('AAAA000101HDFBBB01', 'uno@example.test')$q$, '23503', 'fk_correo_tecnico'),
        ('PK de TeléfonoTécnivo repetida', $q$INSERT INTO "TeléfonoTécnivo" VALUES ('TTTT000101HDFBBB01', '0012345678')$q$, '23505', 'pk_telefono_tecnico'),
        ('TeléfonoTécnivo sin propietario existente', $q$INSERT INTO "TeléfonoTécnivo" VALUES ('ZZZZ000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_tecnico'),
        ('TeléfonoTécnivo con propietario de otro puesto', $q$INSERT INTO "TeléfonoTécnivo" VALUES ('AAAA000101HDFBBB01', '0012345678')$q$, '23503', 'fk_telefono_tecnico'),
        ('Borrar tecnico con contactos', $q$DELETE FROM "Técnico" WHERE "CURP" = 'TTTT000101HDFBBB02'$q$, '23503', NULL),
        ('Cambiar CURP de tecnico referenciada', $q$UPDATE "Técnico" SET "CURP" = 'ZZZZ000101HDFBBB01' WHERE "CURP" = 'TTTT000101HDFBBB02'$q$, '23503', NULL),
        ('PK completa de Tarjeta repetida', $q$INSERT INTO "Tarjeta" ("idCliente", "numeroTarjeta", "CURP", "costoAdquisición", "fechaCompra", "saldo", "estado", "puntosAcumulados") VALUES (1, 1, 'AAAA000101HDFBBB01', 0, '2026-01-01', 0, 'prueba', 0)$q$, '23505', NULL),
        ('Número de tarjeta de partida cero', $q$UPDATE "Partida" SET "numeroTarjeta" = 0$q$, '23514', 'ck_partida_numero_tarjeta'),
        ('Pareja de tarjeta inexistente en Partida', $q$INSERT INTO "Partida" ("idCliente", "numeroTarjeta", "idMaquina", "idPartida", "fecha", "hora", "puntosGanados", "puntajeObtenido") VALUES (1, 2, 1, 99, '2026-01-02', '09:00:00+00', 0, 0)$q$, '23503', 'fk_partida_tarjeta'),
        ('Cambiar número de tarjeta referenciada', $q$UPDATE "Tarjeta" SET "numeroTarjeta" = 2 WHERE "idCliente" = 1$q$, '23503', 'fk_partida_tarjeta')
    ) AS casos(caso, sentencia, estado, restriccion)
    LOOP
        PERFORM pg_temp.esperar_error(c.caso, c.sentencia, c.estado, c.restriccion);
    END LOOP;
END;
$$;

SELECT caso, resultado FROM resultados_clientes ORDER BY caso;
-- Resultado esperado: 4 grupos válidos y 167 operaciones rechazadas.
SELECT count(*) FILTER (WHERE resultado LIKE 'aceptad%') AS grupos_validos,
       count(*) FILTER (WHERE resultado LIKE 'rechazado:%') AS rechazos_correctos
FROM resultados_clientes;
ROLLBACK;
