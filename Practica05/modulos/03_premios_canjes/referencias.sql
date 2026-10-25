-- Práctica 05 | Omar | Modelo: Practica04.drawio.xml proporcionado.
-- Ejecutar después de todas las tablas y claves. NO ACTION evita huérfanos.

ALTER TABLE "Canje"
    ADD CONSTRAINT fk_canje_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_canje_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_canje_premio FOREIGN KEY ("idPremio")
        REFERENCES "Premio" ("idPremio")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_canje_encargado FOREIGN KEY ("CURP")
        REFERENCES "Encargado de premios" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Disponer"
    ADD CONSTRAINT fk_disponer_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_disponer_premio FOREIGN KEY ("idPremio")
        REFERENCES "Premio" ("idPremio")
        ON UPDATE NO ACTION ON DELETE NO ACTION;
