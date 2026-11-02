-- Práctica 06 | Módulo 04 | Yahir
-- psql -X -v ON_ERROR_STOP=1 -f pruebas.sql
-- Base AISLADA con DDL completo, politicas.sql y comentarios.sql aplicados.
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

-- ============================================================
-- Fixtures comunes
-- ============================================================
-- SUCURSAL 6101: aloja al Cajero y al Cliente/Tarjeta.
-- SUCURSAL 6102: solo con horario, para probar CASCADE puro.
-- SUCURSAL 6103: aloja VISITA y RECARGA, sin Cajero propio.
INSERT INTO "SUCURSAL" VALUES
 (6101,'Sucursal prueba','5512345678','Calle prueba',1,0,'Centro','CDMX'),
 (6102,'Sucursal horario','5512345679','Calle horario',2,0,'Centro','CDMX'),
 (6103,'Sucursal operaciones','5512345680','Calle operaciones',3,0,'Centro','CDMX');

INSERT INTO "Cajero" VALUES
 ('AAAA000101HDFBBB01',6101,'Prueba','Materno','Paterno','AAAA000101AB1','2020-01-01',1000,'2000-01-01','07:00');

INSERT INTO "Cliente" VALUES
 (6101,'2000-01-01','Cliente','Materno','Paterno','H');

INSERT INTO "Tarjeta" VALUES
 (6101,6101,'AAAA000101HDFBBB01',10,'2026-01-01',100,'Activa',50);

INSERT INTO "HORARIO_SUCURSAL" VALUES
 (6101,'Lunes a viernes 9-18'),
 (6102,'Lunes a viernes 10-19'),
 (6103,'Sábado 9-14');

INSERT INTO "VISITA" VALUES
 (6101,6101,6103,6101,'2026-01-01');

INSERT INTO "RECARGA" VALUES
 (6101,6101,6103,6101,'AAAA000101HDFBBB01',100,'2026-01-01','12:00:00-06','Efectivo');

-- ============================================================
-- fk_horario_sucursal: ON DELETE CASCADE / ON UPDATE CASCADE
-- ============================================================
SELECT pg_temp.probar(
  'fk_horario_sucursal: DELETE CASCADE',
  $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6102$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6102)
       AND NOT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6102)$q$
);

SELECT pg_temp.probar(
  'fk_horario_sucursal: UPDATE CASCADE',
  $q$UPDATE "SUCURSAL" SET "idSucursal"=6112 WHERE "idSucursal"=6102$q$,
  $q$SELECT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6112)
       AND NOT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6102)$q$
);

SELECT pg_temp.probar(
  'fk_horario_sucursal: INSERT huérfano',
  $q$INSERT INTO "HORARIO_SUCURSAL" VALUES (6199,'Lunes 9-18')$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6199)$q$,
  'fk_horario_sucursal'
);

SELECT pg_temp.probar(
  'fk_horario_sucursal: UPDATE huérfano',
  $q$UPDATE "HORARIO_SUCURSAL" SET "idSucursal"=6199 WHERE "idSucursal"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6101)
       AND NOT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6199)$q$,
  'fk_horario_sucursal'
);

-- ============================================================
-- fk_visita_tarjeta: ON DELETE RESTRICT / ON UPDATE CASCADE
-- ============================================================
SELECT pg_temp.probar(
  'fk_visita_tarjeta: DELETE RESTRICT',
  $q$DELETE FROM "Tarjeta" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)
       AND EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)$q$,
  'fk_visita_tarjeta'
);

SELECT pg_temp.probar(
  'fk_visita_tarjeta: UPDATE CASCADE',
  $q$UPDATE "Tarjeta" SET "idCliente"=6111,"numeroTarjeta"=6111
       WHERE "idCliente"=6101 AND "numeroTarjeta"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6111 AND "numeroTarjeta"=6111)
       AND NOT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)$q$
);

SELECT pg_temp.probar(
  'fk_visita_tarjeta: INSERT huérfano',
  $q$INSERT INTO "VISITA" VALUES (6199,6199,6103,6199,'2026-01-01')$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6199)$q$,
  'fk_visita_tarjeta'
);

SELECT pg_temp.probar(
  'fk_visita_tarjeta: UPDATE huérfano',
  $q$UPDATE "VISITA" SET "idCliente"=6199 WHERE "idCliente"=6101 AND "numeroTarjeta"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)
       AND NOT EXISTS(SELECT FROM "VISITA" WHERE "idCliente"=6199)$q$,
  'fk_visita_tarjeta'
);

-- ============================================================
-- fk_visita_sucursal: ON DELETE RESTRICT / ON UPDATE CASCADE
-- ============================================================
SELECT pg_temp.probar(
  'fk_visita_sucursal: DELETE RESTRICT',
  $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6103)
       AND EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6103)$q$,
  'fk_visita_sucursal'
);

SELECT pg_temp.probar(
  'fk_visita_sucursal: UPDATE CASCADE',
  $q$UPDATE "SUCURSAL" SET "idSucursal"=6113 WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6113)
       AND NOT EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6103)$q$
);

SELECT pg_temp.probar(
  'fk_visita_sucursal: INSERT huérfano',
  $q$INSERT INTO "VISITA" VALUES (6101,6101,6199,6199,'2026-01-01')$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6199)$q$,
  'fk_visita_sucursal'
);

SELECT pg_temp.probar(
  'fk_visita_sucursal: UPDATE huérfano',
  $q$UPDATE "VISITA" SET "idSucursal"=6199 WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6103)
       AND NOT EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6199)$q$,
  'fk_visita_sucursal'
);

-- ============================================================
-- fk_recarga_tarjeta: ON DELETE RESTRICT / ON UPDATE CASCADE
-- ============================================================
SELECT pg_temp.probar(
  'fk_recarga_tarjeta: DELETE RESTRICT',
  $q$DELETE FROM "Tarjeta" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "Tarjeta" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)
       AND EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)$q$,
  'fk_recarga_tarjeta'
);

SELECT pg_temp.probar(
  'fk_recarga_tarjeta: UPDATE CASCADE',
  $q$UPDATE "Tarjeta" SET "idCliente"=6111,"numeroTarjeta"=6111
       WHERE "idCliente"=6101 AND "numeroTarjeta"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6111 AND "numeroTarjeta"=6111)
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)$q$
);

SELECT pg_temp.probar(
  'fk_recarga_tarjeta: INSERT huérfano',
  $q$INSERT INTO "RECARGA" VALUES (6199,6199,6103,6199,'AAAA000101HDFBBB01',100,'2026-01-01','12:00:00-06','Efectivo')$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6199)$q$,
  'fk_recarga_tarjeta'
);

SELECT pg_temp.probar(
  'fk_recarga_tarjeta: UPDATE huérfano',
  $q$UPDATE "RECARGA" SET "idCliente"=6199 WHERE "idCliente"=6101 AND "numeroTarjeta"=6101$q$,
  $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6101 AND "numeroTarjeta"=6101)
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "idCliente"=6199)$q$,
  'fk_recarga_tarjeta'
);

-- ============================================================
-- fk_recarga_sucursal: ON DELETE RESTRICT / ON UPDATE CASCADE
-- ============================================================
SELECT pg_temp.probar(
  'fk_recarga_sucursal: DELETE RESTRICT',
  $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6103)
       AND EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6103)$q$,
  'fk_recarga_sucursal'
);

SELECT pg_temp.probar(
  'fk_recarga_sucursal: UPDATE CASCADE',
  $q$UPDATE "SUCURSAL" SET "idSucursal"=6113 WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6113)
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6103)$q$
);

SELECT pg_temp.probar(
  'fk_recarga_sucursal: INSERT huérfano',
  $q$INSERT INTO "RECARGA" VALUES (6101,6101,6199,6199,'AAAA000101HDFBBB01',100,'2026-01-01','12:00:00-06','Efectivo')$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6199)$q$,
  'fk_recarga_sucursal'
);

SELECT pg_temp.probar(
  'fk_recarga_sucursal: UPDATE huérfano',
  $q$UPDATE "RECARGA" SET "idSucursal"=6199 WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6103)
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6199)$q$,
  'fk_recarga_sucursal'
);

-- ============================================================
-- fk_recarga_cajero: ON DELETE RESTRICT / ON UPDATE CASCADE
-- ============================================================
SELECT pg_temp.probar(
  'fk_recarga_cajero: DELETE RESTRICT',
  $q$DELETE FROM "Cajero" WHERE "CURP"='AAAA000101HDFBBB01'$q$,
  $q$SELECT EXISTS(SELECT FROM "Cajero" WHERE "CURP"='AAAA000101HDFBBB01')
       AND EXISTS(SELECT FROM "RECARGA" WHERE "CURP"='AAAA000101HDFBBB01')$q$,
  'fk_recarga_cajero'
);

SELECT pg_temp.probar(
  'fk_recarga_cajero: UPDATE CASCADE',
  $q$UPDATE "Cajero" SET "CURP"='AAAA000101HDFBBB02'
       WHERE "CURP"='AAAA000101HDFBBB01'$q$,
  $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "CURP"='AAAA000101HDFBBB02')
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "CURP"='AAAA000101HDFBBB01')$q$
);

SELECT pg_temp.probar(
  'fk_recarga_cajero: INSERT huérfano',
  $q$INSERT INTO "RECARGA" VALUES (6101,6101,6103,6199,'AAAA000101HDFBBB99',100,'2026-01-01','12:00:00-06','Efectivo')$q$,
  $q$SELECT NOT EXISTS(SELECT FROM "RECARGA" WHERE "CURP"='AAAA000101HDFBBB99')$q$,
  'fk_recarga_cajero'
);

SELECT pg_temp.probar(
  'fk_recarga_cajero: UPDATE huérfano',
  $q$UPDATE "RECARGA" SET "CURP"='AAAA000101HDFBBB99' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
  $q$SELECT EXISTS(SELECT FROM "RECARGA" WHERE "CURP"='AAAA000101HDFBBB01')
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "CURP"='AAAA000101HDFBBB99')$q$,
  'fk_recarga_cajero'
);

-- ============================================================
-- Cadena: UPDATE SUCURSAL 6103 propaga a HORARIO, VISITA y RECARGA
-- ============================================================
SELECT pg_temp.probar(
  'Cadena SUCURSAL-HORARIO-VISITA-RECARGA',
  $q$UPDATE "SUCURSAL" SET "idSucursal"=6113 WHERE "idSucursal"=6103$q$,
  $q$SELECT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6113)
       AND EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6113)
       AND EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6113)
       AND NOT EXISTS(SELECT FROM "HORARIO_SUCURSAL" WHERE "idSucursal"=6103)
       AND NOT EXISTS(SELECT FROM "VISITA" WHERE "idSucursal"=6103)
       AND NOT EXISTS(SELECT FROM "RECARGA" WHERE "idSucursal"=6103)$q$
);

-- ============================================================
-- Comentarios y políticas
-- ============================================================
SELECT pg_temp.probar(
  'Comentarios: 4 tablas',
  $q$SELECT 1$q$,
  $q$SELECT (SELECT count(*)=4 AND bool_and(obj_description(oid,'pg_class') IS NOT NULL)
             FROM pg_class
             WHERE relnamespace='public'::regnamespace
               AND relname IN ('SUCURSAL','HORARIO_SUCURSAL','VISITA','RECARGA'))$q$
);

SELECT pg_temp.probar(
  'Comentarios: 24 columnas',
  $q$SELECT 1$q$,
  $q$SELECT (SELECT count(*)=24 AND bool_and(col_description(c.oid,a.attnum) IS NOT NULL)
             FROM pg_attribute a
             JOIN pg_class c ON c.oid=a.attrelid
             WHERE c.relnamespace='public'::regnamespace
               AND c.relname IN ('SUCURSAL','HORARIO_SUCURSAL','VISITA','RECARGA')
               AND a.attnum>0 AND NOT a.attisdropped)$q$
);

SELECT pg_temp.probar(
  'Comentarios: todas las restricciones',
  $q$SELECT 1$q$,
  $q$SELECT bool_and(obj_description(k.oid,'pg_constraint') IS NOT NULL)
       FROM pg_constraint k
       JOIN pg_class c ON c.oid=k.conrelid
       WHERE c.relnamespace='public'::regnamespace
         AND c.relname IN ('SUCURSAL','HORARIO_SUCURSAL','VISITA','RECARGA')$q$
);

SELECT pg_temp.probar(
  'Políticas: seis FK explícitas',
  $q$SELECT 1$q$,
  $q$SELECT (SELECT count(*)=6
             AND bool_and(confupdtype='c' AND NOT condeferrable
                          AND confdeltype = CASE WHEN c.relname='HORARIO_SUCURSAL' THEN 'c'::char ELSE 'r'::char END)
             FROM pg_constraint k
             JOIN pg_class c ON c.oid=k.conrelid
             WHERE c.relnamespace='public'::regnamespace
               AND c.relname IN ('HORARIO_SUCURSAL','VISITA','RECARGA')
               AND contype='f')$q$
);

-- ============================================================
-- Resultados y limpieza
-- ============================================================
TABLE resultados;
SELECT count(*) AS casos_correctos,
       bool_and(resultado='OK') AS todos_correctos
FROM resultados;

ROLLBACK;

-- En una base recién creada, las 4 tablas del módulo deben seguir sin datos.
DO $$ DECLARE r record; n bigint; BEGIN
  FOR r IN SELECT tablename FROM pg_tables
           WHERE schemaname='public'
             AND tablename IN ('SUCURSAL','HORARIO_SUCURSAL','VISITA','RECARGA') LOOP
    EXECUTE format('SELECT count(*) FROM public.%I',r.tablename) INTO n;
    IF n<>0 THEN RAISE EXCEPTION 'Tabla no vacía tras ROLLBACK: %',r.tablename; END IF;
  END LOOP;
END $$;
SELECT 'Tablas del módulo sin datos tras ROLLBACK' AS limpieza;
