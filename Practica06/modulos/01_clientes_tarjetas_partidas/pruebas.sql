-- Práctica 06 | Omar Alejandro Juárez Larrondo
-- psql -X -v ON_ERROR_STOP=1 -f pruebas.sql
-- Base AISLADA con DDL completo y políticas de los cinco módulos aplicadas.
-- Requiere comentarios del módulo 01 y UPDATE CASCADE del módulo 04.
-- Los identificadores 6101..6199 y las CURP sintéticas deben estar libres.
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

INSERT INTO "SUCURSAL" VALUES (6101,'Sucursal prueba','5512345678','Calle prueba',1,0,'Centro','CDMX');
INSERT INTO "Cajero" VALUES ('AAAA000101HDFBBB01',6101,'Prueba','Materno','Paterno','AAAA000101AB1','2020-01-01',1000,'2000-01-01','07:00');
INSERT INTO "tipoDeJuego" VALUES (6101,'Sumar puntos','Activo','Prueba');
INSERT INTO "Juego" VALUES (6101,10,'Juego prueba',6101);
INSERT INTO "Máquina" VALUES (6101,'Activa',6101,6101);
INSERT INTO "Cliente" VALUES
 (6101,'2000-01-01','Cliente','Materno','Paterno','H'),
 (6102,'2000-01-01','Sin tarjeta','Materno','Paterno','M'),
 (6103,'2000-01-01','Contactos','Materno','Paterno','H');
INSERT INTO "correoElectrónico" VALUES (6103,'prueba@example.test');
INSERT INTO "teléfono" VALUES (6103,'5512345678');
INSERT INTO "Tarjeta" VALUES (6101,6101,'AAAA000101HDFBBB01',10,'2026-01-01',100,'Activa',50);
INSERT INTO "Partida" VALUES (6101,6101,6101,6101,'2026-01-01',10,'12:00:00-06',100);

SELECT pg_temp.probar('fk_correo_cliente: DELETE CASCADE', $q$DELETE FROM "Cliente" WHERE "idCliente"=6103$q$, $q$SELECT NOT EXISTS(SELECT FROM "correoElectrónico" WHERE "idCliente"=6103) AND NOT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6103)$q$);

SELECT pg_temp.probar('fk_correo_cliente: UPDATE CASCADE', $q$UPDATE "Cliente" SET "idCliente"=6113 WHERE "idCliente"=6103$q$, $q$SELECT EXISTS(SELECT FROM "correoElectrónico" WHERE "idCliente"=6113) AND NOT EXISTS(SELECT FROM "correoElectrónico" WHERE "idCliente"=6103)$q$);

SELECT pg_temp.probar('fk_correo_cliente: INSERT huérfano', $q$INSERT INTO "correoElectrónico" VALUES (6199,'nuevo@example.test')$q$, $q$SELECT NOT EXISTS(SELECT FROM "correoElectrónico" WHERE "idCliente"=6199)$q$, 'fk_correo_cliente');

SELECT pg_temp.probar('fk_correo_cliente: UPDATE huérfano', $q$UPDATE "correoElectrónico" SET "idCliente"=6199 WHERE "idCliente"=6103$q$, $q$SELECT EXISTS(SELECT FROM "correoElectrónico" WHERE "idCliente"=6103) AND NOT EXISTS(SELECT FROM "correoElectrónico" WHERE "idCliente"=6199)$q$, 'fk_correo_cliente');

SELECT pg_temp.probar('fk_telefono_cliente: DELETE CASCADE', $q$DELETE FROM "Cliente" WHERE "idCliente"=6103$q$, $q$SELECT NOT EXISTS(SELECT FROM "teléfono" WHERE "idCliente"=6103) AND NOT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6103)$q$);

SELECT pg_temp.probar('fk_telefono_cliente: UPDATE CASCADE', $q$UPDATE "Cliente" SET "idCliente"=6113 WHERE "idCliente"=6103$q$, $q$SELECT EXISTS(SELECT FROM "teléfono" WHERE "idCliente"=6113) AND NOT EXISTS(SELECT FROM "teléfono" WHERE "idCliente"=6103)$q$);

SELECT pg_temp.probar('fk_telefono_cliente: INSERT huérfano', $q$INSERT INTO "teléfono" VALUES (6199,'5599999999')$q$, $q$SELECT NOT EXISTS(SELECT FROM "teléfono" WHERE "idCliente"=6199)$q$, 'fk_telefono_cliente');

SELECT pg_temp.probar('fk_telefono_cliente: UPDATE huérfano', $q$UPDATE "teléfono" SET "idCliente"=6199 WHERE "idCliente"=6103$q$, $q$SELECT EXISTS(SELECT FROM "teléfono" WHERE "idCliente"=6103) AND NOT EXISTS(SELECT FROM "teléfono" WHERE "idCliente"=6199)$q$, 'fk_telefono_cliente');

SELECT pg_temp.probar('fk_tarjeta_cliente: DELETE NO ACTION', $q$DELETE FROM "Cliente" WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6101) AND EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6101)$q$, 'fk_tarjeta_cliente');

SELECT pg_temp.probar('fk_tarjeta_cliente: UPDATE CASCADE', $q$UPDATE "Cliente" SET "idCliente"=6111 WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6111) AND NOT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6101)$q$);

SELECT pg_temp.probar('fk_tarjeta_cliente: INSERT huérfano', $q$INSERT INTO "Tarjeta" VALUES (6199,6101,'AAAA000101HDFBBB01',10,'2026-01-01',100,'Activa',50)$q$, $q$SELECT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6101) AND EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6101) AND NOT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6199)$q$, 'fk_tarjeta_cliente');

SELECT pg_temp.probar('fk_tarjeta_cliente: UPDATE huérfano', $q$UPDATE "Tarjeta" SET "idCliente"=6199$q$, $q$SELECT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6101) AND EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6101) AND NOT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6199)$q$, 'fk_tarjeta_cliente');

SELECT pg_temp.probar('fk_tarjeta_cajero: DELETE NO ACTION', $q$DELETE FROM "Cajero" WHERE "CURP"='AAAA000101HDFBBB01'$q$, $q$SELECT EXISTS(SELECT FROM "Cajero" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB01')$q$, 'fk_tarjeta_cajero');

SELECT pg_temp.probar('fk_tarjeta_cajero: UPDATE CASCADE', $q$UPDATE "Cajero" SET "CURP"='AAAA000101HDFBBB02' WHERE "CURP"='AAAA000101HDFBBB01'$q$, $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_tarjeta_cajero: INSERT huérfano', $q$INSERT INTO "Tarjeta" VALUES (6102,6102,'AAAA000101HDFBBB99',10,'2026-01-01',100,'Activa',50)$q$, $q$SELECT EXISTS(SELECT FROM "Cajero" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB99')$q$, 'fk_tarjeta_cajero');

SELECT pg_temp.probar('fk_tarjeta_cajero: UPDATE huérfano', $q$UPDATE "Tarjeta" SET "CURP"='AAAA000101HDFBBB99'$q$, $q$SELECT EXISTS(SELECT FROM "Cajero" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Tarjeta" WHERE "CURP"='AAAA000101HDFBBB99')$q$, 'fk_tarjeta_cajero');

SELECT pg_temp.probar('fk_partida_tarjeta: DELETE NO ACTION', $q$DELETE FROM "Tarjeta" WHERE "numeroTarjeta"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "numeroTarjeta"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "numeroTarjeta"=6101)$q$, 'fk_partida_tarjeta');

SELECT pg_temp.probar('fk_partida_tarjeta: UPDATE CASCADE', $q$UPDATE "Tarjeta" SET "numeroTarjeta"=6111 WHERE "numeroTarjeta"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Partida" WHERE "numeroTarjeta"=6111) AND NOT EXISTS(SELECT FROM "Partida" WHERE "numeroTarjeta"=6101)$q$);

SELECT pg_temp.probar('fk_partida_tarjeta: INSERT huérfano', $q$INSERT INTO "Partida" VALUES (6102,6101,6101,6102,'2026-01-01',10,'12:00:00-06',100)$q$, $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "numeroTarjeta"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "numeroTarjeta"=6101) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6102)$q$, 'fk_partida_tarjeta');

SELECT pg_temp.probar('fk_partida_tarjeta: UPDATE huérfano', $q$UPDATE "Partida" SET "idCliente"=6102$q$, $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "numeroTarjeta"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "numeroTarjeta"=6101) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6102)$q$, 'fk_partida_tarjeta');

SELECT pg_temp.probar('fk_partida_maquina: DELETE NO ACTION', $q$DELETE FROM "Máquina" WHERE "idMaquina"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6101)$q$, 'fk_partida_maquina');

SELECT pg_temp.probar('fk_partida_maquina: UPDATE CASCADE', $q$UPDATE "Máquina" SET "idMaquina"=6111 WHERE "idMaquina"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6111) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6101)$q$);

SELECT pg_temp.probar('fk_partida_maquina: INSERT huérfano', $q$INSERT INTO "Partida" VALUES (6101,6101,6199,6102,'2026-01-01',10,'12:00:00-06',100)$q$, $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6101) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6199)$q$, 'fk_partida_maquina');

SELECT pg_temp.probar('fk_partida_maquina: UPDATE huérfano', $q$UPDATE "Partida" SET "idMaquina"=6199$q$, $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6101) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6199)$q$, 'fk_partida_maquina');

SELECT pg_temp.probar('Cadena Cliente-Tarjeta-Partida', $q$UPDATE "Cliente" SET "idCliente"=6111 WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6111 AND "numeroTarjeta"=6101) AND EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6111 AND "numeroTarjeta"=6101) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6101)$q$);

SELECT pg_temp.probar('Clave compuesta: ambos componentes', $q$UPDATE "Tarjeta" SET "idCliente"=6102,"numeroTarjeta"=6112 WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6102 AND "numeroTarjeta"=6112) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6101)$q$);

SELECT pg_temp.probar('Clave compuesta: numero inexistente', $q$UPDATE "Partida" SET "numeroTarjeta"=6199$q$, $q$SELECT EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)$q$, 'fk_partida_tarjeta');

SELECT pg_temp.probar('Cliente sin tarjeta: borrado permitido', $q$DELETE FROM "Cliente" WHERE "idCliente"=6102$q$, $q$SELECT NOT EXISTS(SELECT FROM "Cliente" WHERE "idCliente"=6102)$q$);

SAVEPOINT dependencia;
INSERT INTO "VISITA" VALUES (6101,6101,6101,6101,'2026-01-01');

SELECT pg_temp.probar('VISITA: cadena integrada UPDATE CASCADE', $q$UPDATE "Cliente" SET "idCliente"=6111 WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6111) AND EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6111) AND EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6111) AND NOT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6101)$q$);
DELETE FROM "VISITA" WHERE "idCliente"=6101;
RELEASE SAVEPOINT dependencia;

SAVEPOINT dependencia;
INSERT INTO "RECARGA" VALUES (6101,6101,6101,6101,'AAAA000101HDFBBB01',10,'2026-01-01','12:00:00-06','Efectivo');

SELECT pg_temp.probar('RECARGA: cadena integrada UPDATE CASCADE', $q$UPDATE "Cliente" SET "idCliente"=6111 WHERE "idCliente"=6101$q$, $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6111) AND EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6111) AND EXISTS(SELECT FROM "Partida" WHERE "idCliente"=6111) AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6101)$q$);
DELETE FROM "RECARGA" WHERE "idCliente"=6101;
RELEASE SAVEPOINT dependencia;

CREATE TEMP TABLE padre_demo(id integer PRIMARY KEY);
CREATE TEMP TABLE hijo_demo(id integer PRIMARY KEY, padre integer NOT NULL,
 CONSTRAINT fk_demo FOREIGN KEY(padre) REFERENCES padre_demo(id)
 ON DELETE NO ACTION ON UPDATE NO ACTION DEFERRABLE INITIALLY IMMEDIATE);
INSERT INTO padre_demo VALUES(1);
INSERT INTO hijo_demo VALUES(1,1);

SELECT pg_temp.probar('NO ACTION inmediato', $q$DELETE FROM padre_demo WHERE id=1$q$, $q$SELECT EXISTS(SELECT FROM padre_demo WHERE id=1) AND EXISTS(SELECT FROM hijo_demo WHERE padre=1)$q$, 'fk_demo');
SET CONSTRAINTS fk_demo DEFERRED;
UPDATE padre_demo SET id=2 WHERE id=1;
UPDATE hijo_demo SET padre=2 WHERE padre=1;
SET CONSTRAINTS fk_demo IMMEDIATE;

SELECT pg_temp.probar('NO ACTION diferido reparado', $q$SELECT 1$q$, $q$SELECT EXISTS(SELECT FROM padre_demo WHERE id=2) AND EXISTS(SELECT FROM hijo_demo WHERE padre=2)$q$);
DELETE FROM hijo_demo;
CREATE TEMP TABLE hijo_restrict(id integer PRIMARY KEY, padre integer NOT NULL,
 CONSTRAINT fk_restrict_demo FOREIGN KEY(padre) REFERENCES padre_demo(id)
 ON DELETE RESTRICT ON UPDATE RESTRICT DEFERRABLE INITIALLY DEFERRED);
INSERT INTO hijo_restrict VALUES(1,2);

SELECT pg_temp.probar('RESTRICT no pospone accion', $q$UPDATE padre_demo SET id=3 WHERE id=2$q$, $q$SELECT EXISTS(SELECT FROM padre_demo WHERE id=2) AND EXISTS(SELECT FROM hijo_restrict WHERE padre=2)$q$, 'fk_restrict_demo');

SELECT pg_temp.probar('Comentarios: 5 tablas', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=5 AND bool_and(obj_description(oid,'pg_class') IS NOT NULL) FROM pg_class WHERE relnamespace='public'::regnamespace AND relname IN ('Cliente','correoElectrónico','teléfono','Tarjeta','Partida'))$q$);

SELECT pg_temp.probar('Comentarios: 26 columnas obligatorias', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=26 AND bool_and(col_description(c.oid,a.attnum) IS NOT NULL AND a.attnotnull) FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('Cliente','correoElectrónico','teléfono','Tarjeta','Partida') AND a.attnum>0 AND NOT a.attisdropped)$q$);

SELECT pg_temp.probar('Comentarios: 62 constraints con NOT NULL', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=62 AND bool_and(obj_description(k.oid,'pg_constraint') IS NOT NULL) FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('Cliente','correoElectrónico','teléfono','Tarjeta','Partida'))$q$);

SELECT pg_temp.probar('Politicas: seis FK explicitas', $q$SELECT 1$q$, $q$SELECT (SELECT count(*)=6 AND bool_and(confupdtype='c' AND NOT condeferrable AND confdeltype=CASE WHEN c.relname IN ('correoElectrónico','teléfono') THEN 'c'::char ELSE 'a'::char END) FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('Cliente','correoElectrónico','teléfono','Tarjeta','Partida') AND contype='f')$q$);

TABLE resultados;
SELECT count(*) AS casos_correctos, bool_and(resultado='OK') AS todos_correctos FROM resultados;
ROLLBACK;
-- En una base recién creada, las 30 tablas deben seguir sin datos.
DO $$ DECLARE r record; n bigint; BEGIN
 FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='public' LOOP
  EXECUTE format('SELECT count(*) FROM public.%I',r.tablename) INTO n;
  IF n<>0 THEN RAISE EXCEPTION 'Base de prueba no vacía tras ROLLBACK: %',r.tablename; END IF;
 END LOOP;
END $$;
SELECT '30 tablas sin datos tras ROLLBACK' AS limpieza;
