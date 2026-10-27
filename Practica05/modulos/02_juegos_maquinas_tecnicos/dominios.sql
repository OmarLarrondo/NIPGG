-- Práctica 05 | Juegos, máquinas y técnicos
-- Responsable: Ana
-- Tablas: tipoDeJuego, Juego, Máquina, Mantenimiento, Técnico, Certificaciones
-- Definir mediante ALTER TABLE la nulabilidad, CHECK y valores predeterminados que correspondan al modelo acordado.
-- Ejecutar después de tablas.sql. Todas las columnas son obligatorias.

ALTER TABLE "tipoDeJuego"
    ALTER COLUMN "idTipo" SET NOT NULL,
    ALTER COLUMN "reglaPuntuacion" SET NOT NULL,
    ALTER COLUMN "condicion" SET NOT NULL,
    ALTER COLUMN "nombre" SET NOT NULL,
    ADD CONSTRAINT ck_tipo_juego_id CHECK ("idTipo" > 0),
    ADD CONSTRAINT ck_tipo_juego_regla CHECK ("reglaPuntuacion" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tipo_juego_condicion CHECK ("condicion" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tipo_juego_nombre CHECK ("nombre" ~ '[^[:space:]]');

ALTER TABLE "Juego"
    ALTER COLUMN "idJuego" SET NOT NULL,
    ALTER COLUMN "idTipo" SET NOT NULL,
    ALTER COLUMN "nombre" SET NOT NULL,
    ALTER COLUMN "costo" SET NOT NULL,
    ADD CONSTRAINT ck_juego_id CHECK ("idJuego" > 0),
    ADD CONSTRAINT ck_juego_tipo CHECK ("idTipo" > 0),
    ADD CONSTRAINT ck_juego_nombre CHECK ("nombre" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_juego_costo CHECK ("costo" >= 0);

ALTER TABLE "Máquina"
    ALTER COLUMN "idMaquina" SET NOT NULL,
    ALTER COLUMN "idJuego" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "estado" SET NOT NULL,
    ADD CONSTRAINT ck_maquina_id CHECK ("idMaquina" > 0),
    ADD CONSTRAINT ck_maquina_juego CHECK ("idJuego" > 0),
    ADD CONSTRAINT ck_maquina_sucursal CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_maquina_estado CHECK ("estado" ~ '[^[:space:]]');

ALTER TABLE "Mantenimiento"
    ALTER COLUMN "idMantenimiento" SET NOT NULL,
    ALTER COLUMN "idMaquina" SET NOT NULL,
    ALTER COLUMN "fecha" SET NOT NULL,
    ALTER COLUMN "descripcionProblema" SET NOT NULL,
    ALTER COLUMN "tipoMantenimiento" SET NOT NULL,
    ALTER COLUMN "CURP" SET NOT NULL,
    ADD CONSTRAINT ck_mantenimiento_id CHECK ("idMantenimiento" > 0),
    ADD CONSTRAINT ck_mantenimiento_maquina CHECK ("idMaquina" > 0),
    ADD CONSTRAINT ck_mantenimiento_fecha CHECK (isfinite("fecha") AND "fecha" <= CURRENT_DATE),
    ADD CONSTRAINT ck_mantenimiento_descripcion CHECK ("descripcionProblema" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_mantenimiento_tipo CHECK ("tipoMantenimiento" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_mantenimiento_curp CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$');

ALTER TABLE "Técnico"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "Nombre" SET NOT NULL,
    ALTER COLUMN "ApellidoMaterno" SET NOT NULL,
    ALTER COLUMN "ApellidoPaterno" SET NOT NULL,
    ALTER COLUMN "RFC" SET NOT NULL,
    ALTER COLUMN "fechaContratación" SET NOT NULL,
    ALTER COLUMN "salario" SET NOT NULL,
    ALTER COLUMN "fechaNacimiento" SET NOT NULL,
    ALTER COLUMN "áreaEspecialidad" SET NOT NULL,
    ADD CONSTRAINT ck_tecnico_curp CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ck_tecnico_sucursal CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ck_tecnico_nombre CHECK ("Nombre" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tecnico_apellido_materno CHECK ("ApellidoMaterno" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tecnico_apellido_paterno CHECK ("ApellidoPaterno" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tecnico_rfc CHECK ("RFC" ~ '^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$'),
    ADD CONSTRAINT ck_tecnico_fecha_contratacion CHECK (isfinite("fechaContratación") AND "fechaContratación" <= CURRENT_DATE),
    ADD CONSTRAINT ck_tecnico_salario CHECK ("salario" >= 0 AND "salario" <> 'NaN'::numeric),
    ADD CONSTRAINT ck_tecnico_especialidad CHECK ("áreaEspecialidad" ~ '[^[:space:]]'),
    ADD CONSTRAINT ck_tecnico_fecha_nacimiento CHECK (isfinite("fechaNacimiento") AND "fechaNacimiento" <= CURRENT_DATE);

ALTER TABLE "Certificaciones"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "Certificaciones" SET NOT NULL,
    ADD CONSTRAINT ck_certificacion_tecnico_curp CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ck_certificacion_tecnico_certificaciones CHECK ("Certificaciones" ~ '[^[:space:]]');
