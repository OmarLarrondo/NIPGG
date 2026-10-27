-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas: "Genrente", "Cajero", "Encargado de premios", "Administrar"
-- Definir únicamente las tablas, columnas y tipos mediante CREATE TABLE. Las restricciones se escriben en los otros archivos mediante ALTER TABLE.

-- 1. "Genrente"
CREATE TABLE "Genrente" (
    "CURP" CHAR(18),
    "idSucursal" INT,
    "Nombre" VARCHAR(100),
    "ApellidoMaterno" VARCHAR(100),
    "ApellidoPaterno" VARCHAR(100),
    "RFC" CHAR(13),
    "fechaContratación" DATE,
    "salario" NUMERIC(10,2),
    "fechaNacimiento" DATE,
    "cédulaProfesional" VARCHAR(8)
);

-- 2. "Cajero"
CREATE TABLE "Cajero" (
    "CURP" CHAR(18),
    "idSucursal" INT,
    "Nombre" VARCHAR(100),
    "ApellidoMaterno" VARCHAR(100),
    "ApellidoPaterno" VARCHAR(100),
    "RFC" CHAR(13),
    "fechaContratación" DATE,
    "salario" NUMERIC(10,2),
    "fechaNacimiento" DATE,
    "horarioTrabajo" TIME
);

-- 3. "Encargado de premios"
CREATE TABLE "Encargado de premios" (
    "CURP" CHAR(18),
    "idSucursal" INT,
    "Nombre" VARCHAR(100),
    "ApellidoMaterno" VARCHAR(100),
    "ApellidoPaterno" VARCHAR(100),
    "RFC" CHAR(13),
    "fechaContratación" DATE,
    "salario" NUMERIC(10,2),
    "fechaNacimiento" DATE,
    "horarioTrabajo" TIME
);

-- 4. "Administrar"
CREATE TABLE "Administrar" (
    "CURP" CHAR(18),
    "idSucursal" INT
);
