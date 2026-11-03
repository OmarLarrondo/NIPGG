-- Práctica 06 | Módulo 02 | Miguel Ángel Jiménez Ramírez
-- PostgreSQL 18. Aplicar después de todas las sustituciones de FK.
BEGIN;

COMMENT ON TABLE "tipoDeJuego" IS 'Catálogo de tipos que clasifica los juegos y describe sus reglas de puntuación y condiciones.';
COMMENT ON COLUMN "tipoDeJuego"."idTipo" IS 'Identificador positivo del tipo de juego; clave primaria. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "tipoDeJuego"."reglaPuntuacion" IS 'Regla de puntuación del tipo; texto con al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "tipoDeJuego"."condicion" IS 'Condición del tipo de juego; texto con al menos un carácter no blanco, sin imponer un catálogo adicional. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "tipoDeJuego"."nombre" IS 'Nombre del tipo de juego; no puede estar compuesto solo por espacios. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "Juego" IS 'Catálogo de juegos disponibles; cada juego pertenece a un tipo y puede ser usado por varias máquinas.';
COMMENT ON COLUMN "Juego"."idJuego" IS 'Identificador positivo del juego; clave primaria. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Juego"."costo" IS 'Costo del juego expresado como entero no negativo; el DDL no fija una moneda. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Juego"."nombre" IS 'Nombre del juego; debe contener al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Juego"."idTipo" IS 'Tipo de juego existente que clasifica este juego; identificador positivo. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "Máquina" IS 'Equipo de juego asignado a una sucursal; conserva su identidad para partidas y mantenimientos.';
COMMENT ON COLUMN "Máquina"."idMaquina" IS 'Identificador positivo de la máquina; clave primaria referenciada por Partida y Mantenimiento. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Máquina"."estado" IS 'Estado operativo del equipo; texto no blanco sin catálogo cerrado en el DDL. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Máquina"."idJuego" IS 'Juego existente instalado o asociado al equipo; identificador positivo. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Máquina"."idSucursal" IS 'Sucursal existente a la que se asigna el equipo; identificador positivo. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "Mantenimiento" IS 'Historial de intervenciones sobre máquinas, con su fecha, problema, tipo y técnico responsable.';
COMMENT ON COLUMN "Mantenimiento"."idMaquina" IS 'Máquina atendida; identificador positivo y componente de la clave primaria. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Mantenimiento"."idMantenimiento" IS 'Discriminante positivo del mantenimiento dentro de una máquina; completa la PK compuesta. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Mantenimiento"."fecha" IS 'Fecha finita del mantenimiento; no puede ser posterior a CURRENT_DATE al validar la fila. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Mantenimiento"."descripcionProblema" IS 'Descripción del problema atendido; texto con al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Mantenimiento"."tipoMantenimiento" IS 'Tipo de intervención; texto no blanco sin catálogo adicional. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Mantenimiento"."CURP" IS 'CURP del técnico responsable; 18 caracteres sujetos al patrón del DDL y a referencia obligatoria. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "Técnico" IS 'Personal técnico asignado a una sucursal; registra identidad, contratación, salario y especialidad.';
COMMENT ON COLUMN "Técnico"."CURP" IS 'Identificador del técnico; clave primaria de 18 caracteres con el patrón declarado, que no valida una CURP oficial. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."idSucursal" IS 'Sucursal existente de asignación del técnico; identificador positivo. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."Nombre" IS 'Nombre del técnico; debe contener al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."ApellidoMaterno" IS 'Apellido materno; debe contener al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."ApellidoPaterno" IS 'Apellido paterno; debe contener al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."RFC" IS 'RFC de 13 caracteres sujeto al patrón declarado; no valida su existencia fiscal. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."fechaContratación" IS 'Fecha finita de contratación; no puede ser posterior a CURRENT_DATE al validar la fila. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."salario" IS 'Salario numérico no negativo y distinto de NaN; el DDL no define periodicidad. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."fechaNacimiento" IS 'Fecha finita de nacimiento; no puede ser posterior a CURRENT_DATE al validar la fila. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Técnico"."áreaEspecialidad" IS 'Área de especialidad; texto con al menos un carácter no blanco. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "Certificaciones" IS 'Valores de certificación asociados a cada técnico; no constituyen un catálogo independiente.';
COMMENT ON COLUMN "Certificaciones"."CURP" IS 'Técnico propietario de la certificación; referencia obligatoria y componente de la PK. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "Certificaciones"."Certificaciones" IS 'Nombre o descripción no blanca de una certificación; completa la PK y evita repetirla para el mismo técnico. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "CorreoElectrónicoTécnico" IS 'Direcciones de correo dependientes del técnico; únicas por propietario y dirección.';
COMMENT ON COLUMN "CorreoElectrónicoTécnico"."CURP" IS 'Técnico propietario del correo; referencia obligatoria y componente de la PK. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "CorreoElectrónicoTécnico"."correoTécnico" IS 'Dirección sin espacios, con una arroba y partes no vacías; el patrón no comprueba la existencia del buzón. Obligatoria (NOT NULL); sin DEFAULT.';

COMMENT ON TABLE "TeléfonoTécnivo" IS 'Teléfonos dependientes del técnico; se conserva el nombre literal TeléfonoTécnivo del esquema anterior.';
COMMENT ON COLUMN "TeléfonoTécnivo"."CURP" IS 'Técnico propietario del teléfono; referencia obligatoria y componente de la PK. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON COLUMN "TeléfonoTécnivo"."telefonoTécnico" IS 'Número de exactamente diez dígitos; completa la PK, sin unicidad global entre técnicos. Obligatoria (NOT NULL); sin DEFAULT.';
COMMENT ON CONSTRAINT "ck_certificacion_tecnico_certificaciones" ON "Certificaciones" IS 'Valida el dominio de los datos: CHECK ("Certificaciones" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_certificacion_tecnico_curp" ON "Certificaciones" IS 'Valida el dominio de los datos: CHECK ("CURP" ~ ''^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_certificacion_tecnico" ON "Certificaciones" IS 'La certificación es un valor dependiente de su técnico; se elimina con él y se conserva al corregir la CURP, incluida su PK compuesta. ON DELETE CASCADE; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_certificacion_tecnico" ON "Certificaciones" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("CURP", "Certificaciones").';
COMMENT ON CONSTRAINT "ck_correo_tecnico_formato" ON "CorreoElectrónicoTécnico" IS 'Valida el dominio de los datos: CHECK ("correoTécnico" ~ ''^[^[:space:]@]+@[^[:space:]@]+$''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_correo_tecnico" ON "CorreoElectrónicoTécnico" IS 'El correo depende del técnico; eliminarlo limpia sus contactos y corregir la CURP conserva su asociación. ON DELETE CASCADE; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_correo_tecnico" ON "CorreoElectrónicoTécnico" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("CURP", "correoTécnico").';
COMMENT ON CONSTRAINT "ck_juego_costo" ON "Juego" IS 'Valida el dominio de los datos: CHECK ("costo" >= 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_juego_id" ON "Juego" IS 'Valida el dominio de los datos: CHECK ("idJuego" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_juego_nombre" ON "Juego" IS 'Valida el dominio de los datos: CHECK ("nombre" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_juego_tipo" ON "Juego" IS 'Valida el dominio de los datos: CHECK ("idTipo" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_juego_tipo" ON "Juego" IS 'El tipo es un catálogo compartido; se impide borrarlo mientras clasifique juegos y se propagan correcciones de idTipo. ON DELETE NO ACTION; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_juego" ON "Juego" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idJuego").';
COMMENT ON CONSTRAINT "ck_mantenimiento_curp" ON "Mantenimiento" IS 'Valida el dominio de los datos: CHECK ("CURP" ~ ''^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_mantenimiento_descripcion" ON "Mantenimiento" IS 'Valida el dominio de los datos: CHECK ("descripcionProblema" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_mantenimiento_fecha" ON "Mantenimiento" IS 'Valida el dominio de los datos: CHECK (isfinite("fecha") AND "fecha" <= CURRENT_DATE). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_mantenimiento_id" ON "Mantenimiento" IS 'Valida el dominio de los datos: CHECK ("idMantenimiento" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_mantenimiento_maquina" ON "Mantenimiento" IS 'Valida el dominio de los datos: CHECK ("idMaquina" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_mantenimiento_tipo" ON "Mantenimiento" IS 'Valida el dominio de los datos: CHECK ("tipoMantenimiento" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_mantenimiento_maquina" ON "Mantenimiento" IS 'El mantenimiento es historial del equipo: impide borrar la máquina referenciada y propaga correcciones de su identificador a la PK compuesta. ON DELETE NO ACTION; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "fk_mantenimiento_tecnico" ON "Mantenimiento" IS 'Se conserva la atribución del mantenimiento al técnico; se impide borrar al responsable y se propagan correcciones de CURP. ON DELETE NO ACTION; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_mantenimiento" ON "Mantenimiento" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idMaquina", "idMantenimiento").';
COMMENT ON CONSTRAINT "ck_maquina_estado" ON "Máquina" IS 'Valida el dominio de los datos: CHECK ("estado" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_maquina_id" ON "Máquina" IS 'Valida el dominio de los datos: CHECK ("idMaquina" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_maquina_juego" ON "Máquina" IS 'Valida el dominio de los datos: CHECK ("idJuego" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_maquina_sucursal" ON "Máquina" IS 'Valida el dominio de los datos: CHECK ("idSucursal" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_maquina_juego" ON "Máquina" IS 'El juego clasifica equipos con existencia propia; no se eliminan máquinas al borrar su juego y se propagan correcciones de idJuego. ON DELETE NO ACTION; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "fk_maquina_sucursal" ON "Máquina" IS 'Una sucursal no debe borrar equipos como efecto secundario; se impide eliminarla mientras tenga máquinas y se propaga su identificador. ON DELETE NO ACTION; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_maquina" ON "Máquina" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idMaquina").';
COMMENT ON CONSTRAINT "ck_telefono_tecnico_formato" ON "TeléfonoTécnivo" IS 'Valida el dominio de los datos: CHECK ("telefonoTécnico" ~ ''^[0-9]{10}$''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_telefono_tecnico" ON "TeléfonoTécnivo" IS 'El teléfono depende del técnico; eliminarlo limpia sus contactos y corregir la CURP conserva su asociación. ON DELETE CASCADE; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_telefono_tecnico" ON "TeléfonoTécnivo" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("CURP", "telefonoTécnico").';
COMMENT ON CONSTRAINT "ck_tecnico_apellido_materno" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("ApellidoMaterno" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_apellido_paterno" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("ApellidoPaterno" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_curp" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("CURP" ~ ''^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_especialidad" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("áreaEspecialidad" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_fecha_contratacion" ON "Técnico" IS 'Valida el dominio de los datos: CHECK (isfinite("fechaContratación") AND "fechaContratación" <= CURRENT_DATE). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_fecha_nacimiento" ON "Técnico" IS 'Valida el dominio de los datos: CHECK (isfinite("fechaNacimiento") AND "fechaNacimiento" <= CURRENT_DATE). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_nombre" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("Nombre" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_rfc" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("RFC" ~ ''^[A-ZÑ&]{3,4}[0-9]{6}[A-Z0-9]{3}$''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_salario" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("salario" >= 0 AND "salario" <> ''NaN''::numeric). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tecnico_sucursal" ON "Técnico" IS 'Valida el dominio de los datos: CHECK ("idSucursal" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "fk_tecnico_sucursal" ON "Técnico" IS 'La sucursal no es propietaria de la identidad laboral del técnico; se impide borrarla mientras tenga técnicos y se propaga su identificador. ON DELETE NO ACTION; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_tecnico" ON "Técnico" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("CURP").';
COMMENT ON CONSTRAINT "ck_tipo_juego_condicion" ON "tipoDeJuego" IS 'Valida el dominio de los datos: CHECK ("condicion" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tipo_juego_id" ON "tipoDeJuego" IS 'Valida el dominio de los datos: CHECK ("idTipo" > 0). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tipo_juego_nombre" ON "tipoDeJuego" IS 'Valida el dominio de los datos: CHECK ("nombre" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_tipo_juego_regla" ON "tipoDeJuego" IS 'Valida el dominio de los datos: CHECK ("reglaPuntuacion" ~ ''[^[:space:]]''). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "pk_tipo_juego" ON "tipoDeJuego" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idTipo").';

-- PostgreSQL 18 representa NOT NULL como constraints comentables en pg_constraint.
-- Se usa el catálogo para conservar sus nombres reales, incluidos identificadores con acentos.
DO $$
DECLARE r record;
BEGIN
  FOR r IN
    SELECT k.conname, c.relname, a.attname
    FROM pg_constraint k
    JOIN pg_class c ON c.oid=k.conrelid
    JOIN pg_attribute a ON a.attrelid=c.oid AND a.attnum=k.conkey[1]
    WHERE k.contype='n' AND c.relnamespace='public'::regnamespace
      AND c.relname IN ('tipoDeJuego', 'Juego', 'Máquina', 'Mantenimiento', 'Técnico', 'Certificaciones', 'CorreoElectrónicoTécnico', 'TeléfonoTécnivo')
  LOOP
    EXECUTE format('COMMENT ON CONSTRAINT %I ON public.%I IS %L',
                   r.conname, r.relname, 'Exige un valor no nulo en ' || quote_ident(r.attname) || '.');
  END LOOP;
END $$;
COMMIT;
