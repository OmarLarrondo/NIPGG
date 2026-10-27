-- Práctica 05 | Juegos, máquinas y técnicos
-- Estructura literal de Diagramas/RelacionalÑIPGG.drawio.
-- Las restricciones se agregan mediante ALTER TABLE.

CREATE TABLE "tipoDeJuego" (
    "idTipo" integer,
    "reglaPuntuacion" text,
    "condicion" text,
    "nombre" varchar(50)
);

CREATE TABLE "Juego" (
    "idJuego" integer,
    "costo" integer,
    "nombre" varchar(50),
    "idTipo" integer
);

CREATE TABLE "Máquina" (
    "idMaquina" integer,
    "estado" varchar(50),
    "idJuego" integer,
    "idSucursal" integer
);

CREATE TABLE "Mantenimiento" (
    "idMaquina" integer,
    "idMantenimiento" integer,
    "fecha" date,
    "descripcionProblema" text,
    "tipoMantenimiento" varchar(50),
    "CURP" char(18)
);

CREATE TABLE "Técnico" (
    "CURP" char(18),
    "idSucursal" integer,
    "Nombre" varchar(100),
    "ApellidoMaterno" varchar(100),
    "ApellidoPaterno" varchar(100),
    "RFC" char(13),
    "fechaContratación" date,
    "salario" numeric(10,2),
    "fechaNacimiento" date,
    "áreaEspecialidad" varchar(100)
);

CREATE TABLE "Certificaciones" (
    "CURP" char(18),
    "Certificaciones" varchar(80)
);
