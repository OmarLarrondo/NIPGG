-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas: "Genrente", "Cajero", "Encargado de premios", "Administrar"
-- Definir mediante ALTER TABLE las PRIMARY KEY simples o compuestas y las restricciones UNIQUE.

-- 1. "Genrente"
ALTER TABLE "Genrente"
    ADD CONSTRAINT pkgerente PRIMARY KEY ("CURP");

ALTER TABLE "Genrente"
    ADD CONSTRAINT uqgerenterfc UNIQUE ("RFC");

-- 2. "Cajero"
ALTER TABLE "Cajero"
    ADD CONSTRAINT pkcajero PRIMARY KEY ("CURP");

ALTER TABLE "Cajero"
    ADD CONSTRAINT uqcajerorfc UNIQUE ("RFC");

-- 3. "Encargado de premios"
ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT pkencargadodepremios PRIMARY KEY ("CURP");

ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT uqencargadodepremiosrfc UNIQUE ("RFC");

-- 4. "Administrar"
ALTER TABLE "Administrar"
    ADD CONSTRAINT pkadministrar PRIMARY KEY ("CURP", "idSucursal");

ALTER TABLE "Administrar"
    ADD CONSTRAINT uqadministrarsucursal UNIQUE ("idSucursal");

ALTER TABLE "Administrar"
    ADD CONSTRAINT uqadministrargerente UNIQUE ("CURP");
