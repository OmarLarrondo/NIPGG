-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Definir únicamente las tablas, columnas y tipos mediante CREATE TABLE. Las restricciones se escriben en los otros archivos mediante ALTER TABLE.

-- 1. Gerente
CREATE TABLE Gerente (
    CURP CHAR(18),
    idSucursal INT,
    nombre VARCHAR(100),
    apellidoMaterno VARCHAR(100),
    apellidoPaterno VARCHAR(100),
    RFC CHAR(13),
    fechaContratación DATE,
    salario NUMERIC(10,2),
    fechaNacimiento DATE,
    cédulaProfesional VARCHAR(8)
);

-- 2. Cajero
CREATE TABLE Cajero (
    CURP CHAR(18),
    idSucursal INT,
    nombre VARCHAR(100),
    apellidoMaterno VARCHAR(100),
    apellidoPaterno VARCHAR(100),
    RFC CHAR(13),
    fechaContratación DATE,
    salario NUMERIC(10,2),
    fechaNacimiento DATE,
    horarioTrabajo TIME
);

-- 3. EncargadoDePremios
CREATE TABLE EncargadoDePremios (
    CURP CHAR(18),
    idSucursal INT,
    nombre VARCHAR(100),
    apellidoMaterno VARCHAR(100),
    apellidoPaterno VARCHAR(100),
    RFC CHAR(13),
    fechaContratación DATE,
    salario NUMERIC(10,2),
    fechaNacimiento DATE,
    horarioTrabajo TIME
);

-- 4. Administrar
CREATE TABLE Administrar (
    CURP CHAR(18),
    idSucursal INT
);
