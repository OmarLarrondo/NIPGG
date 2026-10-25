-- Práctica 05 | Personal | Ejecutar con psql -X -v ON_ERROR_STOP=1.
-- Requiere DDL_disponible.sql en una base VACÍA. ROLLBACK elimina fixtures.
BEGIN;
CREATE TEMP TABLE resultados_personal (caso text, resultado text);
CREATE FUNCTION pg_temp.rechazar(caso text, sentencia text, estado text, restriccion text DEFAULT NULL)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE real_estado text; real_restriccion text;
BEGIN
    BEGIN
        EXECUTE sentencia;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS real_estado = RETURNED_SQLSTATE,
                                real_restriccion = CONSTRAINT_NAME;
        IF real_estado <> estado OR (restriccion IS NOT NULL AND real_restriccion <> restriccion) THEN
            RAISE EXCEPTION 'Caso %: se esperaba % / %, se obtuvo % / %',
                caso, estado, restriccion, real_estado, real_restriccion;
        END IF;
        INSERT INTO resultados_personal VALUES (caso, 'OK');
        RETURN;
    END;
    RAISE EXCEPTION 'Caso %: se aceptó un dato que debía rechazarse', caso;
END;
$$;
INSERT INTO "SUCURSAL" VALUES
 (920001,'Centro','5512345678','Calle Uno',1,0,'Centro','CDMX'),
 (920002,'Norte','5512345679','Calle Dos',2,0,'Norte','CDMX');
INSERT INTO "Genrente" VALUES
 ('AAAA900101HDFBBB01',920001,'Carlos','Pérez','López','AAAA900101AA1',DATE '2020-01-01',15000,DATE '1990-01-01','12345678');
INSERT INTO "Cajero" VALUES
 ('BBBB900101HDFCCC02',920001,'Ana','Pérez','López','BBBB900101AA1',DATE '2020-01-01',9000,DATE '1990-01-01',TIME '07:00');
INSERT INTO "Encargado de premios" VALUES
 ('CCCC900101HDFDDD03',920002,'Luis','Pérez','López','CCCC900101AA1',DATE '2020-01-01',10000,DATE '1990-01-01',TIME '15:00');
INSERT INTO "Administrar" VALUES ('AAAA900101HDFBBB01',920001);
INSERT INTO resultados_personal VALUES ('Inserciones válidas en cuatro tablas','OK');
SELECT pg_temp.rechazar('Salario negativo', 'UPDATE "Genrente" SET "salario"=-1', '23514', 'ckgerentesalariononegativo');
SELECT pg_temp.rechazar('Horario no permitido', 'UPDATE "Cajero" SET "horarioTrabajo"=TIME ''10:00''', '23514', 'ckcajerohorariotrabajo');
SELECT pg_temp.rechazar('Sucursal ausente', 'UPDATE "Cajero" SET "idSucursal"=929999', '23503', 'fkcajerosucursal');
SELECT pg_temp.rechazar('CURP inválida', 'UPDATE "Encargado de premios" SET "CURP"=''invalida''', '23514', 'ckencargadopremioscurp');
SELECT pg_temp.rechazar('PK de asociación duplicada', 'INSERT INTO "Administrar" VALUES (''AAAA900101HDFBBB01'',920001)', '23505', 'pk_administrar');
SELECT pg_temp.rechazar('Gerente de asociación ausente', 'UPDATE "Administrar" SET "CURP"=''DDDD900101HDFEEE04''', '23503', 'fkadministrargerente');
SELECT count(*) AS casos_correctos FROM resultados_personal;
ROLLBACK;
