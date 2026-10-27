-- Práctica 05 | Sucursales y operaciones
-- Responsable: Yahir
-- Tablas asignadas: Sucursal, HorarioSucursal, Visita, Recarga
-- Definir mediante ALTER TABLE las PRIMARY KEY simples o compuestas y las restricciones UNIQUE.

ALTER TABLE "SUCURSAL"
    ADD CONSTRAINT pk_sucursal PRIMARY KEY ("idSucursal");

ALTER TABLE "HORARIO_SUCURSAL"
    ADD CONSTRAINT pk_horario_sucursal PRIMARY KEY ("idSucursal", "horario");

ALTER TABLE "VISITA"
    ADD CONSTRAINT pk_visita PRIMARY KEY ("idCliente", "numeroTarjeta", "idSucursal", "idVisita");

ALTER TABLE "RECARGA"
    ADD CONSTRAINT pk_recarga PRIMARY KEY ("idCliente", "numeroTarjeta", "idSucursal", "idRecarga", "CURP");
