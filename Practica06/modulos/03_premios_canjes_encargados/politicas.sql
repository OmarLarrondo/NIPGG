-- Módulo 03 | Responsable: Ana
-- Estado: plantilla; políticas pendientes de implementar.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

-- TODO: "CorreoElectrónicoEncargado" / fk_correo_encargado
-- ("CURP") -> "Encargado de premios" ("CURP")

-- TODO: "TeléfonoEncargado" / fk_telefono_encargado
-- ("CURP") -> "Encargado de premios" ("CURP")

-- TODO: "Canje" / fk_canje_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "Canje" / fk_canje_cliente
-- ("idCliente") -> "Cliente" ("idCliente")

-- TODO: "Canje" / fk_canje_premio
-- ("idPremio") -> "Premio" ("idPremio")

-- TODO: "Canje" / fk_canje_encargado
-- ("CURP") -> "Encargado de premios" ("CURP")

-- TODO: "Disponer" / fk_disponer_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "Disponer" / fk_disponer_premio
-- ("idPremio") -> "Premio" ("idPremio")

-- TODO: "Encargado de premios" / fkencargadopremiossucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")
