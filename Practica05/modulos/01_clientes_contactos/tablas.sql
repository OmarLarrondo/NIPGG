-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Fuente de estructura: Practica04/Diagramas/RelacionalÑIPGG.drawio.
-- Se conservan nombres, columnas y llaves del diagrama relacional entregado.
-- Los contactos de personal apuntan directamente a cada puesto (criterio de Diego).
-- Las comillas conservan mayúsculas, acentos y espacios del modelo.
-- Todas las restricciones se agregan por separado mediante ALTER TABLE.

CREATE TABLE "Cliente" (
    "idCliente" integer,
    "fechaNacimiento" date,
    "nombre" varchar(50),
    "apellidoMaterno" varchar(50),
    "apellidoPaterno" varchar(50),
    "sexo" varchar(50)
);

CREATE TABLE "correoElectrónico" (
    "idCliente" integer,
    "correoElectrónico" varchar(100)
);

CREATE TABLE "teléfono" (
    "idCliente" integer,
    "teléfono" char(10)
);

CREATE TABLE "Tarjeta" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "CURP" char(18),
    "costoAdquisición" integer,
    "fechaCompra" date,
    "saldo" integer,
    "estado" varchar(50),
    "puntosAcumulados" integer
);

CREATE TABLE "Partida" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "idMaquina" integer,
    "idPartida" integer,
    "fecha" date,
    "puntosGanados" integer,
    "hora" timetz,
    "puntajeObtenido" integer
);

CREATE TABLE "CorreoElectrónicoGerente" (
    "CURP" char(18),
    "correoGerente" varchar(50)
);

CREATE TABLE "TeléfonoGerente" (
    "CURP" char(18),
    "telefonoGerente" char(10)
);

CREATE TABLE "CorreoElectrónicoCajero" (
    "CURP" char(18),
    "correoCajero" varchar(50)
);

CREATE TABLE "TeléfonoCajero" (
    "CURP" char(18),
    "telefonoCajero" char(10)
);

CREATE TABLE "CorreoElectrónicoEncargado" (
    "CURP" char(18),
    "correoEncargado" varchar(50)
);

CREATE TABLE "TeléfonoEncargado" (
    "CURP" char(18),
    "telefonoEncargado" char(10)
);

CREATE TABLE "CorreoElectrónicoTécnico" (
    "CURP" char(18),
    "correoTécnico" varchar(50)
);

-- El diagrama rotula "TeléfonoTécnivo" con v; se conserva el nombre literal.
CREATE TABLE "TeléfonoTécnivo" (
    "CURP" char(18),
    "telefonoTécnico" char(10)
);
