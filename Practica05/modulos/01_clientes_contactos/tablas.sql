-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Base: conversión del informe de Práctica 04, secciones 01 y 05.
-- Su integración queda sujeta al acuerdo en acuerdos/contrato_modelo.md.
-- Las comillas conservan los nombres, mayúsculas y acentos del informe.
-- Las restricciones se agregan por separado mediante ALTER TABLE.

CREATE TABLE "Cliente" (
    "idCliente" integer,
    "fechaNacimiento" date,
    "nombre" varchar(50),
    "apellidoMaterno" varchar(50),
    "apellidoPaterno" varchar(50),
    "sexo" varchar(50)
);

CREATE TABLE "CorreoCliente" (
    "idCliente" integer,
    "correoElectrónico" varchar(100)
);

CREATE TABLE "TelefonoCliente" (
    "idCliente" integer,
    "teléfono" char(10)
);

CREATE TABLE "Tarjeta" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "costoAdquisición" integer,
    "fechaCompra" date,
    "saldo" integer,
    "estado" varchar(50),
    "puntosAcumulados" integer,
    "CURP" char(18)
);

CREATE TABLE "Partida" (
    "idCliente" integer,
    "idMaquina" integer,
    "idPartida" integer,
    "fecha" date,
    "hora" timetz,
    "puntosGanados" integer,
    "puntajeObtenido" integer
);

CREATE TABLE "CorreoEmpleado" (
    "CURP" char(18),
    "correoElectrónico" varchar(50)
);

CREATE TABLE "TelefonoEmpleado" (
    "CURP" char(18),
    "teléfono" char(10)
);
