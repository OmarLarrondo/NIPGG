-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Preparar casos válidos y casos que deban rechazarse. Documentar resultado esperado y aislar cada fallo esperado para que no oculte otras pruebas. Este archivo no forma parte de DDL.sql.

BEGIN;

-- 1. Crear una tabla mínima para simular Sucursal
CREATE TABLE "SUCURSAL" (
    "idSucursal" INTEGER PRIMARY KEY,
    CHECK ("idSucursal" > 0)
);

INSERT INTO "SUCURSAL" ("idSucursal")
VALUES (1), (2), (3);


-- 2. Crear las llaves foráneas del módulo 05

-- 2.1. Gerente -> Sucursal
ALTER TABLE gerente
	ADD CONSTRAINT fk_gerente_sucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 2.2. Cajero -> Sucursal
ALTER TABLE cajero
	ADD CONSTRAINT fk_cajero_sucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 2.3. EncargadoDePremios -> Sucursal
ALTER TABLE encargadodepremios
	ADD CONSTRAINT fk_encargadopremios_sucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 2.4. Administrar -> Gerente
ALTER TABLE administrar
	ADD CONSTRAINT fk_administrar_gerente
	FOREIGN KEY (CURP)
	REFERENCES gerente (CURP);

-- 2.5. Administrar -> Sucursal
ALTER TABLE administrar
	ADD CONSTRAINT fk_administrar_sucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 3. Tabla auxiliar para registrar los resultados
CREATE TEMP TABLE resultados_personal (
    caso TEXT,
    resultado TEXT
);

-- 4. Insertar gerentes válidos
INSERT INTO Gerente (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, cédulaProfesional
)
VALUES
    (
        'AAAA000101HDFBBB01', 1, 'Carlos', 'Pérez',
        'López', 'ABCD900101A01', '2020-01-10',
        15000.00, '1990-01-01', '12345678'
    ),
    (
        'BBBB900202MDFCCC02', 2, 'María', 'García',
        'Hernández', 'EFGH850202B02', '2021-05-15',
        18000.00, '1990-02-02', '7654321'
    );

INSERT INTO resultados_personal
VALUES ('Gerentes válidos', 'Aceptada');

-- 5. Insertar un cajero válido
INSERT INTO Cajero (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, horarioTrabajo
)
VALUES (
    'CCCC900303HDFDDD03', 1, 'Ana', 'García',
    'Hernández', 'IJKL880303C03', '2022-05-15',
    9000.00, '1995-03-03', TIME '07:00:00'
);

INSERT INTO resultados_personal
VALUES ('Cajero válido', 'Aceptada');

-- 6. Insertar un encargado de premios válido
INSERT INTO EncargadoDePremios (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, horarioTrabajo
)
VALUES (
    'EEEE950404MDFEEE04', 2, 'Luis', 'Ramírez',
    'Torres', 'MNOP920404D04', '2023-03-20',
    10000.00, '1998-04-04', TIME '15:00:00'
);

INSERT INTO resultados_personal
VALUES ('Encargado de premios válido', 'Aceptada');

-- 7. Insertar una administración válida
INSERT INTO Administrar (CURP, idSucursal)
VALUES ('AAAA000101HDFBBB01', 1);

INSERT INTO resultados_personal
VALUES ('Administrar válido', 'Aceptada');

-- 8. Función auxiliar para probar errores esperados
CREATE FUNCTION pg_temp.esperar_error(
    caso TEXT,
    sentencia TEXT,
    estado_esperado TEXT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    estado_observado TEXT;
BEGIN
    BEGIN
        EXECUTE sentencia;

    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS
            estado_observado = RETURNED_SQLSTATE;

        IF estado_observado <> estado_esperado THEN
            RAISE EXCEPTION
                'FALLO en "%": se esperaba SQLSTATE %, se obtuvo %',
                caso, estado_esperado, estado_observado;
        END IF;

        INSERT INTO resultados_personal
        VALUES (
            caso,
            'Rechazada correctamente: ' || estado_observado
        );

        RETURN;
    END;

    RAISE EXCEPTION
        'FALLO en "%": se aceptó una operación inválida',
        caso;
END;
$$;

-- 9. Pruebas de restricciones

-- 9.1 Salario negativo: se espera una violación de CHECK.
SELECT pg_temp.esperar_error(
    'Salario negativo',
    $q$
        UPDATE Gerente
        SET salario = -100
        WHERE CURP = 'BBBB900202MDFCCC02'
    $q$,
    '23514'
);


-- 9.2 Horario inválido: se espera una violación de CHECK.
SELECT pg_temp.esperar_error(
    'Horario inválido de cajero',
    $q$
        UPDATE Cajero
        SET horarioTrabajo = TIME '10:00:00'
        WHERE CURP = 'CCCC900303HDFDDD03'
    $q$,
    '23514'
);


-- 9.3 Sucursal inexistente: se espera una violación de FK.
SELECT pg_temp.esperar_error(
    'Gerente con sucursal inexistente',
    $q$
        INSERT INTO Gerente (
            CURP, idSucursal, nombre, apellidoMaterno,
            apellidoPaterno, RFC, fechaContratación,
            salario, fechaNacimiento, cédulaProfesional
        )
        VALUES (
            'QRST800101HDFGGG05', 999999, 'Pedro', 'Díaz',
            'Ruiz', 'QRST800101E05', '2020-01-10',
            12000.00, '1980-01-01', '1234567'
        )
    $q$,
    '23503'
);


-- 9.4 CURP duplicada: se espera una violación de PK.
SELECT pg_temp.esperar_error(
    'CURP de gerente duplicada',
    $q$
        INSERT INTO Gerente (
            CURP, idSucursal, nombre, apellidoMaterno,
            apellidoPaterno, RFC, fechaContratación,
            salario, fechaNacimiento, cédulaProfesional
        )
        VALUES (
            'AAAA000101HDFBBB01', 1, 'Carlos', 'Pérez',
            'López', 'WXYZ750505E05', '2020-01-10',
            15000.00, '1990-01-01', '12345678'
        )
    $q$,
    '23505'
);


-- 9.5 Gerente repetido en Administrar: se espera una violación de PK o UNIQUE, según las restricciones definidas.
SELECT pg_temp.esperar_error(
    'Gerente repetido en Administrar',
    $q$
        INSERT INTO Administrar (CURP, idSucursal)
        VALUES ('AAAA000101HDFBBB01', 2)
    $q$,
    '23505'
);


-- 9.6 Sucursal repetida en Administrar: se espera UNIQUE.
SELECT pg_temp.esperar_error(
    'Sucursal repetida en Administrar',
    $q$
        INSERT INTO Administrar (CURP, idSucursal)
        VALUES ('BBBB900202MDFCCC02', 1)
    $q$,
    '23505'
);


-- 9.7 Gerente inexistente en Administrar: se espera una FK.
SELECT pg_temp.esperar_error(
    'Gerente inexistente en Administrar',
    $q$
        INSERT INTO Administrar (CURP, idSucursal)
        VALUES ('QRST800101HDFGGG05', 3)
    $q$,
    '23503'
);

-- 10. Consultar resultados
SELECT caso, resultado
FROM resultados_personal
ORDER BY caso;

-- 11. Deshacer los cambios de prueba
ROLLBACK;



