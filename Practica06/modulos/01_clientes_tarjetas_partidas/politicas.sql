-- Módulo 01 | Responsable: Omar
-- Estado: plantilla; políticas pendientes de implementar.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

-- TODO: "correoElectrónico" / fk_correo_cliente
-- ("idCliente") -> "Cliente" ("idCliente")

-- TODO: "teléfono" / fk_telefono_cliente
-- ("idCliente") -> "Cliente" ("idCliente")

-- TODO: "Tarjeta" / fk_tarjeta_cliente
-- ("idCliente") -> "Cliente" ("idCliente")

-- TODO: "Tarjeta" / fk_tarjeta_cajero
-- ("CURP") -> "Cajero" ("CURP")

-- TODO: "Partida" / fk_partida_tarjeta
-- ("idCliente", "numeroTarjeta") -> "Tarjeta" ("idCliente", "numeroTarjeta")

-- TODO: "Partida" / fk_partida_maquina
-- ("idMaquina") -> "Máquina" ("idMaquina")
