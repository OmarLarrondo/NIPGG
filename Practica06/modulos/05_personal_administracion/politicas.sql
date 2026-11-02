-- Módulo 05 | Responsable: Diego
-- Estado: plantilla; políticas pendientes de implementar.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

BEGIN;

-- 1. CorreoElectrónicoGerente -> Genrente
ALTER TABLE "CorreoElectrónicoGerente"
    DROP CONSTRAINT fk_correo_gerente;

ALTER TABLE "CorreoElectrónicoGerente"
    ADD CONSTRAINT fk_correo_gerente
    FOREIGN KEY ("CURP")
    REFERENCES "Genrente" ("CURP")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 2. TeléfonoGerente -> Genrente
ALTER TABLE "TeléfonoGerente"
    DROP CONSTRAINT fk_telefono_gerente;

ALTER TABLE "TeléfonoGerente"
    ADD CONSTRAINT fk_telefono_gerente
    FOREIGN KEY ("CURP")
    REFERENCES "Genrente" ("CURP")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 3. CorreoElectrónicoCajero -> Cajero
ALTER TABLE "CorreoElectrónicoCajero"
    DROP CONSTRAINT fk_correo_cajero;

ALTER TABLE "CorreoElectrónicoCajero"
    ADD CONSTRAINT fk_correo_cajero
    FOREIGN KEY ("CURP")
    REFERENCES "Cajero" ("CURP")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 4. TeléfonoCajero -> Cajero
ALTER TABLE "TeléfonoCajero"
    DROP CONSTRAINT fk_telefono_cajero;

ALTER TABLE "TeléfonoCajero"
    ADD CONSTRAINT fk_telefono_cajero
    FOREIGN KEY ("CURP")
    REFERENCES "Cajero" ("CURP")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 5. Genrente -> SUCURSAL
ALTER TABLE "Genrente"
    DROP CONSTRAINT fkgerentesucursal;

ALTER TABLE "Genrente"
    ADD CONSTRAINT fkgerentesucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 6. Cajero -> SUCURSAL
ALTER TABLE "Cajero"
    DROP CONSTRAINT fkcajerosucursal;

ALTER TABLE "Cajero"
    ADD CONSTRAINT fkcajerosucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE NO ACTION
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 7. Administrar -> Genrente
ALTER TABLE "Administrar"
    DROP CONSTRAINT fkadministrargerente;

ALTER TABLE "Administrar"
    ADD CONSTRAINT fkadministrargerente
    FOREIGN KEY ("CURP")
    REFERENCES "Genrente" ("CURP")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE;

-- 8. Administrar -> SUCURSAL
ALTER TABLE "Administrar"
    DROP CONSTRAINT fkadministrarsucursal;

ALTER TABLE "Administrar"
    ADD CONSTRAINT fkadministrarsucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE CASCADE
    ON UPDATE CASCADE
    NOT DEFERRABLE;


COMMIT;

