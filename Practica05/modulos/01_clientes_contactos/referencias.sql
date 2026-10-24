-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Ejecutar después de tablas, dominios y claves de TODOS los módulos.
-- Dependencias a confirmar en el contrato del equipo:
-- módulo 02: "Máquina"("idMaquina" integer), con PK/UNIQUE;
-- módulo 05: "Empleado"("CURP" char(18)) y "Cajero"("CURP" char(18)), con PK/UNIQUE.
-- NO ACTION impide cambios que dejen referencias sin destino.

ALTER TABLE "CorreoCliente"
    ADD CONSTRAINT fk_correo_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TelefonoCliente"
    ADD CONSTRAINT fk_telefono_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Tarjeta"
    ADD CONSTRAINT fk_tarjeta_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_tarjeta_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Partida"
    ADD CONSTRAINT fk_partida_tarjeta FOREIGN KEY ("idCliente")
        REFERENCES "Tarjeta" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_partida_maquina FOREIGN KEY ("idMaquina")
        REFERENCES "Máquina" ("idMaquina")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoEmpleado"
    ADD CONSTRAINT fk_correo_empleado FOREIGN KEY ("CURP")
        REFERENCES "Empleado" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TelefonoEmpleado"
    ADD CONSTRAINT fk_telefono_empleado FOREIGN KEY ("CURP")
        REFERENCES "Empleado" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;
