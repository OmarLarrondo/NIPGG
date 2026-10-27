-- Práctica 05 · Equipo ÑIPGG
-- PostgreSQL 18. Ejecutar en una base vacía.
-- Restricciones mediante ALTER TABLE; ensamblado autónomo.


-- FUENTE: modulos/01_clientes_contactos/tablas.sql
-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Fuente de estructura: Practica04/Diagramas/RelacionalÑIPGG.drawio.
-- Se conservan nombres, columnas y llaves del diagrama relacional entregado.
-- Los contactos de personal apuntan directamente a cada puesto (criterio de Diego).
-- Las comillas conservan mayúsculas, acentos y espacios del modelo.
-- Todas las restricciones se agregan por separado mediante ALTER TABLE.

CREATE TABLE "Cliente" (
    "idCliente" integer,
    "fechaNacimiento" date,
    "nombre" varchar(50),
    "apellidoMaterno" varchar(50),
    "apellidoPaterno" varchar(50),
    "sexo" varchar(50)
);

CREATE TABLE "correoElectrónico" (
    "idCliente" integer,
    "correoElectrónico" varchar(100)
);

CREATE TABLE "teléfono" (
    "idCliente" integer,
    "teléfono" char(10)
);

CREATE TABLE "Tarjeta" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "CURP" char(18),
    "costoAdquisición" integer,
    "fechaCompra" date,
    "saldo" integer,
    "estado" varchar(50),
    "puntosAcumulados" integer
);

CREATE TABLE "Partida" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "idMaquina" integer,
    "idPartida" integer,
    "fecha" date,
    "puntosGanados" integer,
    "hora" timetz,
    "puntajeObtenido" integer
);

CREATE TABLE "CorreoElectrónicoGerente" (
    "CURP" char(18),
    "correoGerente" varchar(50)
);

CREATE TABLE "TeléfonoGerente" (
    "CURP" char(18),
    "telefonoGerente" char(10)
);

CREATE TABLE "CorreoElectrónicoCajero" (
    "CURP" char(18),
    "correoCajero" varchar(50)
);

CREATE TABLE "TeléfonoCajero" (
    "CURP" char(18),
    "telefonoCajero" char(10)
);

CREATE TABLE "CorreoElectrónicoEncargado" (
    "CURP" char(18),
    "correoEncargado" varchar(50)
);

CREATE TABLE "TeléfonoEncargado" (
    "CURP" char(18),
    "telefonoEncargado" char(10)
);

CREATE TABLE "CorreoElectrónicoTécnico" (
    "CURP" char(18),
    "correoTécnico" varchar(50)
);

-- El diagrama rotula "TeléfonoTécnivo" con v; se conserva el nombre literal.
CREATE TABLE "TeléfonoTécnivo" (
    "CURP" char(18),
    "telefonoTécnico" char(10)
);


-- FUENTE: modulos/02_juegos_maquinas_tecnicos/tablas.sql
-- Práctica 05 | Juegos, máquinas y técnicos
-- Estructura literal de Diagramas/RelacionalÑIPGG.drawio.
-- Las restricciones se agregan mediante ALTER TABLE.

CREATE TABLE "tipoDeJuego" (
    "idTipo" integer,
    "reglaPuntuacion" text,
    "condicion" text,
    "nombre" varchar(50)
);

CREATE TABLE "Juego" (
    "idJuego" integer,
    "costo" integer,
    "nombre" varchar(50),
    "idTipo" integer
);

CREATE TABLE "Máquina" (
    "idMaquina" integer,
    "estado" varchar(50),
    "idJuego" integer,
    "idSucursal" integer
);

CREATE TABLE "Mantenimiento" (
    "idMaquina" integer,
    "idMantenimiento" integer,
    "fecha" date,
    "descripcionProblema" text,
    "tipoMantenimiento" varchar(50),
    "CURP" char(18)
);

CREATE TABLE "Técnico" (
    "CURP" char(18),
    "idSucursal" integer,
    "Nombre" varchar(100),
    "ApellidoMaterno" varchar(100),
    "ApellidoPaterno" varchar(100),
    "RFC" char(13),
    "fechaContratación" date,
    "salario" numeric(10,2),
    "fechaNacimiento" date,
    "áreaEspecialidad" varchar(100)
);

CREATE TABLE "Certificaciones" (
    "CURP" char(18),
    "Certificaciones" varchar(80)
);


-- FUENTE: modulos/03_premios_canjes/tablas.sql
-- Práctica 05 | Omar | Modelo: Practica04.drawio.xml proporcionado.
-- Restricciones separadas mediante ALTER TABLE.

CREATE TABLE "Premio" (
    "idPremio" integer,
    "valorAproximado" integer,
    "puntosNecesarios" integer,
    "nombre" varchar(50),
    "categoría" varchar(50),
    "rangoEdad" varchar(50)
);

CREATE TABLE "Canje" (
    "idCanje" integer,
    "idSucursal" integer,
    "idCliente" integer,
    "idPremio" integer,
    "CURP" char(18),
    "hora" time,
    "puntosUtilizados" integer,
    "cantidadPremios" integer,
    "fecha" date
);

CREATE TABLE "Disponer" (
    "idSucursal" integer,
    "idPremio" integer,
    "cantidadDisponible" integer
);


-- FUENTE: modulos/04_sucursales_operaciones/tablas.sql
-- Práctica 05 | Sucursales y operaciones
-- Responsable: Yahir
-- Tablas asignadas: Sucursal, HorarioSucursal, Visita, Recarga
-- Definir únicamente las tablas, columnas y tipos mediante CREATE TABLE. Las restricciones se escriben en los otros archivos mediante ALTER TABLE.
-- Las comillas conservan mayúsculas, acentos y espacios del modelo.
-- Conserve los nombres en mayúsculas, acentos y espacios del modelo.

CREATE TABLE "SUCURSAL" (
    "idSucursal" integer,
    "nombre" varchar(50),
    "teléfono" char(10),
    "calle" varchar(100),
    "númeroExterior" integer,
    "númeroInterior" integer,
    "colonia" varchar(50),
    "estado" varchar(50)
);

CREATE TABLE "HORARIO_SUCURSAL" (
    "idSucursal" integer,
    "horario" varchar(50)
);

CREATE TABLE "VISITA" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "idSucursal" integer,
    "idVisita" integer,
    "fecha" date
);

CREATE TABLE "RECARGA" (
    "idCliente" integer,
    "numeroTarjeta" integer,
    "idSucursal" integer,
    "idRecarga" integer,
    "CURP" char(18),
    "monto" integer,
    "fecha" date,
    "hora" timetz,
    "métodoAbono" varchar(50)
);


-- FUENTE: modulos/05_personal_administracion/tablas.sql
-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas: "Genrente", "Cajero", "Encargado de premios", "Administrar"
-- Definir únicamente las tablas, columnas y tipos mediante CREATE TABLE. Las restricciones se escriben en los otros archivos mediante ALTER TABLE.

-- 1. "Genrente"
CREATE TABLE "Genrente" (
    "CURP" CHAR(18),
    "idSucursal" INT,
    "Nombre" VARCHAR(100),
    "ApellidoMaterno" VARCHAR(100),
    "ApellidoPaterno" VARCHAR(100),
    "RFC" CHAR(13),
    "fechaContratación" DATE,
    "salario" NUMERIC(10,2),
    "fechaNacimiento" DATE,
    "cédulaProfesional" VARCHAR(8)
);

-- 2. "Cajero"
CREATE TABLE "Cajero" (
    "CURP" CHAR(18),
    "idSucursal" INT,
    "Nombre" VARCHAR(100),
    "ApellidoMaterno" VARCHAR(100),
    "ApellidoPaterno" VARCHAR(100),
    "RFC" CHAR(13),
    "fechaContratación" DATE,
    "salario" NUMERIC(10,2),
    "fechaNacimiento" DATE,
    "horarioTrabajo" TIME
);

-- 3. "Encargado de premios"
CREATE TABLE "Encargado de premios" (
    "CURP" CHAR(18),
    "idSucursal" INT,
    "Nombre" VARCHAR(100),
    "ApellidoMaterno" VARCHAR(100),
    "ApellidoPaterno" VARCHAR(100),
    "RFC" CHAR(13),
    "fechaContratación" DATE,
    "salario" NUMERIC(10,2),
    "fechaNacimiento" DATE,
    "horarioTrabajo" TIME
);

-- 4. "Administrar"
CREATE TABLE "Administrar" (
    "CURP" CHAR(18),
    "idSucursal" INT
);


-- FUENTE: modulos/01_clientes_contactos/dominios.sql
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


-- FUENTE: modulos/02_juegos_maquinas_tecnicos/dominios.sql
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


-- FUENTE: modulos/03_premios_canjes/dominios.sql
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


-- FUENTE: modulos/04_sucursales_operaciones/dominios.sql
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


-- FUENTE: modulos/05_personal_administracion/dominios.sql
-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas: "Genrente", "Cajero", "Encargado de premios", "Administrar"
-- Definir mediante ALTER TABLE la nulabilidad, CHECK y valores predeterminados que correspondan al modelo acordado.

-- 1. "Genrente"
ALTER TABLE "Genrente"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "Nombre" SET NOT NULL,
    ALTER COLUMN "ApellidoMaterno" SET NOT NULL,
    ALTER COLUMN "ApellidoPaterno" SET NOT NULL,
    ALTER COLUMN "RFC" SET NOT NULL,
    ALTER COLUMN "fechaContratación" SET NOT NULL,
    ALTER COLUMN "salario" SET NOT NULL,
    ALTER COLUMN "fechaNacimiento" SET NOT NULL,
    ALTER COLUMN "cédulaProfesional" SET NOT NULL;

ALTER TABLE "Genrente"
    ADD CONSTRAINT ckgerentecurp
        CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ckgerenteidsucursalpositivo
        CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ckgerentenombrenovacio
        CHECK (length(btrim("Nombre")) > 0),
    ADD CONSTRAINT ckgerenteapellidomaternonovacio
        CHECK (length(btrim("ApellidoMaterno")) > 0),
    ADD CONSTRAINT ckgerenteapellidopaternonovacio
        CHECK (length(btrim("ApellidoPaterno")) > 0),
    ADD CONSTRAINT ckgerenterfc
        CHECK ("RFC" ~ '^[A-Z&Ñ]{3,4}[0-9]{6}[A-V1-9][A-Z0-9][0-9A]$'),
    ADD CONSTRAINT ckgerentesalariononegativo
        CHECK ("salario" >= 0 AND "salario" <> 'NaN'::numeric),
    ADD CONSTRAINT ckgerentefechacontrataciónfutura
        CHECK (isfinite("fechaContratación") AND "fechaContratación" <= CURRENT_DATE),
    ADD CONSTRAINT ckgerentefechanacimientonofutura
        CHECK (isfinite("fechaNacimiento") AND "fechaNacimiento" <= CURRENT_DATE),
    ADD CONSTRAINT ckgerentecedulaprofesional
        CHECK ("cédulaProfesional" ~ '^[0-9]{7,8}$');

-- 2. "Cajero"
ALTER TABLE "Cajero"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "Nombre" SET NOT NULL,
    ALTER COLUMN "ApellidoMaterno" SET NOT NULL,
    ALTER COLUMN "ApellidoPaterno" SET NOT NULL,
    ALTER COLUMN "RFC" SET NOT NULL,
    ALTER COLUMN "fechaContratación" SET NOT NULL,
    ALTER COLUMN "salario" SET NOT NULL,
    ALTER COLUMN "fechaNacimiento" SET NOT NULL,
    ALTER COLUMN "horarioTrabajo" SET NOT NULL;

ALTER TABLE "Cajero"
    ADD CONSTRAINT ckcajerocurp
        CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ckcajeroidsucursalpositivo
        CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ckcajeronombrenovacio
        CHECK (length(btrim("Nombre")) > 0),
    ADD CONSTRAINT ckcajeroapellidomaternonovacio
        CHECK (length(btrim("ApellidoMaterno")) > 0),
    ADD CONSTRAINT ckcajeroapellidopaternonovacio
        CHECK (length(btrim("ApellidoPaterno")) > 0),
    ADD CONSTRAINT ck_ajerorfc
        CHECK ("RFC" ~ '^[A-Z&Ñ]{3,4}[0-9]{6}[A-V1-9][A-Z0-9][0-9A]$'),
    ADD CONSTRAINT ckcajerosalariononegativo
        CHECK ("salario" >= 0 AND "salario" <> 'NaN'::numeric),
    ADD CONSTRAINT ckgerentefechacontrataciónfutura
        CHECK (isfinite("fechaContratación") AND "fechaContratación" <= CURRENT_DATE),
    ADD CONSTRAINT ckcajero_echanacimientonofutura
        CHECK (isfinite("fechaNacimiento") AND "fechaNacimiento" <= CURRENT_DATE),
    ADD CONSTRAINT ckcajerohorariotrabajo
        CHECK ("horarioTrabajo" IN (TIME '07:00:00', TIME '15:00:00'));

-- 3. "Encargado de premios"
ALTER TABLE "Encargado de premios"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL,
    ALTER COLUMN "Nombre" SET NOT NULL,
    ALTER COLUMN "ApellidoMaterno" SET NOT NULL,
    ALTER COLUMN "ApellidoPaterno" SET NOT NULL,
    ALTER COLUMN "RFC" SET NOT NULL,
    ALTER COLUMN "fechaContratación" SET NOT NULL,
    ALTER COLUMN "salario" SET NOT NULL,
    ALTER COLUMN "fechaNacimiento" SET NOT NULL,
    ALTER COLUMN "horarioTrabajo" SET NOT NULL;

ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT ckencargadopremioscurp
        CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ckencargadopremiosidsucursalpositivo
        CHECK ("idSucursal" > 0),
    ADD CONSTRAINT ckencargadopremiosnombrenovacio
        CHECK (length(btrim("Nombre")) > 0),
    ADD CONSTRAINT ckencargadopremiosapellidomaternonovacio
        CHECK (length(btrim("ApellidoMaterno")) > 0),
    ADD CONSTRAINT ckencargadopremios_pellidopaternonovacio
        CHECK (length(btrim("ApellidoPaterno")) > 0),
    ADD CONSTRAINT ckencargadopremiosrfc
        CHECK ("RFC" ~ '^[A-Z&Ñ]{3,4}[0-9]{6}[A-V1-9][A-Z0-9][0-9A]$'),
    ADD CONSTRAINT ckencargadopremiossalariononegativo
        CHECK ("salario" >= 0 AND "salario" <> 'NaN'::numeric),
    ADD CONSTRAINT ckencargadopremiosfechacontrataciónfutura
        CHECK (isfinite("fechaContratación") AND "fechaContratación" <= CURRENT_DATE),
    ADD CONSTRAINT ck_ncargadopremiosfechanacimientonofutura
        CHECK (isfinite("fechaNacimiento") AND "fechaNacimiento" <= CURRENT_DATE),
    ADD CONSTRAINT ckencargadopremioshorariotrabajo
        CHECK ("horarioTrabajo" IN (TIME '07:00:00', TIME '15:00:00'));

-- 4. "Administrar"
ALTER TABLE "Administrar"
    ALTER COLUMN "CURP" SET NOT NULL,
    ALTER COLUMN "idSucursal" SET NOT NULL;

ALTER TABLE "Administrar"
    ADD CONSTRAINT ck_administrar_curp
        CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$'),
    ADD CONSTRAINT ck_administrar_idsucursal_positivo
        CHECK ("idSucursal" > 0);


-- FUENTE: modulos/01_clientes_contactos/claves.sql
-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Llaves primarias tomadas de las marcas PK del diagrama relacional.

ALTER TABLE "Cliente"
    ADD CONSTRAINT pk_cliente PRIMARY KEY ("idCliente");

ALTER TABLE "correoElectrónico"
    ADD CONSTRAINT pk_correo_cliente PRIMARY KEY ("idCliente", "correoElectrónico");

ALTER TABLE "teléfono"
    ADD CONSTRAINT pk_telefono_cliente PRIMARY KEY ("idCliente", "teléfono");

ALTER TABLE "Tarjeta"
    ADD CONSTRAINT pk_tarjeta PRIMARY KEY ("idCliente", "numeroTarjeta");

-- La PK del diagrama es (idCliente, numeroTarjeta).
-- La arista con Cliente es 1:1: UNIQUE(idCliente) impide dos tarjetas por cliente.
ALTER TABLE "Tarjeta"
    ADD CONSTRAINT uq_tarjeta_cliente UNIQUE ("idCliente");

ALTER TABLE "Partida"
    ADD CONSTRAINT pk_partida PRIMARY KEY ("idCliente", "numeroTarjeta", "idMaquina", "idPartida");

ALTER TABLE "CorreoElectrónicoGerente"
    ADD CONSTRAINT pk_correo_gerente PRIMARY KEY ("CURP", "correoGerente");

ALTER TABLE "TeléfonoGerente"
    ADD CONSTRAINT pk_telefono_gerente PRIMARY KEY ("CURP", "telefonoGerente");

ALTER TABLE "CorreoElectrónicoCajero"
    ADD CONSTRAINT pk_correo_cajero PRIMARY KEY ("CURP", "correoCajero");

ALTER TABLE "TeléfonoCajero"
    ADD CONSTRAINT pk_telefono_cajero PRIMARY KEY ("CURP", "telefonoCajero");

ALTER TABLE "CorreoElectrónicoEncargado"
    ADD CONSTRAINT pk_correo_encargado PRIMARY KEY ("CURP", "correoEncargado");

ALTER TABLE "TeléfonoEncargado"
    ADD CONSTRAINT pk_telefono_encargado PRIMARY KEY ("CURP", "telefonoEncargado");

ALTER TABLE "CorreoElectrónicoTécnico"
    ADD CONSTRAINT pk_correo_tecnico PRIMARY KEY ("CURP", "correoTécnico");

ALTER TABLE "TeléfonoTécnivo"
    ADD CONSTRAINT pk_telefono_tecnico PRIMARY KEY ("CURP", "telefonoTécnico");

-- Los contactos son únicos por propietario; no se impone unicidad global
-- a correos, teléfonos, numeroTarjeta ni al discriminante idPartida.


-- FUENTE: modulos/02_juegos_maquinas_tecnicos/claves.sql
-- Práctica 05 | Claves del modelo relacional.

ALTER TABLE "tipoDeJuego"
    ADD CONSTRAINT pk_tipo_juego PRIMARY KEY ("idTipo");

ALTER TABLE "Juego"
    ADD CONSTRAINT pk_juego PRIMARY KEY ("idJuego");

ALTER TABLE "Máquina"
    ADD CONSTRAINT pk_maquina PRIMARY KEY ("idMaquina");

ALTER TABLE "Mantenimiento"
    ADD CONSTRAINT pk_mantenimiento PRIMARY KEY ("idMaquina", "idMantenimiento");

ALTER TABLE "Técnico"
    ADD CONSTRAINT pk_tecnico PRIMARY KEY ("CURP");

ALTER TABLE "Certificaciones"
    ADD CONSTRAINT pk_certificacion_tecnico PRIMARY KEY ("CURP", "Certificaciones");


-- FUENTE: modulos/03_premios_canjes/claves.sql
-- Práctica 05 | Omar | Modelo: Practica04.drawio.xml proporcionado.
-- Canje: el diagrama marca solamente idCanje como PK.
-- Disponer: una fila por pareja sucursal-premio de la relación M:N.
ALTER TABLE "Premio"
    ADD CONSTRAINT pk_premio PRIMARY KEY ("idPremio");
ALTER TABLE "Canje"
    ADD CONSTRAINT pk_canje PRIMARY KEY ("idCanje");
ALTER TABLE "Disponer"
    ADD CONSTRAINT pk_disponer PRIMARY KEY ("idSucursal", "idPremio");
-- No se agrega UNIQUE a nombres ni a las FK de Canje.


-- FUENTE: modulos/04_sucursales_operaciones/claves.sql
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


-- FUENTE: modulos/05_personal_administracion/claves.sql
-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas: "Genrente", "Cajero", "Encargado de premios", "Administrar"
-- Definir mediante ALTER TABLE las PRIMARY KEY simples o compuestas y las restricciones UNIQUE.

-- 1. "Genrente"
ALTER TABLE "Genrente"
    ADD CONSTRAINT pkgerente PRIMARY KEY ("CURP");

ALTER TABLE "Genrente"
    ADD CONSTRAINT uqgerenterfc UNIQUE ("RFC");

-- 2. "Cajero"
ALTER TABLE "Cajero"
    ADD CONSTRAINT pkcajero PRIMARY KEY ("CURP");

ALTER TABLE "Cajero"
    ADD CONSTRAINT uqcajerorfc UNIQUE ("RFC");

-- 3. "Encargado de premios"
ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT pkencargadodepremios PRIMARY KEY ("CURP");

ALTER TABLE "Encargado de premios"
    ADD CONSTRAINT uqencargadodepremiosrfc UNIQUE ("RFC");

-- 4. "Administrar"
ALTER TABLE "Administrar"
    ADD CONSTRAINT pkadministrar PRIMARY KEY ("CURP", "idSucursal");

ALTER TABLE "Administrar"
    ADD CONSTRAINT uqadministrarsucursal UNIQUE ("idSucursal");

ALTER TABLE "Administrar"
    ADD CONSTRAINT uqadministrargerente UNIQUE ("CURP");


-- FUENTE: modulos/01_clientes_contactos/referencias.sql
-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel
-- Ejecutar después de tablas, dominios y claves de TODOS los módulos.
-- Dependencias verificadas en el contrato técnico final:
-- módulo 02: "Máquina"("idMaquina" integer) y "Técnico"("CURP" char(18));
-- módulo 05: "Genrente", "Cajero" y "Encargado de premios", con "CURP" char(18).
-- Cada columna destino debe tener PK/UNIQUE; se conservan los nombres del diagrama.
-- NO ACTION impide cambios que dejen referencias sin destino.

ALTER TABLE "correoElectrónico"
    ADD CONSTRAINT fk_correo_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "teléfono"
    ADD CONSTRAINT fk_telefono_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Tarjeta"
    ADD CONSTRAINT fk_tarjeta_cliente FOREIGN KEY ("idCliente")
        REFERENCES "Cliente" ("idCliente")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_tarjeta_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "Partida"
    ADD CONSTRAINT fk_partida_tarjeta FOREIGN KEY ("idCliente", "numeroTarjeta")
        REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ADD CONSTRAINT fk_partida_maquina FOREIGN KEY ("idMaquina")
        REFERENCES "Máquina" ("idMaquina")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoGerente"
    ADD CONSTRAINT fk_correo_gerente FOREIGN KEY ("CURP")
        REFERENCES "Genrente" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoGerente"
    ADD CONSTRAINT fk_telefono_gerente FOREIGN KEY ("CURP")
        REFERENCES "Genrente" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoCajero"
    ADD CONSTRAINT fk_correo_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoCajero"
    ADD CONSTRAINT fk_telefono_cajero FOREIGN KEY ("CURP")
        REFERENCES "Cajero" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoEncargado"
    ADD CONSTRAINT fk_correo_encargado FOREIGN KEY ("CURP")
        REFERENCES "Encargado de premios" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoEncargado"
    ADD CONSTRAINT fk_telefono_encargado FOREIGN KEY ("CURP")
        REFERENCES "Encargado de premios" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "CorreoElectrónicoTécnico"
    ADD CONSTRAINT fk_correo_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE "TeléfonoTécnivo"
    ADD CONSTRAINT fk_telefono_tecnico FOREIGN KEY ("CURP")
        REFERENCES "Técnico" ("CURP")
        ON UPDATE NO ACTION ON DELETE NO ACTION;


-- FUENTE: modulos/02_juegos_maquinas_tecnicos/referencias.sql
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


-- FUENTE: modulos/03_premios_canjes/referencias.sql
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


-- FUENTE: modulos/04_sucursales_operaciones/referencias.sql
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


-- FUENTE: modulos/05_personal_administracion/referencias.sql
-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas: "Genrente", "Cajero", "Encargado de premios", "Administrar"
-- Definir mediante ALTER TABLE las FOREIGN KEY de las tablas de este módulo; acordar "Nombre", tipo y clave destino con su responsable.

-- 1. "Genrente" -> Sucursal
ALTER TABLE "Genrente"
	ADD CONSTRAINT fkgerentesucursal
	FOREIGN KEY ("idSucursal")
	REFERENCES "SUCURSAL" ("idSucursal");

-- 2. "Cajero" -> Sucursal
ALTER TABLE "Cajero"
	ADD CONSTRAINT fkcajerosucursal
	FOREIGN KEY ("idSucursal")
	REFERENCES "SUCURSAL" ("idSucursal");

-- 3. "Encargado de premios" -> Sucursal
ALTER TABLE "Encargado de premios"
	ADD CONSTRAINT fkencargadopremiossucursal
	FOREIGN KEY ("idSucursal")
	REFERENCES "SUCURSAL" ("idSucursal");

-- 4. "Administrar" -> "Genrente"
ALTER TABLE "Administrar"
	ADD CONSTRAINT fkadministrargerente
	FOREIGN KEY ("CURP")
	REFERENCES "Genrente" ("CURP");

-- 5. "Administrar" -> Sucursal
ALTER TABLE "Administrar"
	ADD CONSTRAINT fkadministrarsucursal
	FOREIGN KEY ("idSucursal")
	REFERENCES "SUCURSAL" ("idSucursal");
