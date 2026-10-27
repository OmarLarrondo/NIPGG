-- Práctica 05 | Sucursales y operaciones
-- Responsable: Yahir
-- Tablas asignadas: Sucursal, HorarioSucursal, Visita, Recarga
-- Definir mediante ALTER TABLE la nulabilidad, CHECK y valores predeterminados que correspondan al modelo acordado.

ALTER TABLE "SUCURSAL"
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "nombre" SET NOT NULL,
    ALTER COLUMN "teléfono" SET NOT NULL,
    ALTER COLUMN "calle" SET NOT NULL,
    ALTER COLUMN "númeroExterior" SET NOT NULL,
    ALTER COLUMN "númeroInterior" SET NOT NULL,
    ALTER COLUMN "colonia" SET NOT NULL,
    ALTER COLUMN "estado" SET NOT NULL,
    ADD CONSTRAINT ck_sucursal_id CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_sucursal_nombre CHECK ("nombre" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_sucursal_telefono CHECK ("teléfono" ~ '^[0-9]{10}$'),
    ADD CONSTRAINT ck_sucursal_calle CHECK ("calle" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_sucursal_num_ext CHECK ("númeroExterior" >= 0),
    ADD CONSTRAINT ck_sucursal_num_int CHECK ("númeroInterior" >= 0),
    ADD CONSTRAINT ck_sucursal_colonia CHECK ("colonia" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_sucursal_codigo CHECK ("estado" ~ '[^[:space:]]');

ALTER TABLE "HORARIO_SUCURSAL"
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "horario" SET NOT NULL,
    ADD CONSTRAINT ck_horario_sucursal_id CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_horario_sucursal_texto CHECK ("horario" ~ '[^[:space:]]');

ALTER TABLE "VISITA"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "numeroTarjeta" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "idVisita" SET NOT NULL,
    ALTER COLUMN "fecha" SET NOT NULL,
    ADD CONSTRAINT ck_visita_cliente CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_visita_tarjeta CHECK ("numeroTarjeta" > 0),
    ADD CONSTRAINT ck_visita_sucursal CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_visita_id CHECK ("idVisita" > 0),
    ADD CONSTRAINT ck_visita_fecha CHECK (isfinite("fecha"));

ALTER TABLE "RECARGA"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "numeroTarjeta" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "idRecarga" SET NOT NULL,
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "monto" SET NOT NULL,
    ALTER COLUMN "fecha" SET NOT NULL,
    ALTER COLUMN "hora" SET NOT NULL,
    ALTER COLUMN "métodoAbono" SET NOT NULL,
    ADD CONSTRAINT ck_recarga_cliente CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_recarga_tarjeta CHECK ("numeroTarjeta" > 0),
    ADD CONSTRAINT ck_recarga_sucursal CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_recarga_id CHECK ("idRecarga" > 0),
    ADD CONSTRAINT ck_recarga_curp CHECK ("CURP" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_recarga_monto CHECK ("monto" >= 0),
    ADD CONSTRAINT ck_recarga_fecha CHECK (isfinite("fecha")),
    ADD CONSTRAINT ck_recarga_metodo CHECK ("métodoAbono" ~ '[^[:space:]]');
