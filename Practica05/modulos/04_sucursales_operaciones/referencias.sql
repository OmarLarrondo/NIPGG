-- Práctica 05 | Sucursales y operaciones
-- Responsable: Yahir
-- Tablas asignadas: Sucursal, HorarioSucursal, Visita, Recarga
-- Definir mediante ALTER TABLE las FOREIGN KEY de las tablas de este módulo; acordar nombre, tipo y clave destino con su responsable.

ALTER TABLE "HORARIO_SUCURSAL"
    ADD CONSTRAINT fk_horario_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "VISITA"
    ADD CONSTRAINT fk_visita_tarjeta FOREIGN KEY ("idCliente", "numeroTarjeta")
        REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_visita_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "RECARGA"
    ADD CONSTRAINT fk_recarga_tarjeta FOREIGN KEY ("idCliente", "numeroTarjeta")
        REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_recarga_sucursal FOREIGN KEY ("idSucursal")
        REFERENCES "SUCURSAL" ("idSucursal")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_recarga_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;