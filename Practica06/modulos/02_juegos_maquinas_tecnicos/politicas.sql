-- Módulo 02 | Responsable: Miguel
-- Estado: plantilla; políticas pendientes de implementar.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

-- TODO: "CorreoElectrónicoTécnico" / fk_correo_tecnico
-- ("CURP") -> "Técnico" ("CURP")

-- TODO: "TeléfonoTécnivo" / fk_telefono_tecnico
-- ("CURP") -> "Técnico" ("CURP")

-- TODO: "Mantenimiento" / fk_mantenimiento_maquina
-- ("idMaquina") -> "Máquina" ("idMaquina")

-- TODO: "Mantenimiento" / fk_mantenimiento_tecnico
-- ("CURP") -> "Técnico" ("CURP")

-- TODO: "Máquina" / fk_maquina_juego
-- ("idJuego") -> "Juego" ("idJuego")

-- TODO: "Máquina" / fk_maquina_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "Juego" / fk_juego_tipo
-- ("idTipo") -> "tipoDeJuego" ("idTipo")

-- TODO: "Técnico" / fk_tecnico_sucursal
-- ("idSucursal") -> "SUCURSAL" ("idSucursal")

-- TODO: "Certificaciones" / fk_certificacion_tecnico
-- ("CURP") -> "Técnico" ("CURP")
