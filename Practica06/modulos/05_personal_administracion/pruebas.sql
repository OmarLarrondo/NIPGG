-- Módulo 05 | Responsable: Diego
-- Estado: plantilla sin casos implementados ni resultados verificados.
-- Usar una base de pruebas propia con el DDL completo y las políticas aplicadas.
-- Preparar datos sintéticos válidos y dependencias; revertirlos al terminar.
-- Comprobar el estado final de las filas, no solo que la sentencia termine.
-- Manejar los errores esperados sin abortar el resto de comprobaciones.
-- Verificar también comentarios de tablas, columnas y constraints en el catálogo.
BEGIN;

SELECT version();

CREATE TEMP TABLE resultados (
    caso text,
    resultado text
);
-- FUNCIÓN PARA PROBAR OPERACIONES
CREATE FUNCTION pg_temp.probar(
    caso text,
    operacion text,
    verificacion text,
    error_constraint text DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    correcto boolean;
    restriccion text;
    estado text;
BEGIN
    BEGIN
        EXECUTE operacion;

        IF error_constraint IS NOT NULL THEN
            RAISE EXCEPTION
                'Se esperaba foreign_key_violation de %',
                error_constraint;
        END IF;

        EXECUTE verificacion INTO correcto;

        IF correcto IS DISTINCT FROM TRUE THEN
            RAISE EXCEPTION
                'Estado final incorrecto: %', caso;
        END IF;

        RAISE SQLSTATE 'Z0001';

    EXCEPTION
        WHEN SQLSTATE 'Z0001' THEN
            NULL;

        WHEN foreign_key_violation OR restrict_violation THEN
            GET STACKED DIAGNOSTICS
                restriccion = CONSTRAINT_NAME,
                estado = RETURNED_SQLSTATE;

            IF error_constraint IS NULL
                OR restriccion <> error_constraint
            THEN
                RAISE;
            END IF;

            EXECUTE verificacion INTO correcto;

            IF correcto IS DISTINCT FROM TRUE THEN
                RAISE EXCEPTION
                    'Estado alterado después del rechazo: %',
                    caso;
            END IF;
    END;

    INSERT INTO resultados VALUES (caso, 'OK');
END;
$$;

-- Sucursales utilizadas exclusivamente para las pruebas.
INSERT INTO "SUCURSAL" VALUES
(6501, 'Sucursal prueba 6501', '5512346501',
 'Calle prueba', 1, 0, 'Centro', 'CDMX'),

(6502, 'Sucursal prueba 6502', '5512346502',
 'Calle prueba', 2, 0, 'Centro', 'CDMX'),

(6503, 'Sucursal prueba 6503', '5512346503',
 'Calle prueba', 3, 0, 'Centro', 'CDMX'),

(6504, 'Sucursal prueba 6504', '5512346504',
 'Calle prueba', 4, 0, 'Centro', 'CDMX'),

(6505, 'Sucursal prueba 6505', '5512346505',
 'Calle prueba', 5, 0, 'Centro', 'CDMX'),

(6506, 'Sucursal prueba 6506', '5512346506',
 'Calle prueba', 6, 0, 'Centro', 'CDMX');


-- Gerentes de prueba.
INSERT INTO "Genrente" VALUES

('AAAA000101HDFBBB01', 6501,
 'Gerente Uno', 'Materno', 'Paterno',
 'ABCD000101AAA', '2020-01-01', 10000,
 '1980-01-01', '12345678'),

('AAAA000101HDFBBB02', 6503,
 'Gerente Dos', 'Materno', 'Paterno',
 'EFGH000101BBA', '2020-01-01', 10000,
 '1980-01-01', '12345679'),

('AAAA000101HDFBBB03', 6503,
 'Gerente Tres', 'Materno', 'Paterno',
 'IJKL000101CCA', '2020-01-01', 10000,
 '1980-01-01', '12345680'),

('AAAA000101HDFBBB04', 6503,
 'Gerente Cuatro', 'Materno', 'Paterno',
 'MNOP000101DDA', '2020-01-01', 10000,
 '1980-01-01', '12345681');


-- Cajeros de prueba.
INSERT INTO "Cajero" VALUES

('BBBB000101HDFCCC01', 6502,
 'Cajero Uno', 'Materno', 'Paterno',
 'WXYZ000101FFA', '2020-01-01', 5000,
 '1990-01-01', '07:00:00'),

('BBBB000101HDFCCC02', 6503,
 'Cajero Dos', 'Materno', 'Paterno',
 'JKLM000101GGA', '2020-01-01', 5000,
 '1990-01-01', '15:00:00');


-- Contactos de prueba.
INSERT INTO "CorreoElectrónicoGerente"
VALUES ('AAAA000101HDFBBB01', 'gerente1@example.test');

INSERT INTO "TeléfonoGerente"
VALUES ('AAAA000101HDFBBB04', '5511111111');

INSERT INTO "CorreoElectrónicoCajero"
VALUES ('BBBB000101HDFCCC01', 'cajero1@example.test');

INSERT INTO "TeléfonoCajero"
VALUES ('BBBB000101HDFCCC02', '5522222222');


-- Asignaciones administrativas.
INSERT INTO "Administrar" VALUES
('AAAA000101HDFBBB02', 6504),
('AAAA000101HDFBBB03', 6505);


-- PRUEBAS 1-4: fk_correo_gerente
SELECT pg_temp.probar(
    'fk_correo_gerente: DELETE CASCADE',
    $q$
    DELETE FROM "Genrente"
    WHERE "CURP" = 'AAAA000101HDFBBB01'
    $q$,
    $q$
    SELECT
        NOT EXISTS (
            SELECT FROM "Genrente"
            WHERE "CURP" = 'AAAA000101HDFBBB01'
        )
        AND NOT EXISTS (
            SELECT FROM "CorreoElectrónicoGerente"
            WHERE "CURP" = 'AAAA000101HDFBBB01'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_correo_gerente: UPDATE CASCADE',
    $q$
    UPDATE "Genrente"
    SET "CURP" = 'AAAA000101HDFBBB11'
    WHERE "CURP" = 'AAAA000101HDFBBB01'
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "CorreoElectrónicoGerente"
            WHERE "CURP" = 'AAAA000101HDFBBB11'
        )
        AND NOT EXISTS (
            SELECT FROM "CorreoElectrónicoGerente"
            WHERE "CURP" = 'AAAA000101HDFBBB01'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_correo_gerente: INSERT huérfano',
    $q$
    INSERT INTO "CorreoElectrónicoGerente"
    VALUES ('ZZZZ000101HDFZZZ99', 'otro@example.test')
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "CorreoElectrónicoGerente"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_correo_gerente'
);

SELECT pg_temp.probar(
    'fk_correo_gerente: UPDATE huérfano',
    $q$
    UPDATE "CorreoElectrónicoGerente"
    SET "CURP" = 'ZZZZ000101HDFZZZ99'
    WHERE "CURP" = 'AAAA000101HDFBBB01'
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "CorreoElectrónicoGerente"
        WHERE "CURP" = 'AAAA000101HDFBBB01'
    )
    AND NOT EXISTS (
        SELECT FROM "CorreoElectrónicoGerente"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_correo_gerente'
);

-- PRUEBAS 5-8: fk_telefono_gerente
SELECT pg_temp.probar(
    'fk_telefono_gerente: DELETE CASCADE',
    $q$
    DELETE FROM "Genrente"
    WHERE "CURP" = 'AAAA000101HDFBBB04'
    $q$,
    $q$
    SELECT
        NOT EXISTS (
            SELECT FROM "Genrente"
            WHERE "CURP" = 'AAAA000101HDFBBB04'
        )
        AND NOT EXISTS (
            SELECT FROM "TeléfonoGerente"
            WHERE "CURP" = 'AAAA000101HDFBBB04'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_telefono_gerente: UPDATE CASCADE',
    $q$
    UPDATE "Genrente"
    SET "CURP" = 'AAAA000101HDFBBB14'
    WHERE "CURP" = 'AAAA000101HDFBBB04'
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "TeléfonoGerente"
            WHERE "CURP" = 'AAAA000101HDFBBB14'
        )
        AND NOT EXISTS (
            SELECT FROM "TeléfonoGerente"
            WHERE "CURP" = 'AAAA000101HDFBBB04'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_telefono_gerente: INSERT huérfano',
    $q$
    INSERT INTO "TeléfonoGerente"
    VALUES ('ZZZZ000101HDFZZZ99', '5599999999')
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "TeléfonoGerente"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_telefono_gerente'
);

SELECT pg_temp.probar(
    'fk_telefono_gerente: UPDATE huérfano',
    $q$
    UPDATE "TeléfonoGerente"
    SET "CURP" = 'ZZZZ000101HDFZZZ99'
    WHERE "CURP" = 'AAAA000101HDFBBB04'
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "TeléfonoGerente"
        WHERE "CURP" = 'AAAA000101HDFBBB04'
    )
    AND NOT EXISTS (
        SELECT FROM "TeléfonoGerente"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_telefono_gerente'
);

-- PRUEBAS 9-12: fk_correo_cajero
SELECT pg_temp.probar(
    'fk_correo_cajero: DELETE CASCADE',
    $q$
    DELETE FROM "Cajero"
    WHERE "CURP" = 'BBBB000101HDFCCC01'
    $q$,
    $q$
    SELECT
        NOT EXISTS (
            SELECT FROM "Cajero"
            WHERE "CURP" = 'BBBB000101HDFCCC01'
        )
        AND NOT EXISTS (
            SELECT FROM "CorreoElectrónicoCajero"
            WHERE "CURP" = 'BBBB000101HDFCCC01'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_correo_cajero: UPDATE CASCADE',
    $q$
    UPDATE "Cajero"
    SET "CURP" = 'BBBB000101HDFCCC11'
    WHERE "CURP" = 'BBBB000101HDFCCC01'
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "CorreoElectrónicoCajero"
            WHERE "CURP" = 'BBBB000101HDFCCC11'
        )
        AND NOT EXISTS (
            SELECT FROM "CorreoElectrónicoCajero"
            WHERE "CURP" = 'BBBB000101HDFCCC01'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_correo_cajero: INSERT huérfano',
    $q$
    INSERT INTO "CorreoElectrónicoCajero"
    VALUES ('ZZZZ000101HDFZZZ99', 'otro@example.test')
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "CorreoElectrónicoCajero"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_correo_cajero'
);

SELECT pg_temp.probar(
    'fk_correo_cajero: UPDATE huérfano',
    $q$
    UPDATE "CorreoElectrónicoCajero"
    SET "CURP" = 'ZZZZ000101HDFZZZ99'
    WHERE "CURP" = 'BBBB000101HDFCCC01'
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "CorreoElectrónicoCajero"
        WHERE "CURP" = 'BBBB000101HDFCCC01'
    )
    AND NOT EXISTS (
        SELECT FROM "CorreoElectrónicoCajero"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_correo_cajero'
);

-- PRUEBAS 13-16: fk_telefono_cajero
SELECT pg_temp.probar(
    'fk_telefono_cajero: DELETE CASCADE',
    $q$
    DELETE FROM "Cajero"
    WHERE "CURP" = 'BBBB000101HDFCCC02'
    $q$,
    $q$
    SELECT
        NOT EXISTS (
            SELECT FROM "Cajero"
            WHERE "CURP" = 'BBBB000101HDFCCC02'
        )
        AND NOT EXISTS (
            SELECT FROM "TeléfonoCajero"
            WHERE "CURP" = 'BBBB000101HDFCCC02'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_telefono_cajero: UPDATE CASCADE',
    $q$
    UPDATE "Cajero"
    SET "CURP" = 'BBBB000101HDFCCC12'
    WHERE "CURP" = 'BBBB000101HDFCCC02'
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "TeléfonoCajero"
            WHERE "CURP" = 'BBBB000101HDFCCC12'
        )
        AND NOT EXISTS (
            SELECT FROM "TeléfonoCajero"
            WHERE "CURP" = 'BBBB000101HDFCCC02'
        )
    $q$
);

SELECT pg_temp.probar(
    'fk_telefono_cajero: INSERT huérfano',
    $q$
    INSERT INTO "TeléfonoCajero"
    VALUES ('ZZZZ000101HDFZZZ99', '5599999999')
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "TeléfonoCajero"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_telefono_cajero'
);

SELECT pg_temp.probar(
    'fk_telefono_cajero: UPDATE huérfano',
    $q$
    UPDATE "TeléfonoCajero"
    SET "CURP" = 'ZZZZ000101HDFZZZ99'
    WHERE "CURP" = 'BBBB000101HDFCCC02'
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "TeléfonoCajero"
        WHERE "CURP" = 'BBBB000101HDFCCC02'
    )
    AND NOT EXISTS (
        SELECT FROM "TeléfonoCajero"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fk_telefono_cajero'
);

-- PRUEBAS 17-20: fkgerentesucursal
SELECT pg_temp.probar(
    'fkgerentesucursal: DELETE NO ACTION',
    $q$
    DELETE FROM "SUCURSAL"
    WHERE "idSucursal" = 6501
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "SUCURSAL"
            WHERE "idSucursal" = 6501
        )
        AND EXISTS (
            SELECT FROM "Genrente"
            WHERE "idSucursal" = 6501
        )
    $q$,
    'fkgerentesucursal'
);

SELECT pg_temp.probar(
    'fkgerentesucursal: UPDATE CASCADE',
    $q$
    UPDATE "SUCURSAL"
    SET "idSucursal" = 6511
    WHERE "idSucursal" = 6501
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "Genrente"
            WHERE "idSucursal" = 6511
        )
        AND NOT EXISTS (
            SELECT FROM "Genrente"
            WHERE "idSucursal" = 6501
        )
    $q$
);

SELECT pg_temp.probar(
    'fkgerentesucursal: INSERT huérfano',
    $q$
    INSERT INTO "Genrente" VALUES
    ('AAAA000101HDFBBB05', 6598,
     'Gerente Cinco', 'Materno', 'Paterno',
     'QRST000101EEA', '2020-01-01', 10000,
     '1980-01-01', '12345682')
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "Genrente"
        WHERE "CURP" = 'AAAA000101HDFBBB05'
    )
    $q$,
    'fkgerentesucursal'
);

SELECT pg_temp.probar(
    'fkgerentesucursal: UPDATE huérfano',
    $q$
    UPDATE "Genrente"
    SET "idSucursal" = 6597
    WHERE "CURP" = 'AAAA000101HDFBBB04'
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "Genrente"
        WHERE "CURP" = 'AAAA000101HDFBBB04'
        AND "idSucursal" = 6503
    )
    AND NOT EXISTS (
        SELECT FROM "Genrente"
        WHERE "idSucursal" = 6597
    )
    $q$,
    'fkgerentesucursal'
);

-- PRUEBAS 21-24: fkcajerosucursal
SELECT pg_temp.probar(
    'fkcajerosucursal: DELETE NO ACTION',
    $q$
    DELETE FROM "SUCURSAL"
    WHERE "idSucursal" = 6502
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "SUCURSAL"
            WHERE "idSucursal" = 6502
        )
        AND EXISTS (
            SELECT FROM "Cajero"
            WHERE "idSucursal" = 6502
        )
    $q$,
    'fkcajerosucursal'
);

SELECT pg_temp.probar(
    'fkcajerosucursal: UPDATE CASCADE',
    $q$
    UPDATE "SUCURSAL"
    SET "idSucursal" = 6512
    WHERE "idSucursal" = 6502
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "Cajero"
            WHERE "idSucursal" = 6512
        )
        AND NOT EXISTS (
            SELECT FROM "Cajero"
            WHERE "idSucursal" = 6502
        )
    $q$
);

SELECT pg_temp.probar(
    'fkcajerosucursal: INSERT huérfano',
    $q$
    INSERT INTO "Cajero" VALUES
    ('BBBB000101HDFCCC03', 6598,
     'Cajero Tres', 'Materno', 'Paterno',
     'LMNO000101HHA', '2020-01-01', 5000,
     '1990-01-01', '07:00:00')
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "Cajero"
        WHERE "CURP" = 'BBBB000101HDFCCC03'
    )
    $q$,
    'fkcajerosucursal'
);

SELECT pg_temp.probar(
    'fkcajerosucursal: UPDATE huérfano',
    $q$
    UPDATE "Cajero"
    SET "idSucursal" = 6597
    WHERE "CURP" = 'BBBB000101HDFCCC02'
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "Cajero"
        WHERE "CURP" = 'BBBB000101HDFCCC02'
        AND "idSucursal" = 6503
    )
    AND NOT EXISTS (
        SELECT FROM "Cajero"
        WHERE "idSucursal" = 6597
    )
    $q$,
    'fkcajerosucursal'
);

-- PRUEBAS 25-28: fkadministrargerente
SELECT pg_temp.probar(
    'fkadministrargerente: DELETE CASCADE',
    $q$
    DELETE FROM "Genrente"
    WHERE "CURP" = 'AAAA000101HDFBBB02'
    $q$,
    $q$
    SELECT
        NOT EXISTS (
            SELECT FROM "Genrente"
            WHERE "CURP" = 'AAAA000101HDFBBB02'
        )
        AND NOT EXISTS (
            SELECT FROM "Administrar"
            WHERE "CURP" = 'AAAA000101HDFBBB02'
        )
    $q$
);

SELECT pg_temp.probar(
    'fkadministrargerente: UPDATE CASCADE',
    $q$
    UPDATE "Genrente"
    SET "CURP" = 'AAAA000101HDFBBB13'
    WHERE "CURP" = 'AAAA000101HDFBBB03'
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "Administrar"
            WHERE "CURP" = 'AAAA000101HDFBBB13'
        )
        AND NOT EXISTS (
            SELECT FROM "Administrar"
            WHERE "CURP" = 'AAAA000101HDFBBB03'
        )
    $q$
);

SELECT pg_temp.probar(
    'fkadministrargerente: INSERT huérfano',
    $q$
    INSERT INTO "Administrar"
    VALUES ('ZZZZ000101HDFZZZ99', 6506)
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "Administrar"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fkadministrargerente'
);

SELECT pg_temp.probar(
    'fkadministrargerente: UPDATE huérfano',
    $q$
    UPDATE "Administrar"
    SET "CURP" = 'ZZZZ000101HDFZZZ99'
    WHERE "CURP" = 'AAAA000101HDFBBB03'
    AND "idSucursal" = 6505
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "Administrar"
        WHERE "CURP" = 'AAAA000101HDFBBB03'
        AND "idSucursal" = 6505
    )
    AND NOT EXISTS (
        SELECT FROM "Administrar"
        WHERE "CURP" = 'ZZZZ000101HDFZZZ99'
    )
    $q$,
    'fkadministrargerente'
);

-- PRUEBAS 29-32: fkadministrarsucursal
SELECT pg_temp.probar(
    'fkadministrarsucursal: DELETE CASCADE',
    $q$
    DELETE FROM "SUCURSAL"
    WHERE "idSucursal" = 6505
    $q$,
    $q$
    SELECT
        NOT EXISTS (
            SELECT FROM "SUCURSAL"
            WHERE "idSucursal" = 6505
        )
        AND NOT EXISTS (
            SELECT FROM "Administrar"
            WHERE "CURP" = 'AAAA000101HDFBBB03'
            AND "idSucursal" = 6505
        )
    $q$
);

SELECT pg_temp.probar(
    'fkadministrarsucursal: UPDATE CASCADE',
    $q$
    UPDATE "SUCURSAL"
    SET "idSucursal" = 6515
    WHERE "idSucursal" = 6505
    $q$,
    $q$
    SELECT
        EXISTS (
            SELECT FROM "Administrar"
            WHERE "CURP" = 'AAAA000101HDFBBB03'
            AND "idSucursal" = 6515
        )
        AND NOT EXISTS (
            SELECT FROM "Administrar"
            WHERE "idSucursal" = 6505
        )
    $q$
);

SELECT pg_temp.probar(
    'fkadministrarsucursal: INSERT huérfano',
    $q$
    INSERT INTO "Administrar"
    VALUES ('AAAA000101HDFBBB04', 6597)
    $q$,
    $q$
    SELECT NOT EXISTS (
        SELECT FROM "Administrar"
        WHERE "CURP" = 'AAAA000101HDFBBB04'
        AND "idSucursal" = 6597
    )
    $q$,
    'fkadministrarsucursal'
);

SELECT pg_temp.probar(
    'fkadministrarsucursal: UPDATE huérfano',
    $q$
    UPDATE "Administrar"
    SET "idSucursal" = 6597
    WHERE "CURP" = 'AAAA000101HDFBBB03'
    AND "idSucursal" = 6505
    $q$,
    $q$
    SELECT EXISTS (
        SELECT FROM "Administrar"
        WHERE "CURP" = 'AAAA000101HDFBBB03'
        AND "idSucursal" = 6505
    )
    AND NOT EXISTS (
        SELECT FROM "Administrar"
        WHERE "idSucursal" = 6597
    )
    $q$,
    'fkadministrarsucursal'
);

-- VERIFICACIÓN DE COMENTARIOS
SELECT pg_temp.probar(
    'Comentarios: siete tablas',
    $q$SELECT 1$q$,
    $q$
    SELECT (
        SELECT count(*) = 7
        AND bool_and(
            obj_description(oid, 'pg_class') IS NOT NULL
        )
        FROM pg_class
        WHERE relnamespace = 'public'::regnamespace
        AND relname IN (
            'Genrente',
            'Cajero',
            'Administrar',
            'CorreoElectrónicoGerente',
            'TeléfonoGerente',
            'CorreoElectrónicoCajero',
            'TeléfonoCajero'
        )
    )
    $q$
);

SELECT pg_temp.probar(
    'Comentarios: 30 columnas',
    $q$SELECT 1$q$,
    $q$
    SELECT (
        SELECT count(*) = 30
        AND bool_and(
            col_description(c.oid, a.attnum) IS NOT NULL
            AND a.attnotnull
        )
        FROM pg_attribute a
        JOIN pg_class c ON c.oid = a.attrelid
        WHERE c.relnamespace = 'public'::regnamespace
        AND c.relname IN (
            'Genrente',
            'Cajero',
            'Administrar',
            'CorreoElectrónicoGerente',
            'TeléfonoGerente',
            'CorreoElectrónicoCajero',
            'TeléfonoCajero'
        )
        AND a.attnum > 0
        AND NOT a.attisdropped
    )
    $q$
);

SELECT pg_temp.probar(
    'Comentarios: 75 restricciones',
    $q$SELECT 1$q$,
    $q$
    SELECT (
        SELECT count(*) = 75
        AND bool_and(
            obj_description(k.oid, 'pg_constraint') IS NOT NULL
        )
        FROM pg_constraint k
        JOIN pg_class c ON c.oid = k.conrelid
        WHERE c.relnamespace = 'public'::regnamespace
        AND c.relname IN (
            'Genrente',
            'Cajero',
            'Administrar',
            'CorreoElectrónicoGerente',
            'TeléfonoGerente',
            'CorreoElectrónicoCajero',
            'TeléfonoCajero'
        )
    )
    $q$
);

-- VERIFICACIÓN DE LAS OCHO POLÍTICAS
SELECT pg_temp.probar(
    'Políticas: ocho llaves foráneas',
    $q$SELECT 1$q$,
    $q$
    SELECT (
        SELECT count(*) = 8
        AND bool_and(
            NOT condeferrable
            AND confupdtype = 'c'
            AND (
                (
                    conname IN (
                        'fk_correo_gerente',
                        'fk_telefono_gerente',
                        'fk_correo_cajero',
                        'fk_telefono_cajero',
                        'fkadministrargerente',
                        'fkadministrarsucursal'
                    )
                    AND confdeltype = 'c'
                )
                OR
                (
                    conname IN (
                        'fkgerentesucursal',
                        'fkcajerosucursal'
                    )
                    AND confdeltype = 'a'
                )
            )
        )
        FROM pg_constraint
        WHERE contype = 'f'
        AND conname IN (
            'fk_correo_gerente',
            'fk_telefono_gerente',
            'fk_correo_cajero',
            'fk_telefono_cajero',
            'fkgerentesucursal',
            'fkcajerosucursal',
            'fkadministrargerente',
            'fkadministrarsucursal'
        )
    )
    $q$
);

-- RESULTADOS
TABLE resultados;

SELECT
    count(*) AS casos_correctos,
    bool_and(resultado = 'OK') AS todos_correctos
FROM resultados;

ROLLBACK;

-- VERIFICACIÓN FINAL DE LIMPIEZA
DO $$
DECLARE
    r record;
    n bigint;
BEGIN
    FOR r IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'public'
    LOOP
        EXECUTE format(
            'SELECT count(*) FROM public.%I',
            r.tablename
        )
        INTO n;

        IF n <> 0 THEN
            RAISE EXCEPTION
                'La tabla % conserva datos de prueba',
                r.tablename;
        END IF;
    END LOOP;
END;
$$;

SELECT 'Las 30 tablas quedaron sin datos de prueba.' AS limpieza;

