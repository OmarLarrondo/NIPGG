-- Práctica 06 | Módulo 02 | Miguel Ángel Jiménez Ramírez
-- psql -X -v ON_ERROR_STOP=1 -f pruebas.sql
-- Base AISLADA y VACÍA: DDL completo, políticas y comentarios del módulo aplicados.
-- Opcional: políticas del módulo 01 de Omar para comprobar la propagación a Partida.
-- Cada caso se revierte; ROLLBACK final elimina fixture, funciones y tablas temporales.
\set ON_ERROR_STOP on
BEGIN;
SELECT version();
DO $$
DECLARE r record; n bigint;
BEGIN
  IF current_setting('server_version_num')::int < 180000 THEN
    RAISE EXCEPTION 'Estas pruebas de catálogo requieren PostgreSQL 18 o posterior';
  END IF;
  IF (SELECT count(*) FROM pg_class WHERE relnamespace='public'::regnamespace AND relkind='r') <> 30 THEN
    RAISE EXCEPTION 'Se requiere el DDL completo de 30 tablas, sin tablas adicionales en public';
  END IF;
  FOR r IN SELECT relname FROM pg_class
    WHERE relnamespace='public'::regnamespace AND relkind='r'
  LOOP
    EXECUTE format('SELECT count(*) FROM public.%I', r.relname) INTO n;
    IF n <> 0 THEN RAISE EXCEPTION 'La base debe estar vacía: % tiene filas',r.relname; END IF;
  END LOOP;
END $$;

CREATE TEMP TABLE resultados(caso text PRIMARY KEY, resultado text);
CREATE FUNCTION pg_temp.probar(caso text, operacion text, verificacion text,
                              error_constraint text DEFAULT NULL)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE correcto boolean; restriccion text;
BEGIN
  BEGIN
    EXECUTE operacion;
    IF error_constraint IS NOT NULL THEN
      RAISE EXCEPTION 'No ocurrió el rechazo esperado de %', error_constraint;
    END IF;
    EXECUTE verificacion INTO correcto;
    IF correcto IS DISTINCT FROM TRUE THEN RAISE EXCEPTION 'Estado final incorrecto: %',caso; END IF;
    RAISE SQLSTATE 'Z0001'; -- Deshacer solo el caso exitoso.
  EXCEPTION
    WHEN SQLSTATE 'Z0001' THEN NULL;
    WHEN foreign_key_violation OR restrict_violation THEN
      GET STACKED DIAGNOSTICS restriccion = CONSTRAINT_NAME;
      IF error_constraint IS NULL OR restriccion <> error_constraint THEN RAISE; END IF;
      EXECUTE verificacion INTO correcto;
      IF correcto IS DISTINCT FROM TRUE THEN RAISE EXCEPTION 'Estado alterado tras rechazo: %',caso; END IF;
  END;
  INSERT INTO resultados VALUES(caso,'OK');
END $$;

INSERT INTO "SUCURSAL" VALUES
 (6201,'Sucursal principal','5512345678','Calle prueba',1,0,'Centro','CDMX'),
 (6202,'Solo máquinas','5512345678','Calle prueba',2,0,'Centro','CDMX'),
 (6203,'Solo técnico','5512345678','Calle prueba',3,0,'Centro','CDMX'),
 (6204,'Partida y cajero','5512345678','Calle prueba',4,0,'Centro','CDMX');
INSERT INTO "tipoDeJuego" VALUES
 (6201,'Sumar puntos','Activa','Tipo principal'),
 (6202,'Sumar puntos','Activa','Tipo secundario'),
 (6203,'Sumar puntos','Activa','Solo juego');
INSERT INTO "Juego" VALUES
 (6201,10,'Juego principal',6201), (6202,10,'Juego secundario',6202),
 (6203,10,'Sin máquinas',6203);
INSERT INTO "Máquina" VALUES
 (6201,'Activa',6201,6201), (6202,'Activa',6202,6201),
 (6203,'Activa',6202,6202), (6204,'Activa',6201,6204);
INSERT INTO "Técnico" VALUES
 ('AAAA000101HDFBBB01',6201,'Contactos','Materno','Paterno','AAAA000101AB1','2020-01-01',1000,'2000-01-01','Electrónica'),
 ('BBBB000101HDFBBB01',6201,'Historial','Materno','Paterno','BBBB000101AB1','2020-01-01',1000,'2000-01-01','Electrónica'),
 ('CCCC000101HDFBBB01',6203,'Asignación','Materno','Paterno','CCCC000101AB1','2020-01-01',1000,'2000-01-01','Electrónica');
INSERT INTO "CorreoElectrónicoTécnico" VALUES ('AAAA000101HDFBBB01','tecnico@example.test');
INSERT INTO "TeléfonoTécnivo" VALUES ('AAAA000101HDFBBB01','5512345678');
INSERT INTO "Certificaciones" VALUES ('AAAA000101HDFBBB01','Electrónica básica');
INSERT INTO "Mantenimiento" VALUES (6201,6201,'2026-01-01','Revisión de prueba','Preventivo','BBBB000101HDFBBB01');
INSERT INTO "Cajero" VALUES ('DDDD000101HDFBBB01',6204,'Prueba','Materno','Paterno','DDDD000101AB1','2020-01-01',1000,'2000-01-01','07:00');
INSERT INTO "Cliente" VALUES (6201,'2000-01-01','Prueba','Materno','Paterno','H');
INSERT INTO "Tarjeta" VALUES (6201,6201,'DDDD000101HDFBBB01',10,'2026-01-01',100,'Activa',50);
INSERT INTO "Partida" VALUES (6201,6201,6204,6201,'2026-01-01',10,'12:00:00-06',100);

-- Por cada FK: DELETE del padre, UPDATE de su clave, INSERT huérfano y UPDATE huérfano.

SELECT pg_temp.probar('fk_correo_tecnico: DELETE CASCADE',
 $q$DELETE FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_correo_tecnico: UPDATE CASCADE',
 $q$UPDATE "Técnico" SET "CURP"='AAAA000101HDFBBB02' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_correo_tecnico: INSERT huérfano',
 $q$INSERT INTO "CorreoElectrónicoTécnico" ("CURP", "correoTécnico") SELECT 'ZZZZ000101HDFBBB99', "correoTécnico" FROM "CorreoElectrónicoTécnico" WHERE "CURP"='AAAA000101HDFBBB01' LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_correo_tecnico');

SELECT pg_temp.probar('fk_correo_tecnico: UPDATE huérfano',
 $q$UPDATE "CorreoElectrónicoTécnico" SET "CURP"='ZZZZ000101HDFBBB99' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_correo_tecnico');

SELECT pg_temp.probar('fk_telefono_tecnico: DELETE CASCADE',
 $q$DELETE FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_telefono_tecnico: UPDATE CASCADE',
 $q$UPDATE "Técnico" SET "CURP"='AAAA000101HDFBBB02' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_telefono_tecnico: INSERT huérfano',
 $q$INSERT INTO "TeléfonoTécnivo" ("CURP", "telefonoTécnico") SELECT 'ZZZZ000101HDFBBB99', "telefonoTécnico" FROM "TeléfonoTécnivo" WHERE "CURP"='AAAA000101HDFBBB01' LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_telefono_tecnico');

SELECT pg_temp.probar('fk_telefono_tecnico: UPDATE huérfano',
 $q$UPDATE "TeléfonoTécnivo" SET "CURP"='ZZZZ000101HDFBBB99' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_telefono_tecnico');

SELECT pg_temp.probar('fk_mantenimiento_maquina: DELETE NO ACTION',
 $q$DELETE FROM "Máquina" WHERE "idMaquina"=6201$q$,
 $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6201) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201)$q$, 'fk_mantenimiento_maquina');

SELECT pg_temp.probar('fk_mantenimiento_maquina: UPDATE CASCADE',
 $q$UPDATE "Máquina" SET "idMaquina"=6301 WHERE "idMaquina"=6201$q$,
 $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6301) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6201) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6301) AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201)$q$);

SELECT pg_temp.probar('fk_mantenimiento_maquina: INSERT huérfano',
 $q$INSERT INTO "Mantenimiento" ("idMaquina", "idMantenimiento", "fecha", "descripcionProblema", "tipoMantenimiento", "CURP") SELECT 6299, "idMantenimiento", "fecha", "descripcionProblema", "tipoMantenimiento", "CURP" FROM "Mantenimiento" WHERE "idMaquina"=6201 LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6201) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201) AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6299)$q$, 'fk_mantenimiento_maquina');

SELECT pg_temp.probar('fk_mantenimiento_maquina: UPDATE huérfano',
 $q$UPDATE "Mantenimiento" SET "idMaquina"=6299 WHERE "idMaquina"=6201$q$,
 $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6201) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201) AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6299)$q$, 'fk_mantenimiento_maquina');

SELECT pg_temp.probar('fk_mantenimiento_tecnico: DELETE NO ACTION',
 $q$DELETE FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01')$q$, 'fk_mantenimiento_tecnico');

SELECT pg_temp.probar('fk_mantenimiento_tecnico: UPDATE CASCADE',
 $q$UPDATE "Técnico" SET "CURP"='BBBB000101HDFBBB02' WHERE "CURP"='BBBB000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_mantenimiento_tecnico: INSERT huérfano',
 $q$INSERT INTO "Mantenimiento" ("idMaquina", "idMantenimiento", "fecha", "descripcionProblema", "tipoMantenimiento", "CURP") SELECT "idMaquina", 6298, "fecha", "descripcionProblema", "tipoMantenimiento", 'ZZZZ000101HDFBBB99' FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01' LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_mantenimiento_tecnico');

SELECT pg_temp.probar('fk_mantenimiento_tecnico: UPDATE huérfano',
 $q$UPDATE "Mantenimiento" SET "CURP"='ZZZZ000101HDFBBB99' WHERE "CURP"='BBBB000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_mantenimiento_tecnico');

SELECT pg_temp.probar('fk_maquina_juego: DELETE NO ACTION',
 $q$DELETE FROM "Juego" WHERE "idJuego"=6202$q$,
 $q$SELECT EXISTS(SELECT FROM "Juego" WHERE "idJuego"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6202)$q$, 'fk_maquina_juego');

SELECT pg_temp.probar('fk_maquina_juego: UPDATE CASCADE',
 $q$UPDATE "Juego" SET "idJuego"=6302 WHERE "idJuego"=6202$q$,
 $q$SELECT EXISTS(SELECT FROM "Juego" WHERE "idJuego"=6302) AND NOT EXISTS(SELECT FROM "Juego" WHERE "idJuego"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6302) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6202)$q$);

SELECT pg_temp.probar('fk_maquina_juego: INSERT huérfano',
 $q$INSERT INTO "Máquina" ("idMaquina", "estado", "idJuego", "idSucursal") SELECT 6298, "estado", 6299, "idSucursal" FROM "Máquina" WHERE "idJuego"=6202 LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "Juego" WHERE "idJuego"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6202) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6299)$q$, 'fk_maquina_juego');

SELECT pg_temp.probar('fk_maquina_juego: UPDATE huérfano',
 $q$UPDATE "Máquina" SET "idJuego"=6299 WHERE "idJuego"=6202$q$,
 $q$SELECT EXISTS(SELECT FROM "Juego" WHERE "idJuego"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6202) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6299)$q$, 'fk_maquina_juego');

SELECT pg_temp.probar('fk_maquina_sucursal: DELETE NO ACTION',
 $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6202$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6202)$q$, 'fk_maquina_sucursal');

SELECT pg_temp.probar('fk_maquina_sucursal: UPDATE CASCADE',
 $q$UPDATE "SUCURSAL" SET "idSucursal"=6302 WHERE "idSucursal"=6202$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6302) AND NOT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6302) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6202)$q$);

SELECT pg_temp.probar('fk_maquina_sucursal: INSERT huérfano',
 $q$INSERT INTO "Máquina" ("idMaquina", "estado", "idJuego", "idSucursal") SELECT 6298, "estado", "idJuego", 6299 FROM "Máquina" WHERE "idSucursal"=6202 LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6202) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6299)$q$, 'fk_maquina_sucursal');

SELECT pg_temp.probar('fk_maquina_sucursal: UPDATE huérfano',
 $q$UPDATE "Máquina" SET "idSucursal"=6299 WHERE "idSucursal"=6202$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6202) AND EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6202) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idSucursal"=6299)$q$, 'fk_maquina_sucursal');

SELECT pg_temp.probar('fk_juego_tipo: DELETE NO ACTION',
 $q$DELETE FROM "tipoDeJuego" WHERE "idTipo"=6203$q$,
 $q$SELECT EXISTS(SELECT FROM "tipoDeJuego" WHERE "idTipo"=6203) AND EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6203)$q$, 'fk_juego_tipo');

SELECT pg_temp.probar('fk_juego_tipo: UPDATE CASCADE',
 $q$UPDATE "tipoDeJuego" SET "idTipo"=6303 WHERE "idTipo"=6203$q$,
 $q$SELECT EXISTS(SELECT FROM "tipoDeJuego" WHERE "idTipo"=6303) AND NOT EXISTS(SELECT FROM "tipoDeJuego" WHERE "idTipo"=6203) AND EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6303) AND NOT EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6203)$q$);

SELECT pg_temp.probar('fk_juego_tipo: INSERT huérfano',
 $q$INSERT INTO "Juego" ("idJuego", "costo", "nombre", "idTipo") SELECT 6298, "costo", "nombre", 6299 FROM "Juego" WHERE "idTipo"=6203 LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "tipoDeJuego" WHERE "idTipo"=6203) AND EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6203) AND NOT EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6299)$q$, 'fk_juego_tipo');

SELECT pg_temp.probar('fk_juego_tipo: UPDATE huérfano',
 $q$UPDATE "Juego" SET "idTipo"=6299 WHERE "idTipo"=6203$q$,
 $q$SELECT EXISTS(SELECT FROM "tipoDeJuego" WHERE "idTipo"=6203) AND EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6203) AND NOT EXISTS(SELECT FROM "Juego" WHERE "idTipo"=6299)$q$, 'fk_juego_tipo');

SELECT pg_temp.probar('fk_tecnico_sucursal: DELETE NO ACTION',
 $q$DELETE FROM "SUCURSAL" WHERE "idSucursal"=6203$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6203) AND EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6203)$q$, 'fk_tecnico_sucursal');

SELECT pg_temp.probar('fk_tecnico_sucursal: UPDATE CASCADE',
 $q$UPDATE "SUCURSAL" SET "idSucursal"=6303 WHERE "idSucursal"=6203$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6303) AND NOT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6203) AND EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6303) AND NOT EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6203)$q$);

SELECT pg_temp.probar('fk_tecnico_sucursal: INSERT huérfano',
 $q$INSERT INTO "Técnico" ("CURP", "idSucursal", "Nombre", "ApellidoMaterno", "ApellidoPaterno", "RFC", "fechaContratación", "salario", "fechaNacimiento", "áreaEspecialidad") SELECT 'YYYY000101HDFBBB98', 6299, "Nombre", "ApellidoMaterno", "ApellidoPaterno", "RFC", "fechaContratación", "salario", "fechaNacimiento", "áreaEspecialidad" FROM "Técnico" WHERE "idSucursal"=6203 LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6203) AND EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6203) AND NOT EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6299)$q$, 'fk_tecnico_sucursal');

SELECT pg_temp.probar('fk_tecnico_sucursal: UPDATE huérfano',
 $q$UPDATE "Técnico" SET "idSucursal"=6299 WHERE "idSucursal"=6203$q$,
 $q$SELECT EXISTS(SELECT FROM "SUCURSAL" WHERE "idSucursal"=6203) AND EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6203) AND NOT EXISTS(SELECT FROM "Técnico" WHERE "idSucursal"=6299)$q$, 'fk_tecnico_sucursal');

SELECT pg_temp.probar('fk_certificacion_tecnico: DELETE CASCADE',
 $q$DELETE FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_certificacion_tecnico: UPDATE CASCADE',
 $q$UPDATE "Técnico" SET "CURP"='AAAA000101HDFBBB02' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='AAAA000101HDFBBB02') AND NOT EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='AAAA000101HDFBBB01')$q$);

SELECT pg_temp.probar('fk_certificacion_tecnico: INSERT huérfano',
 $q$INSERT INTO "Certificaciones" ("CURP", "Certificaciones") SELECT 'ZZZZ000101HDFBBB99', "Certificaciones" FROM "Certificaciones" WHERE "CURP"='AAAA000101HDFBBB01' LIMIT 1$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_certificacion_tecnico');

SELECT pg_temp.probar('fk_certificacion_tecnico: UPDATE huérfano',
 $q$UPDATE "Certificaciones" SET "CURP"='ZZZZ000101HDFBBB99' WHERE "CURP"='AAAA000101HDFBBB01'$q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='AAAA000101HDFBBB01') AND EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='AAAA000101HDFBBB01') AND NOT EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='ZZZZ000101HDFBBB99')$q$, 'fk_certificacion_tecnico');

SELECT pg_temp.probar('Cadena tipo-juego-máquina-mantenimiento: corregir tipo',
 $q$UPDATE "tipoDeJuego" SET "idTipo"=6301 WHERE "idTipo"=6201$q$,
 $q$SELECT EXISTS(SELECT FROM "Juego" WHERE "idJuego"=6201 AND "idTipo"=6301) AND EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6201 AND "idJuego"=6201) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201)$q$);

SELECT pg_temp.probar('Cadena tipo-juego-máquina-mantenimiento: corregir juego',
 $q$UPDATE "Juego" SET "idJuego"=6301 WHERE "idJuego"=6201$q$,
 $q$SELECT (SELECT count(*)=2 FROM "Máquina" WHERE "idJuego"=6301) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idJuego"=6201) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201)$q$);

SELECT pg_temp.probar('Cadena: corregir máquina actualiza PK del mantenimiento',
 $q$UPDATE "Máquina" SET "idMaquina"=6301 WHERE "idMaquina"=6201$q$,
 $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6301) AND EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6301 AND "idMantenimiento"=6201) AND NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201)$q$);

SELECT pg_temp.probar('Técnico con historial: bloqueo revierte contactos y certificaciones',
 $q$INSERT INTO "CorreoElectrónicoTécnico" VALUES ('BBBB000101HDFBBB01','historial@example.test');
 INSERT INTO "TeléfonoTécnivo" VALUES ('BBBB000101HDFBBB01','5599999999');
 INSERT INTO "Certificaciones" VALUES ('BBBB000101HDFBBB01','Seguridad');
 DELETE FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01' $q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01') AND NOT EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='BBBB000101HDFBBB01')$q$, 'fk_mantenimiento_tecnico');

SAVEPOINT contactos_historial;
INSERT INTO "CorreoElectrónicoTécnico" VALUES ('BBBB000101HDFBBB01','historial@example.test');
INSERT INTO "TeléfonoTécnivo" VALUES ('BBBB000101HDFBBB01','5599999999');
INSERT INTO "Certificaciones" VALUES ('BBBB000101HDFBBB01','Seguridad');

SELECT pg_temp.probar('Técnico con historial: conserva los tres dependientes preexistentes',
 $q$DELETE FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01' $q$,
 $q$SELECT EXISTS(SELECT FROM "Técnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Mantenimiento" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "CorreoElectrónicoTécnico" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "TeléfonoTécnivo" WHERE "CURP"='BBBB000101HDFBBB01') AND EXISTS(SELECT FROM "Certificaciones" WHERE "CURP"='BBBB000101HDFBBB01')$q$, 'fk_mantenimiento_tecnico');

DELETE FROM "CorreoElectrónicoTécnico" WHERE "CURP"='BBBB000101HDFBBB01';
DELETE FROM "TeléfonoTécnivo" WHERE "CURP"='BBBB000101HDFBBB01';
DELETE FROM "Certificaciones" WHERE "CURP"='BBBB000101HDFBBB01';
RELEASE SAVEPOINT contactos_historial;

SELECT pg_temp.probar('Partida de Omar: protege el borrado de una máquina',
 $q$DELETE FROM "Máquina" WHERE "idMaquina"=6204$q$,
 $q$SELECT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6204) AND EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6204)$q$, 'fk_partida_maquina');

-- El propietario de Partida define la propagación: probar ambos estados sin cambiar su FK.
DO $$
DECLARE accion "char";
BEGIN
 SELECT confupdtype INTO accion FROM pg_constraint
 WHERE conrelid='"Partida"'::regclass AND conname='fk_partida_maquina';
 IF accion='c' THEN
   PERFORM pg_temp.probar('Partida de Omar: UPDATE CASCADE integrado',
     'UPDATE "Máquina" SET "idMaquina"=6304 WHERE "idMaquina"=6204',
     'SELECT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6304) AND NOT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6204) AND EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6304)');
 ELSIF accion='a' THEN
   PERFORM pg_temp.probar('Partida base: UPDATE bloqueado sin políticas de Omar',
     'UPDATE "Máquina" SET "idMaquina"=6304 WHERE "idMaquina"=6204',
     'SELECT EXISTS(SELECT FROM "Partida" WHERE "idMaquina"=6204) AND EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6204) AND NOT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6304)', 'fk_partida_maquina');
 ELSE RAISE EXCEPTION 'Política inesperada en Partida: %',accion;
 END IF;
END $$;

-- Ejemplo didáctico: cadena con CASCADE para ambas operaciones, fuera de public.
CREATE TEMP TABLE tipo_demo(id integer PRIMARY KEY);
CREATE TEMP TABLE juego_demo(id integer PRIMARY KEY, tipo integer NOT NULL,
 FOREIGN KEY(tipo) REFERENCES tipo_demo(id) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TEMP TABLE maquina_demo(id integer PRIMARY KEY, juego integer NOT NULL,
 FOREIGN KEY(juego) REFERENCES juego_demo(id) ON DELETE CASCADE ON UPDATE CASCADE);
CREATE TEMP TABLE mantenimiento_demo(id integer PRIMARY KEY, maquina integer NOT NULL,
 FOREIGN KEY(maquina) REFERENCES maquina_demo(id) ON DELETE CASCADE ON UPDATE CASCADE);
INSERT INTO tipo_demo VALUES(1);
INSERT INTO juego_demo VALUES(10,1);
INSERT INTO maquina_demo VALUES(100,10);
INSERT INTO mantenimiento_demo VALUES(1000,100);

SELECT pg_temp.probar('CASCADE didáctico: DELETE recorre tres niveles',
 $q$DELETE FROM tipo_demo WHERE id=1$q$,
 $q$SELECT NOT EXISTS(SELECT FROM tipo_demo) AND NOT EXISTS(SELECT FROM juego_demo) AND NOT EXISTS(SELECT FROM maquina_demo) AND NOT EXISTS(SELECT FROM mantenimiento_demo)$q$);

SELECT pg_temp.probar('CASCADE didáctico: UPDATE cambia la referencia, no la PK independiente',
 $q$UPDATE tipo_demo SET id=2 WHERE id=1$q$,
 $q$SELECT EXISTS(SELECT FROM tipo_demo WHERE id=2) AND EXISTS(SELECT FROM juego_demo WHERE id=10 AND tipo=2) AND EXISTS(SELECT FROM maquina_demo WHERE id=100 AND juego=10) AND EXISTS(SELECT FROM mantenimiento_demo WHERE maquina=100)$q$);

DO $$
DECLARE k text;
BEGIN
 BEGIN
   UPDATE "Máquina" SET "idMaquina"=6202 WHERE "idMaquina"=6201;
   RAISE EXCEPTION 'Se esperaba unique_violation';
 EXCEPTION WHEN unique_violation THEN
   GET STACKED DIAGNOSTICS k=CONSTRAINT_NAME;
   IF k<>'pk_maquina' THEN RAISE; END IF;
 END;
 IF NOT EXISTS(SELECT FROM "Máquina" WHERE "idMaquina"=6201)
    OR NOT EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6201)
    OR EXISTS(SELECT FROM "Mantenimiento" WHERE "idMaquina"=6202) THEN
   RAISE EXCEPTION 'La colisión de PK alteró el historial';
 END IF;
 INSERT INTO resultados VALUES('CASCADE no permite colisiones de PK','OK');
END $$;

SELECT pg_temp.probar('Comentarios: ocho tablas',
 $q$SELECT 1$q$,
 $q$SELECT count(*)=8 AND bool_and(nullif(obj_description(oid,'pg_class'),'') IS NOT NULL) FROM pg_class WHERE relnamespace='public'::regnamespace AND relname IN ('tipoDeJuego', 'Juego', 'Máquina', 'Mantenimiento', 'Técnico', 'Certificaciones', 'CorreoElectrónicoTécnico', 'TeléfonoTécnivo')$q$);

SELECT pg_temp.probar('Comentarios: 34 columnas obligatorias sin DEFAULT',
 $q$SELECT 1$q$,
 $q$SELECT count(*)=34 AND bool_and(nullif(col_description(c.oid,a.attnum),'') IS NOT NULL AND a.attnotnull AND NOT a.atthasdef) FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('tipoDeJuego', 'Juego', 'Máquina', 'Mantenimiento', 'Técnico', 'Certificaciones', 'CorreoElectrónicoTécnico', 'TeléfonoTécnivo') AND a.attnum>0 AND NOT a.attisdropped$q$);

SELECT pg_temp.probar('Comentarios: 83 restricciones incluidos 34 NOT NULL',
 $q$SELECT 1$q$,
 $q$SELECT count(*)=83 AND count(*) FILTER(WHERE k.contype='n')=34 AND bool_and(nullif(obj_description(k.oid,'pg_constraint'),'') IS NOT NULL) FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('tipoDeJuego', 'Juego', 'Máquina', 'Mantenimiento', 'Técnico', 'Certificaciones', 'CorreoElectrónicoTécnico', 'TeléfonoTécnivo')$q$);

SELECT pg_temp.probar('Políticas: nueve FK validadas y acciones acordadas',
 $q$SELECT 1$q$,
 $q$SELECT count(*)=9 AND bool_and(confupdtype='c' AND NOT condeferrable AND convalidated AND confdeltype=CASE WHEN k.conname IN ('fk_correo_tecnico','fk_telefono_tecnico','fk_certificacion_tecnico') THEN 'c'::char ELSE 'a'::char END) FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid WHERE c.relnamespace='public'::regnamespace AND c.relname IN ('tipoDeJuego', 'Juego', 'Máquina', 'Mantenimiento', 'Técnico', 'Certificaciones', 'CorreoElectrónicoTécnico', 'TeléfonoTécnivo') AND contype='f'$q$);

TABLE resultados;
SELECT count(*) AS casos_correctos FROM resultados WHERE resultado='OK';
DO $$ BEGIN
 IF (SELECT count(*) FROM resultados WHERE resultado='OK') <> 50 THEN
   RAISE EXCEPTION 'Deben aprobarse exactamente 50 casos';
 END IF;
END $$;
ROLLBACK;

-- Verificación posterior al ROLLBACK: no quedó ninguna fixture en las 30 tablas.
DO $$
DECLARE r record; n bigint;
BEGIN
 FOR r IN SELECT relname FROM pg_class WHERE relnamespace='public'::regnamespace AND relkind='r'
 LOOP
   EXECUTE format('SELECT count(*) FROM public.%I',r.relname) INTO n;
   IF n<>0 THEN RAISE EXCEPTION 'Quedaron datos en %',r.relname; END IF;
 END LOOP;
 RAISE NOTICE 'ROLLBACK verificado: las 30 tablas permanecen vacías.';
END $$;
