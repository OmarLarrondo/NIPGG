-- Módulo 05 | Responsable: Diego
-- Estado: plantilla; políticas pendientes de implementar.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

-- TODO: "CorreoElectrónicoGerente" / fk_correo_gerente
-- ("CURP") -> "Genrente" ("CURP")

-- TODO: "TeléfonoGerente" / fk_telefono_gerente
-- ("CURP") -> "Genrente" ("CURP")

-- TODO: "CorreoElectrónicoCajero" / fk_correo_cajero
-- ("CURP") -> "Cajero" ("CURP")

-- TODO: "TeléfonoCajero" / fk_telefono_cajero
-- ("CURP") -> "Cajero" ("CURP")

-- TODO: "Genrente" / fkgerentesucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "Cajero" / fkcajerosucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "Administrar" / fkadministrargerente
-- ("CURP") -> "Genrente" ("CURP")

-- TODO: "Administrar" / fkadministrarsucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")
