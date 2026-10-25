-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Definir mediante ALTER TABLE las PRIMARY KEY simples o compuestas y las restricciones UNIQUE.

-- 1. Gerente
ALTER TABLE "Genrente"
    ADD CONSTRAINT pkgerente PRIMARY KEY ("CURP");

ALTER TABLE "Genrente"
    ADD CONSTRAINT uqgerenterfc UNIQUE ("RFC");

-- 2. Cajero
ALTER TABLE "Cajero"
    ADD CONSTRAINT pkcajero PRIMARY KEY ("CURP");

ALTER TABLE "Cajero"
    ADD CONSTRAINT uqcajerorfc UNIQUE ("RFC");

-- 3. EncargadoDePremios
ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT pkencargadodepremios PRIMARY KEY ("CURP");

ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT uqencargadodepremiosrfc UNIQUE ("RFC");


-- Completar la clave de la asociación para impedir parejas repetidas.
ALTER TABLE "Administrar"
    ADD CONSTRAINT pk_administrar PRIMARY KEY ("CURP", "idSucursal");
