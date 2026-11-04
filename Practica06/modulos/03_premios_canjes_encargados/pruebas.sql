-- Práctica 06 | Módulo 03 | Responsable: Ana Lilia Carballido Camacateco
-- psql -X -v ON_ERROR_STOP=1 -f pruebas.sql
-- Base AISLADA con DDL completo, politicas.sql y comentarios.sql aplicados.
-- Los identificadores 6101..6199 y las CURP/RFC sintéticos deben estar libres.
-- Cualquier fallo inesperado aborta. ROLLBACK elimina datos y funciones de prueba.
\set ON_ERROR_STOP on
BEGIN;
SELECT version();
CREATE TEMP TABLE resultados (caso text, resultado text);
CREATE FUNCTION pg_temp.probar(caso text, operacion text, verificacion text,
                              error_constraint text DEFAULT NULL)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE correcto boolean; restriccion text; estado text;
BEGIN
  BEGIN
    EXECUTE operacion;
    IF error_constraint IS NOT NULL THEN
      RAISE EXCEPTION 'Se esperaba foreign_key_violation de %', error_constraint;
    END IF;
    EXECUTE verificacion INTO correcto;
    IF correcto IS DISTINCT FROM TRUE THEN
      RAISE EXCEPTION 'Estado final incorrecto: %', caso;
    END IF;
    -- Revertir cada caso exitoso sin perder la fixture común.
    RAISE SQLSTATE 'Z0001';
  EXCEPTION
    WHEN SQLSTATE 'Z0001' THEN NULL;
    WHEN foreign_key_violation OR restrict_violation THEN
      GET STACKED DIAGNOSTICS restriccion = CONSTRAINT_NAME, estado = RETURNED_SQLSTATE;
      IF error_constraint IS NULL OR restriccion <> error_constraint THEN RAISE; END IF;
      EXECUTE verificacion INTO correcto;
      IF correcto IS DISTINCT FROM TRUE THEN RAISE EXCEPTION 'Estado alterado tras rechazo: %', caso; END IF;
  END;
  INSERT INTO resultados VALUES (caso,'OK');
END $$;

-- Fixture común.
-- Sucursal 6101: referenciada por Canje y Disponer. Sucursal 6102: solo Disponer.
-- Sucursal 6103: sede de los encargados. Premio 6101: con canje y existencias.
-- Premio 6102: solo existencias. Encargado ...01: con canje y contactos.
-- Encargado ...02: sin canjes, con contactos.
INSERT INTO "SUCURSAL" VALUES
 (6101,'Sucursal prueba A','5512345678','Calle prueba A',1,0,'Centro','CDMX'),
 (6102,'Sucursal prueba B','5512345679','Calle prueba B',1,0,'Centro','CDMX'),
 (6103,'Sucursal prueba C','5512345670','Calle prueba C',1,0,'Centro','CDMX');
INSERT INTO "Cliente" VALUES (6101,'2000-01-01','Cliente','Materno','Paterno','H');
INSERT INTO "Premio" VALUES
 (6101,100,50,'Premio con canje','Juguetes','6 a 12'),
 (6102,80,40,'Premio sin canje','Peluches','6 a 12');
INSERT INTO "Encargado de premios" VALUES
 ('EEEE000101HDFCCC01',6103,'Encargado','Materno','Paterno','EEEE000101AB1','2020-01-01',1000,'2000-01-01','07:00'),
 ('EEEE000102HDFCCC02',6103,'Encargado dos','Materno','Paterno','EEEE000102AB1','2020-01-01',1000,'2000-01-01','15:00');
INSERT INTO "CorreoElectrónicoEncargado" VALUES
 ('EEEE000101HDFCCC01','uno@example.test'),
 ('EEEE000102HDFCCC02','dos@example.test');
INSERT INTO "TeléfonoEncargado" VALUES
 ('EEEE000101HDFCCC01','5512340001'),
 ('EEEE000102HDFCCC02','5512340002');
INSERT INTO "Disponer" VALUES (6101,6101,10),(6102,6101,5),(6101,6102,7);
INSERT INTO "Canje" VALUES (6101,6101,6101,6101,'EEEE000101HDFCCC01','12:00:00',50,1,'2026-01-01');

-- fk_correo_encargado: CASCADE / CASCADE.
SELECT pg_temp.probar('fk_correo_encargado: DELETE CASCADE', $q$DELETE FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT NOT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000102HDFCCC02') AND NOT EXISTS(SELECT FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02')$q$);

SELECT pg_temp.probar('fk_correo_encargado: UPDATE CASCADE', $q$UPDATE "Encargado de premios" SET "CURP"='EEEE000102HDFCCC12' WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000102HDFCCC12') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000102HDFCCC02')$q$);

SELECT pg_temp.probar('fk_correo_encargado: INSERT huérfano', $q$INSERT INTO "CorreoElectrónicoEncargado" VALUES ('EEEE000199HDFCCC99','nuevo@example.test')$q$, $q$SELECT NOT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000199HDFCCC99')$q$, 'fk_correo_encargado');

SELECT pg_temp.probar('fk_correo_encargado: UPDATE huérfano', $q$UPDATE "CorreoElectrónicoEncargado" SET "CURP"='EEEE000199HDFCCC99' WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000102HDFCCC02') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000199HDFCCC99')$q$, 'fk_correo_encargado');

-- fk_telefono_encargado: CASCADE / CASCADE.
SELECT pg_temp.probar('fk_telefono_encargado: DELETE CASCADE', $q$DELETE FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT NOT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000102HDFCCC02') AND NOT EXISTS(SELECT FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02')$q$);

SELECT pg_temp.probar('fk_telefono_encargado: UPDATE CASCADE', $q$UPDATE "Encargado de premios" SET "CURP"='EEEE000102HDFCCC12' WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000102HDFCCC12') AND NOT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000102HDFCCC02')$q$);

SELECT pg_temp.probar('fk_telefono_encargado: INSERT huérfano', $q$INSERT INTO "TeléfonoEncargado" VALUES ('EEEE000199HDFCCC99','5599999999')$q$, $q$SELECT NOT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000199HDFCCC99')$q$, 'fk_telefono_encargado');

SELECT pg_temp.probar('fk_telefono_encargado: UPDATE huérfano', $q$UPDATE "TeléfonoEncargado" SET "CURP"='EEEE000199HDFCCC99' WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000102HDFCCC02') AND NOT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000199HDFCCC99')$q$, 'fk_telefono_encargado');

-- Baja de un encargado sin canjes: se eliminan correos y teléfonos juntos.
SELECT pg_temp.probar('Encargado sin canjes: baja elimina correos y teléfonos', $q$DELETE FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT NOT EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000102HDFCCC02') AND NOT EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000102HDFCCC02') AND NOT EXISTS(SELECT FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02')$q$);

-- fk_canje_sucursal: RESTRICT / CASCADE.
SELECT pg_temp.probar('fk_canje_sucursal: DELETE RESTRICT', $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6101$q$, $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6101) AND EXISTS(SELECT FROM "Canje" WHERE "idSucursal"=6101) AND (SELECT count(*)=2 FROM "Disponer" WHERE "idSucursal"=6101)$q$, 'fk_canje_sucursal');

SELECT pg_temp.probar('fk_canje_sucursal: UPDATE CASCADE', $q$UPDATE "SUCURSAL" SET "idSucursal"=6111 WHERE "idSucursal"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idSucursal"=6111) AND (SELECT count(*)=2 FROM "Disponer" WHERE "idSucursal"=6111) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idSucursal"=6101) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6101)$q$);

SELECT pg_temp.probar('fk_canje_sucursal: INSERT huérfano', $q$INSERT INTO "Canje" VALUES (6199,6199,6101,6101,'EEEE000101HDFCCC01','12:00:00',10,1,'2026-01-01')$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6199)$q$, 'fk_canje_sucursal');

SELECT pg_temp.probar('fk_canje_sucursal: UPDATE huérfano', $q$UPDATE "Canje" SET "idSucursal"=6199 WHERE "idCanje"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101 AND "idSucursal"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idSucursal"=6199)$q$, 'fk_canje_sucursal');

-- fk_canje_cliente: RESTRICT / CASCADE.
SELECT pg_temp.probar('fk_canje_cliente: DELETE RESTRICT', $q$DELETE FROM "Cliente" WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6101) AND EXISTS(SELECT FROM "Canje" WHERE "idCliente"=6101)$q$, 'fk_canje_cliente');

SELECT pg_temp.probar('fk_canje_cliente: UPDATE CASCADE', $q$UPDATE "Cliente" SET "idCliente"=6111 WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCliente"=6111) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idCliente"=6101)$q$);

SELECT pg_temp.probar('fk_canje_cliente: INSERT huérfano', $q$INSERT INTO "Canje" VALUES (6199,6101,6199,6101,'EEEE000101HDFCCC01','12:00:00',10,1,'2026-01-01')$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6199)$q$, 'fk_canje_cliente');

SELECT pg_temp.probar('fk_canje_cliente: UPDATE huérfano', $q$UPDATE "Canje" SET "idCliente"=6199 WHERE "idCanje"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101 AND "idCliente"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idCliente"=6199)$q$, 'fk_canje_cliente');

-- fk_canje_premio: RESTRICT / CASCADE.
SELECT pg_temp.probar('fk_canje_premio: DELETE RESTRICT', $q$DELETE FROM "Premio" WHERE "idPremio"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Premio" WHERE "idPremio"=6101) AND EXISTS(SELECT FROM "Canje" WHERE "idPremio"=6101) AND (SELECT count(*)=2 FROM "Disponer" WHERE "idPremio"=6101)$q$, 'fk_canje_premio');

SELECT pg_temp.probar('fk_canje_premio: UPDATE CASCADE', $q$UPDATE "Premio" SET "idPremio"=6111 WHERE "idPremio"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idPremio"=6111) AND (SELECT count(*)=2 FROM "Disponer" WHERE "idPremio"=6111) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idPremio"=6101) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idPremio"=6101)$q$);

SELECT pg_temp.probar('fk_canje_premio: INSERT huérfano', $q$INSERT INTO "Canje" VALUES (6199,6101,6101,6199,'EEEE000101HDFCCC01','12:00:00',10,1,'2026-01-01')$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6199)$q$, 'fk_canje_premio');

SELECT pg_temp.probar('fk_canje_premio: UPDATE huérfano', $q$UPDATE "Canje" SET "idPremio"=6199 WHERE "idCanje"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101 AND "idPremio"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idPremio"=6199)$q$, 'fk_canje_premio');

-- fk_canje_encargado: RESTRICT / CASCADE.
SELECT pg_temp.probar('fk_canje_encargado: DELETE RESTRICT', $q$DELETE FROM "Encargado de premios" WHERE "CURP"='EEEE000101HDFCCC01'$q$, $q$SELECT EXISTS(SELECT FROM "Encargado de premios" WHERE "CURP"='EEEE000101HDFCCC01') AND EXISTS(SELECT FROM "Canje" WHERE "CURP"='EEEE000101HDFCCC01') AND EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000101HDFCCC01') AND EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000101HDFCCC01')$q$, 'fk_canje_encargado');

SELECT pg_temp.probar('fk_canje_encargado: UPDATE CASCADE', $q$UPDATE "Encargado de premios" SET "CURP"='EEEE000101HDFCCC11' WHERE "CURP"='EEEE000101HDFCCC01'$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "CURP"='EEEE000101HDFCCC11') AND EXISTS(SELECT FROM "CorreoElectrónicoEncargado" WHERE "CURP"='EEEE000101HDFCCC11') AND EXISTS(SELECT FROM "TeléfonoEncargado" WHERE "CURP"='EEEE000101HDFCCC11') AND NOT EXISTS(SELECT FROM "Canje" WHERE "CURP"='EEEE000101HDFCCC01')$q$);

SELECT pg_temp.probar('fk_canje_encargado: INSERT huérfano', $q$INSERT INTO "Canje" VALUES (6199,6101,6101,6101,'EEEE000199HDFCCC99','12:00:00',10,1,'2026-01-01')$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101) AND NOT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6199)$q$, 'fk_canje_encargado');

SELECT pg_temp.probar('fk_canje_encargado: UPDATE huérfano', $q$UPDATE "Canje" SET "CURP"='EEEE000199HDFCCC99' WHERE "idCanje"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Canje" WHERE "idCanje"=6101 AND "CURP"='EEEE000101HDFCCC01') AND NOT EXISTS(SELECT FROM "Canje" WHERE "CURP"='EEEE000199HDFCCC99')$q$, 'fk_canje_encargado');

-- fk_disponer_sucursal: CASCADE / CASCADE.
SELECT pg_temp.probar('fk_disponer_sucursal: DELETE CASCADE', $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6102$q$, $q$SELECT NOT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6102) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6102) AND EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6101)$q$);

SELECT pg_temp.probar('fk_disponer_sucursal: UPDATE CASCADE', $q$UPDATE "SUCURSAL" SET "idSucursal"=6112 WHERE "idSucursal"=6102$q$, $q$SELECT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6112 AND "idPremio"=6101) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6102)$q$);

SELECT pg_temp.probar('fk_disponer_sucursal: INSERT huérfano', $q$INSERT INTO "Disponer" VALUES (6199,6101,5)$q$, $q$SELECT NOT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6199) AND (SELECT count(*)=3 FROM "Disponer")$q$, 'fk_disponer_sucursal');

SELECT pg_temp.probar('fk_disponer_sucursal: UPDATE huérfano', $q$UPDATE "Disponer" SET "idSucursal"=6199 WHERE "idSucursal"=6102 AND "idPremio"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6102 AND "idPremio"=6101) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6199)$q$, 'fk_disponer_sucursal');

-- fk_disponer_premio: CASCADE / CASCADE.
SELECT pg_temp.probar('fk_disponer_premio: DELETE CASCADE', $q$DELETE FROM "Premio" WHERE "idPremio"=6102$q$, $q$SELECT NOT EXISTS(SELECT FROM "Premio" WHERE "idPremio"=6102) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idPremio"=6102) AND EXISTS(SELECT FROM "Disponer" WHERE "idPremio"=6101)$q$);

SELECT pg_temp.probar('fk_disponer_premio: UPDATE CASCADE', $q$UPDATE "Premio" SET "idPremio"=6112 WHERE "idPremio"=6102$q$, $q$SELECT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6101 AND "idPremio"=6112) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idPremio"=6102)$q$);

SELECT pg_temp.probar('fk_disponer_premio: INSERT huérfano', $q$INSERT INTO "Disponer" VALUES (6101,6199,5)$q$, $q$SELECT NOT EXISTS(SELECT FROM "Disponer" WHERE "idPremio"=6199) AND (SELECT count(*)=3 FROM "Disponer")$q$, 'fk_disponer_premio');

SELECT pg_temp.probar('fk_disponer_premio: UPDATE huérfano', $q$UPDATE "Disponer" SET "idPremio"=6199 WHERE "idSucursal"=6101 AND "idPremio"=6102$q$, $q$SELECT EXISTS(SELECT FROM "Disponer" WHERE "idSucursal"=6101 AND "idPremio"=6102) AND NOT EXISTS(SELECT FROM "Disponer" WHERE "idPremio"=6199)$q$, 'fk_disponer_premio');

-- fkencargadopremiossucursal: RESTRICT / CASCADE.
SELECT pg_temp.probar('fkencargadopremiossucursal: DELETE RESTRICT', $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6103$q$, $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6103) AND (SELECT count(*)=2 FROM "Encargado de premios" WHERE "idSucursal"=6103)$q$, 'fkencargadopremiossucursal');

SELECT pg_temp.probar('fkencargadopremiossucursal: UPDATE CASCADE', $q$UPDATE "SUCURSAL" SET "idSucursal"=6113 WHERE "idSucursal"=6103$q$, $q$SELECT (SELECT count(*)=2 FROM "Encargado de premios" WHERE "idSucursal"=6113) AND NOT EXISTS(SELECT FROM "Encargado de premios" WHERE "idSucursal"=6103)$q$);

SELECT pg_temp.probar('fkencargadopremiossucursal: INSERT huérfano', $q$INSERT INTO "Encargado de premios" VALUES ('EEEE000198HDFCCC98',6199,'Encargado','Materno','Paterno','EEEE000198AB1','2020-01-01',1000,'2000-01-01','07:00')$q$, $q$SELECT NOT EXISTS(SELECT FROM "Encargado de premios" WHERE "CURP"='EEEE000198HDFCCC98') AND (SELECT count(*)=2 FROM "Encargado de premios")$q$, 'fkencargadopremiossucursal');

SELECT pg_temp.probar('fkencargadopremiossucursal: UPDATE huérfano', $q$UPDATE "Encargado de premios" SET "idSucursal"=6199 WHERE "CURP"='EEEE000102HDFCCC02'$q$, $q$SELECT EXISTS(SELECT FROM "Encargado de premios" WHERE "CURP"='EEEE000102HDFCCC02' AND "idSucursal"=6103) AND NOT EXISTS(SELECT FROM "Encargado de premios" WHERE "idSucursal"=6199)$q$, 'fkencargadopremiossucursal');

-- Catálogo: políticas y comentarios.
SELECT pg_temp.probar('Politicas: nueve FK explicitas', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=9 AND bool_and(NOT k.condeferrable AND k.confupdtype='c' AND k.confdeltype=e.accion::"char") FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid JOIN (VALUES ('fk_correo_encargado','c'),('fk_telefono_encargado','c'),('fk_canje_sucursal','r'),('fk_canje_cliente','r'),('fk_canje_premio','r'),('fk_canje_encargado','r'),('fk_disponer_sucursal','c'),('fk_disponer_premio','c'),('fkencargadopremiossucursal','r')) AS e(nombre,accion) ON e.nombre=k.conname WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('Premio','Canje','Disponer','Encargado de premios','CorreoElectrónicoEncargado','TeléfonoEncargado') AND k.contype='f')$q$);

SELECT pg_temp.probar('Comentarios: 6 tablas', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=6 AND bool_and(obj_description(oid,'pg_class') IS NOT NULL) FROM pg_class WHERE relnamespace='public'::regnamespace AND relname IN ('Premio','Canje','Disponer','Encargado de premios','CorreoElectrónicoEncargado','TeléfonoEncargado'))$q$);

SELECT pg_temp.probar('Comentarios: 32 columnas obligatorias', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=32 AND bool_and(col_description(c.oid,a.attnum) IS NOT NULL AND a.attnotnull) FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('Premio','Canje','Disponer','Encargado de premios','CorreoElectrónicoEncargado','TeléfonoEncargado') AND a.attnum>0 AND NOT a.attisdropped)$q$);

SELECT pg_temp.probar('Comentarios: 77 constraints con NOT NULL', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=77 AND bool_and(obj_description(k.oid,'pg_constraint') IS NOT NULL) FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('Premio','Canje','Disponer','Encargado de premios','CorreoElectrónicoEncargado','TeléfonoEncargado'))$q$);

TABLE resultados;
SELECT count(*) AS casos_correctos, bool_and(resultado='OK') AS todos_correctos FROM resultados;
ROLLBACK;
-- En una base recién creada, todas las tablas deben seguir sin datos.
DO $$ DECLARE r record; n bigint; BEGIN
 FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='public' LOOP
  EXECUTE format('SELECT count(*) FROM public.%I',r.tablename) INTO n;
  IF n<>0 THEN RAISE EXCEPTION 'Base de prueba no vacía tras ROLLBACK: %',r.tablename; END IF;
 END LOOP;
END $$;
SELECT 'Todas las tablas sin datos tras ROLLBACK' AS limpieza;