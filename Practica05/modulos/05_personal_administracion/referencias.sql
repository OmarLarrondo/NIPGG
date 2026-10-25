-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Definir mediante ALTER TABLE las FOREIGN KEY de las tablas de este módulo; acordar nombre, tipo y clave destino con su responsable.

-- 1. Gerente -> Sucursal
ALTER TABLE "Genrente"
    ADD CONSTRAINT fkgerentesucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal");

-- 2. Cajero -> Sucursal
ALTER TABLE "Cajero"
    ADD CONSTRAINT fkcajerosucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal");

-- 3. EncargadoDePremios -> Sucursal
ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT fkencargadopremiossucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal");

-- 4. Administrar -> Gerente
ALTER TABLE "Administrar"
    ADD CONSTRAINT fkadministrargerente
    FOREIGN KEY ("CURP")
    REFERENCES "Genrente" ("CURP");

-- 5. Administrar -> Sucursal
ALTER TABLE "Administrar"
    ADD CONSTRAINT fkadministrarsucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal");
