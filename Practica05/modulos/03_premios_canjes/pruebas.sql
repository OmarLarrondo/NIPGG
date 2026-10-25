-- Práctica 05 | Omar | Ejecutar con psql -X -v ON_ERROR_STOP=1.
-- Requiere DDL_disponible.sql en una base VACÍA. ROLLBACK elimina fixtures.
BEGIN;
CREATE TEMP TABLE resultados_omar (caso text, resultado text);
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
        INSERT INTO resultados_omar VALUES (caso, 'OK');
        RETURN;
    END;
    RAISE EXCEPTION 'Caso %: se aceptó un dato que debía rechazarse', caso;
END;
$$;
INSERT INTO "SUCURSAL" VALUES
 (910001,'Centro','5512345678','Calle Uno',1,0,'Centro','CDMX'),
 (910002,'Norte','5512345679','Calle Dos',2,0,'Norte','CDMX');
INSERT INTO "Cliente" VALUES
 (910001,DATE '2000-01-01','Omar','Larrondo','Juárez','H'),
 (910002,DATE '2000-01-02','Ana','Pérez','López','M');
INSERT INTO "Encargado de premios" VALUES
 ('AAAA900101HDFBBB01',910001,'Luis','Pérez','López','AAAA900101AA1',DATE '2020-01-01',10000,DATE '1990-01-01',TIME '07:00');
INSERT INTO "Premio" VALUES
 (910001,0,1,'Pelota','Juguetes','Todas las edades'),
 (910002,100,10,'Peluche','Juguetes','6 años o más');
INSERT INTO "Disponer" VALUES (910001,910001,0),(910002,910001,5),(910001,910002,2);
INSERT INTO "Canje" VALUES
 (910001,910001,910001,910002,'AAAA900101HDFBBB01',TIME '12:30',10,1,DATE '2026-10-25'),
 (910002,910001,910001,910002,'AAAA900101HDFBBB01',TIME '12:30',20,2,DATE '2026-10-25');
INSERT INTO resultados_omar VALUES
 ('Datos válidos en las tres tablas','OK'),
 ('Cero en valor aproximado e inventario','OK'),
 ('Mismo premio en dos sucursales; dos premios en una sucursal','OK'),
 ('Dos canjes con iguales FK y distinto idCanje','OK');
SELECT pg_temp.rechazar('Premio.idPremio: NULL', 'INSERT INTO "Premio" VALUES (NULL, 0, 1, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23502');
SELECT pg_temp.rechazar('Premio.valorAproximado: NULL', 'INSERT INTO "Premio" VALUES (910003, NULL, 1, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23502');
SELECT pg_temp.rechazar('Premio.puntosNecesarios: NULL', 'INSERT INTO "Premio" VALUES (910003, 0, NULL, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23502');
SELECT pg_temp.rechazar('Premio.nombre: NULL', 'INSERT INTO "Premio" VALUES (910003, 0, 1, NULL, ''Juguetes'', ''Todas las edades'')', '23502');
SELECT pg_temp.rechazar('Premio.categoría: NULL', 'INSERT INTO "Premio" VALUES (910003, 0, 1, ''Pelota'', NULL, ''Todas las edades'')', '23502');
SELECT pg_temp.rechazar('Premio.rangoEdad: NULL', 'INSERT INTO "Premio" VALUES (910003, 0, 1, ''Pelota'', ''Juguetes'', NULL)', '23502');
SELECT pg_temp.rechazar('Canje.idCanje: NULL', 'INSERT INTO "Canje" VALUES (NULL, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.idSucursal: NULL', 'INSERT INTO "Canje" VALUES (910003, NULL, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.idCliente: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, NULL, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.idPremio: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, NULL, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.CURP: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, NULL, TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.hora: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', NULL, 10, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.puntosUtilizados: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', NULL, 1, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.cantidadPremios: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, NULL, DATE ''2026-10-25'')', '23502');
SELECT pg_temp.rechazar('Canje.fecha: NULL', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, NULL)', '23502');
SELECT pg_temp.rechazar('Disponer.idSucursal: NULL', 'INSERT INTO "Disponer" VALUES (NULL, 910002, 0)', '23502');
SELECT pg_temp.rechazar('Disponer.idPremio: NULL', 'INSERT INTO "Disponer" VALUES (910002, NULL, 0)', '23502');
SELECT pg_temp.rechazar('Disponer.cantidadDisponible: NULL', 'INSERT INTO "Disponer" VALUES (910002, 910002, NULL)', '23502');
SELECT pg_temp.rechazar('Premio.idPremio: 0', 'INSERT INTO "Premio" VALUES (0, 0, 1, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23514', 'ck_premio_id');
SELECT pg_temp.rechazar('Premio.valorAproximado: -1', 'INSERT INTO "Premio" VALUES (910003, -1, 1, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23514', 'ck_premio_valor');
SELECT pg_temp.rechazar('Premio.puntosNecesarios: 0', 'INSERT INTO "Premio" VALUES (910003, 0, 0, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23514', 'ck_premio_puntos');
SELECT pg_temp.rechazar('Premio.nombre: E'' \t\n''', 'INSERT INTO "Premio" VALUES (910003, 0, 1, E'' \t\n'', ''Juguetes'', ''Todas las edades'')', '23514', 'ck_premio_nombre');
SELECT pg_temp.rechazar('Premio.categoría: ''''', 'INSERT INTO "Premio" VALUES (910003, 0, 1, ''Pelota'', '''', ''Todas las edades'')', '23514', 'ck_premio_categoria');
SELECT pg_temp.rechazar('Premio.rangoEdad: ''  ''', 'INSERT INTO "Premio" VALUES (910003, 0, 1, ''Pelota'', ''Juguetes'', ''  '')', '23514', 'ck_premio_edad');
SELECT pg_temp.rechazar('Canje.idCanje: 0', 'INSERT INTO "Canje" VALUES (0, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23514', 'ck_canje_id');
SELECT pg_temp.rechazar('Canje.idSucursal: 0', 'INSERT INTO "Canje" VALUES (910003, 0, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23514', 'ck_canje_sucursal');
SELECT pg_temp.rechazar('Canje.idCliente: 0', 'INSERT INTO "Canje" VALUES (910003, 910001, 0, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23514', 'ck_canje_cliente');
SELECT pg_temp.rechazar('Canje.idPremio: 0', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 0, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23514', 'ck_canje_premio');
SELECT pg_temp.rechazar('Canje.CURP: ''incorrecta''', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''incorrecta'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23514', 'ck_canje_curp');
SELECT pg_temp.rechazar('Canje.puntosUtilizados: 0', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 0, 1, DATE ''2026-10-25'')', '23514', 'ck_canje_puntos');
SELECT pg_temp.rechazar('Canje.cantidadPremios: 0', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 0, DATE ''2026-10-25'')', '23514', 'ck_canje_cantidad');
SELECT pg_temp.rechazar('Canje.fecha: DATE ''infinity''', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''infinity'')', '23514', 'ck_canje_fecha');
SELECT pg_temp.rechazar('Canje.fecha: DATE ''-infinity''', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''-infinity'')', '23514', 'ck_canje_fecha');
SELECT pg_temp.rechazar('Disponer.idSucursal: 0', 'INSERT INTO "Disponer" VALUES (0, 910002, 0)', '23514', 'ck_disponer_sucursal');
SELECT pg_temp.rechazar('Disponer.idPremio: 0', 'INSERT INTO "Disponer" VALUES (910002, 0, 0)', '23514', 'ck_disponer_premio');
SELECT pg_temp.rechazar('Disponer.cantidadDisponible: -1', 'INSERT INTO "Disponer" VALUES (910002, 910002, -1)', '23514', 'ck_disponer_cantidad');
SELECT pg_temp.rechazar('Premio.nombre: longitud 51', 'INSERT INTO "Premio" VALUES (910003, 0, 1, repeat(''x'',51), ''Juguetes'', ''Todas las edades'')', '22001');
SELECT pg_temp.rechazar('Premio.categoría: longitud 51', 'INSERT INTO "Premio" VALUES (910003, 0, 1, ''Pelota'', repeat(''x'',51), ''Todas las edades'')', '22001');
SELECT pg_temp.rechazar('Premio.rangoEdad: longitud 51', 'INSERT INTO "Premio" VALUES (910003, 0, 1, ''Pelota'', ''Juguetes'', repeat(''x'',51))', '22001');
SELECT pg_temp.rechazar('Canje.hora: 25 horas', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''25:00'', 10, 1, DATE ''2026-10-25'')', '22008');
SELECT pg_temp.rechazar('Premio: PK duplicada', 'INSERT INTO "Premio" VALUES (910001, 0, 1, ''Pelota'', ''Juguetes'', ''Todas las edades'')', '23505', 'pk_premio');
SELECT pg_temp.rechazar('Canje: PK duplicada', 'INSERT INTO "Canje" VALUES (910001, 910001, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23505', 'pk_canje');
SELECT pg_temp.rechazar('Disponer: PK duplicada', 'INSERT INTO "Disponer" VALUES (910002, 910001, 0)', '23505', 'pk_disponer');
SELECT pg_temp.rechazar('Canje.idSucursal: FK inexistente', 'INSERT INTO "Canje" VALUES (910003, 919999, 910001, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23503', 'fk_canje_sucursal');
SELECT pg_temp.rechazar('Canje.idCliente: FK inexistente', 'INSERT INTO "Canje" VALUES (910003, 910001, 919999, 910002, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23503', 'fk_canje_cliente');
SELECT pg_temp.rechazar('Canje.idPremio: FK inexistente', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 919999, ''AAAA900101HDFBBB01'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23503', 'fk_canje_premio');
SELECT pg_temp.rechazar('Canje.CURP: FK inexistente', 'INSERT INTO "Canje" VALUES (910003, 910001, 910001, 910002, ''BBBB900101HDFCCC02'', TIME ''12:30'', 10, 1, DATE ''2026-10-25'')', '23503', 'fk_canje_encargado');
SELECT pg_temp.rechazar('Disponer.idSucursal: FK inexistente', 'INSERT INTO "Disponer" VALUES (919999, 910002, 0)', '23503', 'fk_disponer_sucursal');
SELECT pg_temp.rechazar('Disponer.idPremio: FK inexistente', 'INSERT INTO "Disponer" VALUES (910002, 919999, 0)', '23503', 'fk_disponer_premio');
SELECT pg_temp.rechazar('Borrar Cliente referenciado', 'DELETE FROM "Cliente" WHERE "idCliente"=910001', '23503', 'fk_canje_cliente');
SELECT pg_temp.rechazar('Borrar Encargado de premios referenciado', 'DELETE FROM "Encargado de premios" WHERE "CURP"=''AAAA900101HDFBBB01''', '23503', 'fk_canje_encargado');
SELECT pg_temp.rechazar('Borrar premio con canjes', 'DELETE FROM "Premio" WHERE "idPremio"=910002', '23503');
SELECT pg_temp.rechazar('Cambiar PK sucursal referenciada', 'UPDATE "SUCURSAL" SET "idSucursal"=919999 WHERE "idSucursal"=910001', '23503');
SELECT pg_temp.rechazar('UPDATE a stock negativo', 'UPDATE "Disponer" SET "cantidadDisponible"=-1 WHERE "idSucursal"=910001 AND "idPremio"=910001', '23514', 'ck_disponer_cantidad');
SELECT count(*) AS casos_correctos FROM resultados_omar;
ROLLBACK;
