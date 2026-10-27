-- Práctica 05 | Sucursales y operaciones
-- Responsable: Yahir
-- Tablas asignadas: Sucursal, HorarioSucursal, Visita, Recarga
-- Definir únicamente las tablas, columnas y tipos mediante CREATE TABLE. Las restricciones se escriben en los otros archivos mediante ALTER TABLE.
-- Las comillas conservan mayúsculas, acentos y espacios del modelo.
-- Conserve los nombres en mayúsculas, acentos y espacios del modelo.

CREATE TABLE "SUCURSAL" (
    "idSucursal" integer,
    "nombre" varchar(50),
    "teléfono" char(10),
    "calle" varchar(100),
    "númeroExterior" integer,
    "númeroInterior" integer,
    "colonia" varchar(50),
    "estado" varchar(50)
);

CREATE TABLE "HORARIO_SUCURSAL" (
    "idSucursal" integer,
    "horario" varchar(50)
);

CREATE TABLE "VISITA" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "idSucursal" integer,
    "idVisita" integer,
    "fecha" date
);

CREATE TABLE "RECARGA" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "idSucursal" integer,
    "idRecarga" integer,
    "CURP" char(18),
    "monto" integer,
    "fecha" date,
    "hora" timetz,
    "métodoAbono" varchar(50)
);
