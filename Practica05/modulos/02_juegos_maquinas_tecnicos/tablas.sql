-- Práctica 05 | Juegos, máquinas y técnicos
-- Responsable: Ana
-- Tablas asignadas: TipoJuego, Juego, Máquina, Mantenimiento, Técnico, CertificacionTecnico
-- Definir únicamente las tablas, columnas y tipos mediante CREATE TABLE. Las restricciones se escriben en los otros archivos mediante ALTER TABLE.
-- Estado: pendiente de implementación. Este archivo contiene solo instrucciones.
-- Fuente de estructura: Practica04/Diagramas/RelacionalÑIPGG.drawio.
-- Se conservan nombres, columnas y llaves del diagrama relacional entregado.
-- Las comillas conservan mayúsculas, acentos y espacios del modelo.
-- Todas las restricciones se agregan por separado mediante ALTER TABLE.

CREATE TABLE "TipoJuego" (
    "idTipo" integer,
    "reglaPuntuacion" text,
    "condicion" text,
    "nombre" varchar(50)
);

CREATE TABLE "Juego" (
    "idJuego" integer,
    "idTipo" integer,
    "nombre" varchar(50),
    "costo" integer,
);

CREATE TABLE "Máquina" (
    "idMaquina" integer,
    "idJuego" integer,
    "idSucursal" integer,
    "estado" varchar(50),
);

CREATE TABLE "Mantenimiento" (
    "idMantenimiento" integer,
    "idMaquina" integer,
    "fecha" date,
    "descripcionProblema" text,
    "tipoMantenimiento" varchar(50),
    "CURP" char(18),
);

CREATE TABLE "Técnico" (
    "CURP" char(18),
    "idSucursal" integer,
    "nombre" varchar(100),
    "apellidoMaterno" varchar(100),
    "apellidoPaterno" varchar(100),
    "RFC" char(13),
    "fechaContratacion" date,
    "salario" numeric(10,2),
    "fechaNacimiento" date,
);

CREATE TABLE "CertificacionTecnico" (
    "CURP" char(18),
    "Certificaciones" varchar(80),
);