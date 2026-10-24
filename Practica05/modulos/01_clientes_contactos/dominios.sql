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
ALTER TABLE "correoElectrónico"
    ALTER COLUMN "idCliente" SET NOT NULL,
    ALTER COLUMN "correoElectrónico" SET NOT NULL,
    ADD CONSTRAINT ck_correo_cliente_id CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_correo_cliente_direccion
        CHECK ("correoElectrónico" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "teléfono"
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
    ALTER COLUMN "numeroTarjeta" SET NOT NULL,
    ALTER COLUMN "idMaquina" SET NOT NULL,
    ALTER COLUMN "idPartida" SET NOT NULL,
    ALTER COLUMN "fecha" SET NOT NULL,
    ALTER COLUMN "hora" SET NOT NULL,
    ALTER COLUMN "puntosGanados" SET NOT NULL,
    ALTER COLUMN "puntajeObtenido" SET NOT NULL,
    ADD CONSTRAINT ck_partida_cliente CHECK ("idCliente" > 0),
    ADD CONSTRAINT ck_partida_numero_tarjeta CHECK ("numeroTarjeta" > 0),
    ADD CONSTRAINT ck_partida_maquina CHECK ("idMaquina" > 0),
    ADD CONSTRAINT ck_partida_id CHECK ("idPartida" > 0),
    ADD CONSTRAINT ck_partida_fecha CHECK (isfinite("fecha")),
    ADD CONSTRAINT ck_partida_puntos CHECK ("puntosGanados" >= 0),
    ADD CONSTRAINT ck_partida_puntaje CHECK ("puntajeObtenido" >= 0);

-- Cada CURP debe existir en el puesto correspondiente; el dominio se hereda por FK.
ALTER TABLE "CorreoElectrónicoGerente"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "correoGerente" SET NOT NULL,
    ADD CONSTRAINT ck_correo_gerente_formato
        CHECK ("correoGerente" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "TeléfonoGerente"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "telefonoGerente" SET NOT NULL,
    ADD CONSTRAINT ck_telefono_gerente_formato
        CHECK ("telefonoGerente" ~ '^[0-9]{10}$');

ALTER TABLE "CorreoElectrónicoCajero"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "correoCajero" SET NOT NULL,
    ADD CONSTRAINT ck_correo_cajero_formato
        CHECK ("correoCajero" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "TeléfonoCajero"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "telefonoCajero" SET NOT NULL,
    ADD CONSTRAINT ck_telefono_cajero_formato
        CHECK ("telefonoCajero" ~ '^[0-9]{10}$');

ALTER TABLE "CorreoElectrónicoEncargado"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "correoEncargado" SET NOT NULL,
    ADD CONSTRAINT ck_correo_encargado_formato
        CHECK ("correoEncargado" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "TeléfonoEncargado"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "telefonoEncargado" SET NOT NULL,
    ADD CONSTRAINT ck_telefono_encargado_formato
        CHECK ("telefonoEncargado" ~ '^[0-9]{10}$');

ALTER TABLE "CorreoElectrónicoTécnico"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "correoTécnico" SET NOT NULL,
    ADD CONSTRAINT ck_correo_tecnico_formato
        CHECK ("correoTécnico" ~ '^[^[:space:]@]+@[^[:space:]@]+$');

ALTER TABLE "TeléfonoTécnivo"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "telefonoTécnico" SET NOT NULL,
    ADD CONSTRAINT ck_telefono_tecnico_formato
        CHECK ("telefonoTécnico" ~ '^[0-9]{10}$');
