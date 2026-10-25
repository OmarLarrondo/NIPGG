-- NO ejecutar hasta integrar el módulo 02 y sus claves.
-- Fuente: modulos/01_clientes_contactos/referencias.sql
ALTER TABLE "Partida"
ADD CONSTRAINT fk_partida_maquina FOREIGN KEY ("idMaquina")
        REFERENCES "Máquina" ("idMaquina")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Fuente: modulos/01_clientes_contactos/referencias.sql
ALTER TABLE "CorreoElectrónicoTécnico"
ADD CONSTRAINT fk_correo_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Fuente: modulos/01_clientes_contactos/referencias.sql
ALTER TABLE "TeléfonoTécnivo"
ADD CONSTRAINT fk_telefono_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;
