-- Práctica 05 | Omar | Modelo: Practica04.drawio.xml proporcionado.
-- Todas las columnas obligatorias; no se definen valores predeterminados.

ALTER TABLE "Premio"
    ALTER COLUMN "idPremio" SET NOT NULL,
    ALTER COLUMN "valorAproximado" SET NOT NULL,
    ALTER COLUMN "puntosNecesarios" SET NOT NULL,
    ALTER COLUMN "nombre" SET NOT NULL,
    ALTER COLUMN "categoría" SET NOT NULL,
    ALTER COLUMN "rangoEdad" SET NOT NULL,
    ADD CONSTRAINT ck_premio_id CHECK ("idPremio" > 0),
    ADD CONSTRAINT ck_premio_valor CHECK ("valorAproximado" >= 0),
    ADD CONSTRAINT ck_premio_puntos CHECK ("puntosNecesarios" > 0),
    ADD CONSTRAINT ck_premio_nombre CHECK ("nombre" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_premio_categoria CHECK ("categoría" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_premio_edad CHECK ("rangoEdad" ~ '[^[:space:]]');

ALTER TABLE "Canje"
    ALTER COLUMN "idCanje" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "idPremio" SET NOT NULL,
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "hora" SET NOT NULL,
    ALTER COLUMN "puntosUtilizados" SET NOT NULL,
    ALTER COLUMN "cantidadPremios" SET NOT NULL,
    ALTER COLUMN "fecha" SET NOT NULL,
    ADD CONSTRAINT ck_canje_id CHECK ("idCanje" > 0),
    ADD CONSTRAINT ck_canje_sucursal CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_canje_cliente CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_canje_premio CHECK ("idPremio" > 0),
    ADD CONSTRAINT ck_canje_curp CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ck_canje_puntos CHECK ("puntosUtilizados" > 0),
    ADD CONSTRAINT ck_canje_cantidad CHECK ("cantidadPremios" > 0),
    ADD CONSTRAINT ck_canje_fecha CHECK (isfinite("fecha"));

ALTER TABLE "Disponer"
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "idPremio" SET NOT NULL,
    ALTER COLUMN "cantidadDisponible" SET NOT NULL,
    ADD CONSTRAINT ck_disponer_sucursal CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_disponer_premio CHECK ("idPremio" > 0),
    ADD CONSTRAINT ck_disponer_cantidad CHECK ("cantidadDisponible" >= 0);
