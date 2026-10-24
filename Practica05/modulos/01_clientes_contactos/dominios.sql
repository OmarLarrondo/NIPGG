-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Ejecutar después de tablas.sql. Todas las columnas son obligatorias.
-- No se fijan valores predeterminados ni catálogos ausentes del informe.

ALTER TABLE "Cliente"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "fechaNacimiento" SET NOT NULL,
    ALTER COLUMN "nombre" SET NOT NULL,
    ALTER COLUMN "apellidoMaterno" SET NOT NULL,
    ALTER COLUMN "apellidoPaterno" SET NOT NULL,
    ALTER COLUMN "sexo" SET NOT NULL,
    ADD CONSTRAINT ck_cliente_id CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_cliente_nacimiento
        CHECK (isfinite("fechaNacimiento") AND "fechaNacimiento" <= CURRENT_DATE),
    ADD CONSTRAINT ck_cliente_nombre CHECK ("nombre" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_cliente_apellido_materno CHECK ("apellidoMaterno" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_cliente_apellido_paterno CHECK ("apellidoPaterno" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_cliente_sexo CHECK ("sexo" ~ '[^[:space:]]');

-- Comprobación básica de correo: un @, partes no vacías y sin espacios.
-- No verifica la existencia del buzón ni toda la sintaxis de correo.
ALTER TABLE "CorreoCliente"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "correoElectrónico" SET NOT NULL,
    ADD CONSTRAINT ck_correo_cliente_id CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_correo_cliente_direccion
        CHECK ("correoElectrónico" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "TelefonoCliente"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "teléfono" SET NOT NULL,
    ADD CONSTRAINT ck_telefono_cliente_id CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_telefono_cliente_numero CHECK ("teléfono" ~ '^[0-9]{10}$');

ALTER TABLE "Tarjeta"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "numeroTarjeta" SET NOT NULL,
    ALTER COLUMN "costoAdquisición" SET NOT NULL,
    ALTER COLUMN "fechaCompra" SET NOT NULL,
    ALTER COLUMN "saldo" SET NOT NULL,
    ALTER COLUMN "estado" SET NOT NULL,
    ALTER COLUMN "puntosAcumulados" SET NOT NULL,
    ALTER COLUMN "CURP" SET NOT NULL,
    ADD CONSTRAINT ck_tarjeta_cliente CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_tarjeta_numero CHECK ("numeroTarjeta" > 0),
    ADD CONSTRAINT ck_tarjeta_costo CHECK ("costoAdquisición" >= 0),
    ADD CONSTRAINT ck_tarjeta_fecha_compra CHECK (isfinite("fechaCompra")),
    ADD CONSTRAINT ck_tarjeta_saldo CHECK ("saldo" >= 0),
    ADD CONSTRAINT ck_tarjeta_estado CHECK ("estado" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tarjeta_puntos CHECK ("puntosAcumulados" >= 0);

ALTER TABLE "Partida"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "idMaquina" SET NOT NULL,
    ALTER COLUMN "idPartida" SET NOT NULL,
    ALTER COLUMN "fecha" SET NOT NULL,
    ALTER COLUMN "hora" SET NOT NULL,
    ALTER COLUMN "puntosGanados" SET NOT NULL,
    ALTER COLUMN "puntajeObtenido" SET NOT NULL,
    ADD CONSTRAINT ck_partida_cliente CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_partida_maquina CHECK ("idMaquina" > 0),
    ADD CONSTRAINT ck_partida_id CHECK ("idPartida" > 0),
    ADD CONSTRAINT ck_partida_fecha CHECK (isfinite("fecha")),
    ADD CONSTRAINT ck_partida_puntos CHECK ("puntosGanados" >= 0),
    ADD CONSTRAINT ck_partida_puntaje CHECK ("puntajeObtenido" >= 0);

-- CURP identifica al empleado; su existencia y dominio se heredan por FK.
ALTER TABLE "CorreoEmpleado"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "correoElectrónico" SET NOT NULL,
    ADD CONSTRAINT ck_correo_empleado_direccion
        CHECK ("correoElectrónico" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "TelefonoEmpleado"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "teléfono" SET NOT NULL,
    ADD CONSTRAINT ck_telefono_empleado_numero CHECK ("teléfono" ~ '^[0-9]{10}$');
