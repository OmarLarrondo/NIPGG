-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Preparar casos válidos y casos que deban rechazarse. Documentar resultado esperado y aislar cada fallo esperado para que no oculte otras pruebas. Este archivo no forma parte de DDL.sql.
-- Estado: pendiente de implementación. Este archivo contiene solo instrucciones.

BEGIN;

-- 1. Crear sucursales de prueba
-- Resultado esperado: se insertan correctamente.
INSERT INTO "Sucursal" ("idSucursal", "nombre")
VALUES
    (1, 'Sucursal Centro'),
    (2, 'Sucursal Norte');

-- 2. Insertar un gerente válido
-- Resultado esperado: se inserta correctamente.
INSERT INTO Gerente (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, cédulaProfesional
)
VALUES (
    'ABCD010101HDFXXX01', 1, 'Carlos', 'Pérez',
    'López', 'ABCD010101AB1', '2020-01-10',
    15000.00, '1990-01-01', '12345678'
);

-- 3. Insertar un cajero válido
-- Resultado esperado: se inserta correctamente.
INSERT INTO Cajero (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, horarioTrabajo
)
VALUES (
    'EFGH020202MDFYYY02', 1, 'Ana', 'García',
    'Hernández', 'EFGH020202CD2', '2022-05-15',
    9000.00, '1995-02-02', TIME '07:00:00'
);

-- 4. Insertar un encargado de premios válido
-- Resultado esperado: se inserta correctamente.
INSERT INTO EncargadoDePremios (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, horarioTrabajo
)
VALUES (
    'IJKL030303HDFZZZ03', 2, 'Luis', 'Ramírez',
    'Torres', 'IJKL030303EF3', '2023-03-20',
    10000.00, '1998-03-03', TIME '15:00:00'
);

-- 5. Registrar la administración de una sucursal
-- Resultado esperado: se inserta correctamente.
INSERT INTO Administrar (CURP, idSucursal)
VALUES ('ABCD010101HDFXXX01', 1);


-- 6. Consultar los registros insertados
-- Resultado esperado: aparecen los registros.
SELECT * FROM Gerente;
SELECT * FROM Cajero;
SELECT * FROM EncargadoDePremios;
SELECT * FROM Administrar;

-- Deshacer los registros de prueba para no
-- dejar datos de prueba en la base de datos.
ROLLBACK;

-- Prueba 7: rechazar un salario negativo.
INSERT INTO Gerente (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, cédulaProfesional
)
VALUES (
    'MNOP040404HDFWWW04', 1, 'Pedro', 'Díaz',
    'Ruiz', 'MNOP040404GH4', '2020-01-10',
    -100.00, '1990-04-04', '1234567'
);


-- Prueba 8: rechazar un horario no permitido.
INSERT INTO Cajero (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, horarioTrabajo
)
VALUES (
    'QRST050505MDFVVV05', 1, 'Laura', 'Mora',
    'Sánchez', 'QRST050505IJ5', '2022-05-15',
    9000.00, '1995-05-05', TIME '10:00:00'
);


-- Prueba 9: rechazar una sucursal inexistente.
-- Se supone que la sucursal 999999 no existe.
INSERT INTO Cajero (
    CURP, idSucursal, nombre, apellidoMaterno,
    apellidoPaterno, RFC, fechaContratación,
    salario, fechaNacimiento, horarioTrabajo
)
VALUES (
    'UVWX060606HDFUUU06', 999999, 'Mario', 'Luna',
    'Flores', 'UVWX060606KL6', '2022-05-15',
    9000.00, '1995-06-06', TIME '07:00:00'
);
