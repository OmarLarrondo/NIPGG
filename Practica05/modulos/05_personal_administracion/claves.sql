-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Definir mediante ALTER TABLE las PRIMARY KEY simples o compuestas y las restricciones UNIQUE.
-- Estado: pendiente de implementación. Este archivo contiene solo instrucciones.

-- 1. Gerente
ALTER TABLE Gerente
    ADD CONSTRAINT pkgerente PRIMARY KEY (CURP);

ALTER TABLE Gerente
    ADD CONSTRAINT uqgerenterfc UNIQUE (RFC);

-- 2. Cajero
ALTER TABLE Cajero
    ADD CONSTRAINT pkcajero PRIMARY KEY (CURP);

ALTER TABLE Cajero
    ADD CONSTRAINT uqcajerorfc UNIQUE (RFC);

-- 3. EncargadoDePremios
ALTER TABLE EncargadoDePremios
    ADD CONSTRAINT pkencargadodepremios PRIMARY KEY (CURP);

ALTER TABLE EncargadoDePremios
    ADD CONSTRAINT uqencargadodepremiosrfc UNIQUE (RFC);

