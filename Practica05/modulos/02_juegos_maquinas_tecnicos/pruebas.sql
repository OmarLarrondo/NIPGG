-- Módulo 02: pruebas aisladas con dependencias mínimas, siempre ROLLBACK.
\set ON_ERROR_STOP on
BEGIN;
CREATE SCHEMA prueba_juegos_02;
SET LOCAL search_path TO prueba_juegos_02,pg_temp;
CREATE TABLE "SUCURSAL" ("idSucursal" integer PRIMARY KEY);
INSERT INTO "SUCURSAL" VALUES (1);
\ir tablas.sql
\ir dominios.sql
\ir claves.sql
\ir referencias.sql
CREATE TEMP TABLE resultados (caso text, estado text);
CREATE FUNCTION pg_temp.rechazar(caso text, sentencia text, esperado text) RETURNS void
LANGUAGE plpgsql AS $$
DECLARE observado text;
BEGIN
 BEGIN EXECUTE sentencia;
 EXCEPTION WHEN OTHERS THEN
  GET STACKED DIAGNOSTICS observado = RETURNED_SQLSTATE;
  IF observado <> esperado THEN RAISE EXCEPTION 'FALLO %: esperado %, obtenido %', caso, esperado, observado; END IF;
  INSERT INTO resultados VALUES (caso, observado); RETURN;
 END;
 RAISE EXCEPTION 'FALLO %: se aceptó una operación inválida', caso;
END; $$;
INSERT INTO "tipoDeJuego" ("idTipo", "reglaPuntuacion", "condicion", "nombre") VALUES (1, 'Valor válido', 'Valor válido', 'Valor válido');
INSERT INTO "Juego" ("idJuego", "costo", "nombre", "idTipo") VALUES (1, 1, 'Valor válido', 1);
INSERT INTO "Máquina" ("idMaquina", "estado", "idJuego", "idSucursal") VALUES (1, 'Valor válido', 1, 1);
INSERT INTO "Técnico" ("CURP", "idSucursal", "Nombre", "ApellidoMaterno", "ApellidoPaterno", "RFC", "fechaContratación", "salario", "fechaNacimiento", "áreaEspecialidad") VALUES ('TTTT000101HDFBBB01', 1, 'Valor válido', 'Valor válido', 'Valor válido', 'ABCD000101A01', '2000-01-01', 10000.00, '2000-01-01', 'Valor válido');
INSERT INTO "Mantenimiento" ("idMaquina", "idMantenimiento", "fecha", "descripcionProblema", "tipoMantenimiento", "CURP") VALUES (1, 1, '2000-01-01', 'Valor válido', 'Valor válido', 'TTTT000101HDFBBB01');
INSERT INTO "Certificaciones" ("CURP", "Certificaciones") VALUES ('TTTT000101HDFBBB01', 'Valor válido');
SELECT pg_temp.rechazar('PK duplicada tipoDeJuego', 'INSERT INTO "tipoDeJuego" SELECT * FROM "tipoDeJuego"', '23505');
SELECT pg_temp.rechazar('NULL tipoDeJuego.idTipo', 'UPDATE "tipoDeJuego" SET "idTipo" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio tipoDeJuego.idTipo', 'UPDATE "tipoDeJuego" SET "idTipo" = -1', '23514');
SELECT pg_temp.rechazar('NULL tipoDeJuego.reglaPuntuacion', 'UPDATE "tipoDeJuego" SET "reglaPuntuacion" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio tipoDeJuego.reglaPuntuacion', 'UPDATE "tipoDeJuego" SET "reglaPuntuacion" = ''''', '23514');
SELECT pg_temp.rechazar('NULL tipoDeJuego.condicion', 'UPDATE "tipoDeJuego" SET "condicion" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio tipoDeJuego.condicion', 'UPDATE "tipoDeJuego" SET "condicion" = ''''', '23514');
SELECT pg_temp.rechazar('NULL tipoDeJuego.nombre', 'UPDATE "tipoDeJuego" SET "nombre" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio tipoDeJuego.nombre', 'UPDATE "tipoDeJuego" SET "nombre" = ''''', '23514');
SELECT pg_temp.rechazar('PK duplicada Juego', 'INSERT INTO "Juego" SELECT * FROM "Juego"', '23505');
SELECT pg_temp.rechazar('NULL Juego.idJuego', 'UPDATE "Juego" SET "idJuego" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Juego.idJuego', 'UPDATE "Juego" SET "idJuego" = -1', '23514');
SELECT pg_temp.rechazar('NULL Juego.costo', 'UPDATE "Juego" SET "costo" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Juego.costo', 'UPDATE "Juego" SET "costo" = -1', '23514');
SELECT pg_temp.rechazar('NULL Juego.nombre', 'UPDATE "Juego" SET "nombre" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Juego.nombre', 'UPDATE "Juego" SET "nombre" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Juego.idTipo', 'UPDATE "Juego" SET "idTipo" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Juego.idTipo', 'UPDATE "Juego" SET "idTipo" = -1', '23514');
SELECT pg_temp.rechazar('PK duplicada Máquina', 'INSERT INTO "Máquina" SELECT * FROM "Máquina"', '23505');
SELECT pg_temp.rechazar('NULL Máquina.idMaquina', 'UPDATE "Máquina" SET "idMaquina" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Máquina.idMaquina', 'UPDATE "Máquina" SET "idMaquina" = -1', '23514');
SELECT pg_temp.rechazar('NULL Máquina.estado', 'UPDATE "Máquina" SET "estado" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Máquina.estado', 'UPDATE "Máquina" SET "estado" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Máquina.idJuego', 'UPDATE "Máquina" SET "idJuego" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Máquina.idJuego', 'UPDATE "Máquina" SET "idJuego" = -1', '23514');
SELECT pg_temp.rechazar('NULL Máquina.idSucursal', 'UPDATE "Máquina" SET "idSucursal" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Máquina.idSucursal', 'UPDATE "Máquina" SET "idSucursal" = -1', '23514');
SELECT pg_temp.rechazar('PK duplicada Técnico', 'INSERT INTO "Técnico" SELECT * FROM "Técnico"', '23505');
SELECT pg_temp.rechazar('NULL Técnico.CURP', 'UPDATE "Técnico" SET "CURP" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.CURP', 'UPDATE "Técnico" SET "CURP" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.idSucursal', 'UPDATE "Técnico" SET "idSucursal" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.idSucursal', 'UPDATE "Técnico" SET "idSucursal" = -1', '23514');
SELECT pg_temp.rechazar('NULL Técnico.Nombre', 'UPDATE "Técnico" SET "Nombre" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.Nombre', 'UPDATE "Técnico" SET "Nombre" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.ApellidoMaterno', 'UPDATE "Técnico" SET "ApellidoMaterno" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.ApellidoMaterno', 'UPDATE "Técnico" SET "ApellidoMaterno" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.ApellidoPaterno', 'UPDATE "Técnico" SET "ApellidoPaterno" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.ApellidoPaterno', 'UPDATE "Técnico" SET "ApellidoPaterno" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.RFC', 'UPDATE "Técnico" SET "RFC" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.RFC', 'UPDATE "Técnico" SET "RFC" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.fechaContratación', 'UPDATE "Técnico" SET "fechaContratación" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.fechaContratación', 'UPDATE "Técnico" SET "fechaContratación" = ''infinity''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.salario', 'UPDATE "Técnico" SET "salario" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.salario', 'UPDATE "Técnico" SET "salario" = -1', '23514');
SELECT pg_temp.rechazar('NULL Técnico.fechaNacimiento', 'UPDATE "Técnico" SET "fechaNacimiento" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.fechaNacimiento', 'UPDATE "Técnico" SET "fechaNacimiento" = ''infinity''', '23514');
SELECT pg_temp.rechazar('NULL Técnico.áreaEspecialidad', 'UPDATE "Técnico" SET "áreaEspecialidad" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Técnico.áreaEspecialidad', 'UPDATE "Técnico" SET "áreaEspecialidad" = ''''', '23514');
SELECT pg_temp.rechazar('Salario NaN Técnico', 'UPDATE "Técnico" SET "salario" = ''NaN''', '23514');
SELECT pg_temp.rechazar('PK duplicada Mantenimiento', 'INSERT INTO "Mantenimiento" SELECT * FROM "Mantenimiento"', '23505');
SELECT pg_temp.rechazar('NULL Mantenimiento.idMaquina', 'UPDATE "Mantenimiento" SET "idMaquina" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Mantenimiento.idMaquina', 'UPDATE "Mantenimiento" SET "idMaquina" = -1', '23514');
SELECT pg_temp.rechazar('NULL Mantenimiento.idMantenimiento', 'UPDATE "Mantenimiento" SET "idMantenimiento" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Mantenimiento.idMantenimiento', 'UPDATE "Mantenimiento" SET "idMantenimiento" = -1', '23514');
SELECT pg_temp.rechazar('NULL Mantenimiento.fecha', 'UPDATE "Mantenimiento" SET "fecha" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Mantenimiento.fecha', 'UPDATE "Mantenimiento" SET "fecha" = ''infinity''', '23514');
SELECT pg_temp.rechazar('NULL Mantenimiento.descripcionProblema', 'UPDATE "Mantenimiento" SET "descripcionProblema" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Mantenimiento.descripcionProblema', 'UPDATE "Mantenimiento" SET "descripcionProblema" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Mantenimiento.tipoMantenimiento', 'UPDATE "Mantenimiento" SET "tipoMantenimiento" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Mantenimiento.tipoMantenimiento', 'UPDATE "Mantenimiento" SET "tipoMantenimiento" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Mantenimiento.CURP', 'UPDATE "Mantenimiento" SET "CURP" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Mantenimiento.CURP', 'UPDATE "Mantenimiento" SET "CURP" = ''''', '23514');
SELECT pg_temp.rechazar('PK duplicada Certificaciones', 'INSERT INTO "Certificaciones" SELECT * FROM "Certificaciones"', '23505');
SELECT pg_temp.rechazar('NULL Certificaciones.CURP', 'UPDATE "Certificaciones" SET "CURP" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Certificaciones.CURP', 'UPDATE "Certificaciones" SET "CURP" = ''''', '23514');
SELECT pg_temp.rechazar('NULL Certificaciones.Certificaciones', 'UPDATE "Certificaciones" SET "Certificaciones" = NULL', '23502');
SELECT pg_temp.rechazar('Dominio Certificaciones.Certificaciones', 'UPDATE "Certificaciones" SET "Certificaciones" = ''''', '23514');
DO $$ DECLARE c record; a record; v text;
BEGIN
 FOR c IN SELECT conname, conrelid, conkey FROM pg_constraint
  WHERE contype='f' AND connamespace=current_schema()::regnamespace
 LOOP
  SELECT attname, atttypid INTO a FROM pg_attribute WHERE attrelid=c.conrelid AND attnum=c.conkey[1];
  v := CASE WHEN a.atttypid='integer'::regtype THEN '999999' ELSE quote_literal('ZZZZ000101HDFBBB99') END;
  PERFORM pg_temp.rechazar('FK '||c.conname, format('UPDATE %s SET %I = %s',c.conrelid::regclass,a.attname,v), '23503');
 END LOOP;
END; $$;
-- The same maintenance number may recur on a different machine (composite PK).
INSERT INTO "Máquina" VALUES (2,'Operativa',1,1);
INSERT INTO "Mantenimiento" VALUES (2,1,'2000-01-01','Revisión','Preventivo','TTTT000101HDFBBB01');

SELECT count(*) AS rechazos_correctos FROM resultados;
ROLLBACK;
