-- Módulo 04 | Responsable: Yahir
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Completar decisiones.csv y justificar cada acción antes de implementar.
-- Usar ALTER TABLE DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre.
-- Escribir ON DELETE y ON UPDATE explícitos. Ejecutar dentro de una transacción.
-- Esta plantilla no cambia ninguna FK.

BEGIN;

-- El horario es dependiente de la sucursal: forma parte de su clave primaria y
-- no tiene sentido sin ella. Eliminar la sucursal elimina sus horarios; una
-- corrección del identificador se propaga a la PK compuesta del hijo.
ALTER TABLE "HORARIO_SUCURSAL" DROP CONSTRAINT fk_horario_sucursal;
ALTER TABLE "HORARIO_SUCURSAL" ADD CONSTRAINT fk_horario_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- La visita registra el uso de la tarjeta: es historial y no debe perderse.
-- Se impide eliminar una tarjeta con visitas; una corrección de la pareja de
-- identificadores se propaga a la PK compuesta de la visita.
ALTER TABLE "VISITA" DROP CONSTRAINT fk_visita_tarjeta;
ALTER TABLE "VISITA" ADD CONSTRAINT fk_visita_tarjeta
    FOREIGN KEY ("idCliente", "numeroTarjeta")
    REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- La visita conserva el registro por sucursal: se impide eliminar una sucursal
-- con visitas asociadas y se propagan correcciones del identificador a la PK
-- compuesta del hijo.
ALTER TABLE "VISITA" DROP CONSTRAINT fk_visita_sucursal;
ALTER TABLE "VISITA" ADD CONSTRAINT fk_visita_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- La recarga es un movimiento monetario: no debe perderse.
-- Se protege el historial financiero ante el borrado de la tarjeta; una
-- corrección de la pareja de identificadores se propaga a la PK compuesta.
ALTER TABLE "RECARGA" DROP CONSTRAINT fk_recarga_tarjeta;
ALTER TABLE "RECARGA" ADD CONSTRAINT fk_recarga_tarjeta
    FOREIGN KEY ("idCliente", "numeroTarjeta")
    REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- Se preserva el historial de recargas por sucursal. Se impide eliminar una
-- sucursal con recargas asociadas y se propagan correcciones del identificador
-- a la PK compuesta del hijo.
ALTER TABLE "RECARGA" DROP CONSTRAINT fk_recarga_sucursal;
ALTER TABLE "RECARGA" ADD CONSTRAINT fk_recarga_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- La recarga documenta quién procesó el cobro. Se impide eliminar un cajero con
-- recargas asociadas y se propagan correcciones de CURP a la PK compuesta.
ALTER TABLE "RECARGA" DROP CONSTRAINT fk_recarga_cajero;
ALTER TABLE "RECARGA" ADD CONSTRAINT fk_recarga_cajero
    FOREIGN KEY ("CURP")
    REFERENCES "Cajero" ("CURP")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

COMMIT;
