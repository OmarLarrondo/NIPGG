-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Definir mediante ALTER TABLE las FOREIGN KEY de las tablas de este módulo; acordar nombre, tipo y clave destino con su responsable.
-- Estado: pendiente de implementación. Este archivo contiene solo instrucciones.

-- 1. Gerente -> Sucursal
ALTER TABLE Gerente
    ADD CONSTRAINT fkgerentesucursal
    FOREIGN KEY (idSucursal)
    REFERENCES "Sucursal" ("idSucursal");

-- 2. Cajero -> Sucursal
ALTER TABLE Cajero
    ADD CONSTRAINT fkcajerosucursal
    FOREIGN KEY (idSucursal)
    REFERENCES "Sucursal" ("idSucursal");

-- 3. EncargadoDePremios -> Sucursal
ALTER TABLE EncargadoDePremios
    ADD CONSTRAINT fkencargadopremiossucursal
    FOREIGN KEY (idSucursal)
    REFERENCES "Sucursal" ("idSucursal");

-- 4. Administrar -> Gerente
ALTER TABLE Administrar
    ADD CONSTRAINT fkadministrargerente
    FOREIGN KEY (CURP)
    REFERENCES Gerente (CURP);

-- 5. Administrar -> Sucursal
ALTER TABLE Administrar
    ADD CONSTRAINT fkadministrarsucursal
    FOREIGN KEY (idSucursal)
    REFERENCES "Sucursal" ("idSucursal");
