-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Ejecutar después de tablas, dominios y claves de TODOS los módulos.
-- Dependencias a confirmar en el contrato del equipo:
-- módulo 02: "Máquina"("idMaquina" integer) y "Técnico"("CURP" char(18));
-- módulo 05: "Gerente", "Cajero" y "Encargado de premios", con "CURP" char(18).
-- Cada columna destino debe tener PK/UNIQUE; se conservan los nombres del diagrama.
-- NO ACTION impide cambios que dejen referencias sin destino.

ALTER TABLE "correoElectrónico"
    ADD CONSTRAINT fk_correo_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "teléfono"
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
    ADD CONSTRAINT fk_partida_tarjeta FOREIGN KEY ("idCliente", "numeroTarjeta")
        REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_partida_maquina FOREIGN KEY ("idMaquina")
        REFERENCES "Máquina" ("idMaquina")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoGerente"
    ADD CONSTRAINT fk_correo_gerente FOREIGN KEY ("CURP")
        REFERENCES "Gerente" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoGerente"
    ADD CONSTRAINT fk_telefono_gerente FOREIGN KEY ("CURP")
        REFERENCES "Gerente" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoCajero"
    ADD CONSTRAINT fk_correo_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoCajero"
    ADD CONSTRAINT fk_telefono_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoEncargado"
    ADD CONSTRAINT fk_correo_encargado FOREIGN KEY ("CURP")
        REFERENCES "Encargado de premios" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoEncargado"
    ADD CONSTRAINT fk_telefono_encargado FOREIGN KEY ("CURP")
        REFERENCES "Encargado de premios" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoTécnico"
    ADD CONSTRAINT fk_correo_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoTécnivo"
    ADD CONSTRAINT fk_telefono_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;
