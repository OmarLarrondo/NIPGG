-- Módulo 04 | Responsable: Yahir
-- Estado: plantilla; políticas pendientes de implementar.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

-- TODO: "HORARIO_SUCURSAL" / fk_horario_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "VISITA" / fk_visita_tarjeta
-- ("idCliente", "numeroTarjeta") -> "Tarjeta" ("idCliente", "numeroTarjeta")

-- TODO: "VISITA" / fk_visita_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "RECARGA" / fk_recarga_tarjeta
-- ("idCliente", "numeroTarjeta") -> "Tarjeta" ("idCliente", "numeroTarjeta")

-- TODO: "RECARGA" / fk_recarga_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "RECARGA" / fk_recarga_cajero
-- ("CURP") -> "Cajero" ("CURP")
