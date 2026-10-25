-- Práctica 05 | Omar | Modelo: Practica04.drawio.xml proporcionado.
-- Restricciones separadas mediante ALTER TABLE.

CREATE TABLE "Premio" (
    "idPremio" integer,
    "valorAproximado" integer,
    "puntosNecesarios" integer,
    "nombre" varchar(50),
    "categoría" varchar(50),
    "rangoEdad" varchar(50)
);

CREATE TABLE "Canje" (
    "idCanje" integer,
    "idSucursal" integer,
    "idCliente" integer,
    "idPremio" integer,
    "CURP" char(18),
    "hora" time,
    "puntosUtilizados" integer,
    "cantidadPremios" integer,
    "fecha" date
);

CREATE TABLE "Disponer" (
    "idSucursal" integer,
    "idPremio" integer,
    "cantidadDisponible" integer
);
