-- Práctica 05 | Juegos, máquinas y técnicos
-- Responsable: Ana
-- Ejecutar después de tablas, dominios y claves de TODOS los módulos.
-- Dependencias verificadas en el contrato técnico final:
-- módulo 04: "SUCURSAL"("idSucursal" integer);
-- Cada columna destino debe tener PK/UNIQUE; se conservan los nombres del diagrama.
-- NO ACTION impide cambios que dejen referencias sin destino.

ALTER TABLE "Mantenimiento"
    ADD CONSTRAINT fk_mantenimiento_maquina FOREIGN KEY ("idMaquina")
        REFERENCES "Máquina" ("idMaquina")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_mantenimiento_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Máquina"
    ADD CONSTRAINT fk_maquina_juego FOREIGN KEY ("idJuego")
        REFERENCES "Juego" ("idJuego")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_maquina_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Juego"
    ADD CONSTRAINT fk_juego_tipo FOREIGN KEY ("idTipo")
        REFERENCES "tipoDeJuego" ("idTipo")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Técnico"
    ADD CONSTRAINT fk_tecnico_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Certificaciones"
    ADD CONSTRAINT fk_certificacion_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;
