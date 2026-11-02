-- Práctica 06 | Módulo 04 | Yahir
-- Ejecutar después de politicas.sql. Incluye NOT NULL de PostgreSQL 18.
BEGIN;

COMMENT ON TABLE "SUCURSAL" IS 'Sucursal del centro de entretenimiento; sus visitas, recargas y horarios dependen de ella.';
COMMENT ON COLUMN "SUCURSAL"."idSucursal" IS 'Identificador positivo de la sucursal; llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."nombre" IS 'Nombre de la sucursal, con al menos un carácter distinto de espacio. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."teléfono" IS 'Teléfono de contacto de exactamente diez dígitos. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."calle" IS 'Calle del domicilio, con al menos un carácter distinto de espacio. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."númeroExterior" IS 'Número exterior entero no negativo. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."númeroInterior" IS 'Número interior entero no negativo. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."colonia" IS 'Colonia del domicilio, con al menos un carácter distinto de espacio. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "SUCURSAL"."estado" IS 'Estado de la República, con al menos un carácter distinto de espacio. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "HORARIO_SUCURSAL" IS 'Horarios de atención de cada sucursal; dependen de la sucursal y se eliminan con ella.';
COMMENT ON COLUMN "HORARIO_SUCURSAL"."idSucursal" IS 'Sucursal a la que pertenece el horario; parte de la llave primaria y referencia a SUCURSAL. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "HORARIO_SUCURSAL"."horario" IS 'Texto descriptivo del horario de atención; parte de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "VISITA" IS 'Historial de visitas de una tarjeta a una sucursal; se conserva ante el borrado de sus referencias.';
COMMENT ON COLUMN "VISITA"."idCliente" IS 'Primer componente de la referencia compuesta a Tarjeta y de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "VISITA"."numeroTarjeta" IS 'Segundo componente de la referencia compuesta a Tarjeta y de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "VISITA"."idSucursal" IS 'Sucursal visitada; referencia a SUCURSAL y componente de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "VISITA"."idVisita" IS 'Identificador positivo de la visita dentro de la llave primaria compuesta. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "VISITA"."fecha" IS 'Fecha finita de la visita; el esquema no prohíbe fechas futuras. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "RECARGA" IS 'Historial de recargas monetarias por sucursal y tarjeta; conserva la atribución al cajero.';
COMMENT ON COLUMN "RECARGA"."idCliente" IS 'Primer componente de la referencia compuesta a Tarjeta y de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."numeroTarjeta" IS 'Segundo componente de la referencia compuesta a Tarjeta y de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."idSucursal" IS 'Sucursal donde se realizó la recarga; referencia a SUCURSAL y componente de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."idRecarga" IS 'Identificador positivo de la recarga dentro de la llave primaria compuesta. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."CURP" IS 'CURP del cajero que procesó la recarga; referencia a Cajero y componente de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."monto" IS 'Monto entero no negativo recargado. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."fecha" IS 'Fecha finita de la recarga; el esquema no prohíbe fechas futuras. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."hora" IS 'Hora de la recarga con zona horaria (timetz). Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "RECARGA"."métodoAbono" IS 'Método de abono registrado, texto no vacío; sin catálogo impuesto. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON CONSTRAINT "SUCURSAL_idSucursal_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "SUCURSAL_nombre_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en nombre.';
COMMENT ON CONSTRAINT "SUCURSAL_teléfono_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en "teléfono".';
COMMENT ON CONSTRAINT "SUCURSAL_calle_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en calle.';
COMMENT ON CONSTRAINT "SUCURSAL_númeroExterior_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en "númeroExterior".';
COMMENT ON CONSTRAINT "SUCURSAL_númeroInterior_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en "númeroInterior".';
COMMENT ON CONSTRAINT "SUCURSAL_colonia_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en colonia.';
COMMENT ON CONSTRAINT "SUCURSAL_estado_not_null" ON "SUCURSAL" IS 'Exige un valor no nulo en estado.';

COMMENT ON CONSTRAINT "ck_sucursal_id" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK (("idSucursal" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_nombre" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK ((("nombre")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_telefono" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK (("teléfono" ~ ''^[0-9]{10}$''::text)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_calle" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK ((("calle")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_num_ext" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK (("númeroExterior" >= 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_num_int" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK (("númeroInterior" >= 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_colonia" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK ((("colonia")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_sucursal_codigo" ON "SUCURSAL" IS 'Valida el dominio de los datos: CHECK ((("estado")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';

COMMENT ON CONSTRAINT "pk_sucursal" ON "SUCURSAL" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idSucursal").';

COMMENT ON CONSTRAINT "HORARIO_SUCURSAL_idSucursal_not_null" ON "HORARIO_SUCURSAL" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "HORARIO_SUCURSAL_horario_not_null" ON "HORARIO_SUCURSAL" IS 'Exige un valor no nulo en horario.';

COMMENT ON CONSTRAINT "ck_horario_sucursal_id" ON "HORARIO_SUCURSAL" IS 'Valida el dominio de los datos: CHECK (("idSucursal" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_horario_sucursal_texto" ON "HORARIO_SUCURSAL" IS 'Valida el dominio de los datos: CHECK ((("horario")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';

COMMENT ON CONSTRAINT "fk_horario_sucursal" ON "HORARIO_SUCURSAL" IS 'El horario es dependiente de la sucursal: eliminar la sucursal elimina sus horarios y una corrección del identificador se propaga. ON DELETE CASCADE; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_horario_sucursal" ON "HORARIO_SUCURSAL" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idSucursal", "horario").';

COMMENT ON CONSTRAINT "VISITA_idCliente_not_null" ON "VISITA" IS 'Exige un valor no nulo en "idCliente".';
COMMENT ON CONSTRAINT "VISITA_numeroTarjeta_not_null" ON "VISITA" IS 'Exige un valor no nulo en "numeroTarjeta".';
COMMENT ON CONSTRAINT "VISITA_idSucursal_not_null" ON "VISITA" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "VISITA_idVisita_not_null" ON "VISITA" IS 'Exige un valor no nulo en "idVisita".';
COMMENT ON CONSTRAINT "VISITA_fecha_not_null" ON "VISITA" IS 'Exige un valor no nulo en fecha.';

COMMENT ON CONSTRAINT "ck_visita_cliente" ON "VISITA" IS 'Valida el dominio de los datos: CHECK (("idCliente" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_visita_tarjeta" ON "VISITA" IS 'Valida el dominio de los datos: CHECK (("numeroTarjeta" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_visita_sucursal" ON "VISITA" IS 'Valida el dominio de los datos: CHECK (("idSucursal" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_visita_id" ON "VISITA" IS 'Valida el dominio de los datos: CHECK (("idVisita" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_visita_fecha" ON "VISITA" IS 'Valida el dominio de los datos: CHECK (isfinite("fecha")). No sustituye la obligatoriedad de las columnas.';

COMMENT ON CONSTRAINT "fk_visita_tarjeta" ON "VISITA" IS 'La visita registra el uso de la tarjeta: se impide eliminar una tarjeta con visitas y se propagan correcciones de la pareja de identificadores. ON DELETE RESTRICT; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "fk_visita_sucursal" ON "VISITA" IS 'La visita conserva el registro por sucursal: se impide eliminar una sucursal con visitas asociadas y se propagan correcciones del identificador. ON DELETE RESTRICT; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_visita" ON "VISITA" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idCliente", "numeroTarjeta", "idSucursal", "idVisita").';

COMMENT ON CONSTRAINT "RECARGA_idCliente_not_null" ON "RECARGA" IS 'Exige un valor no nulo en "idCliente".';
COMMENT ON CONSTRAINT "RECARGA_numeroTarjeta_not_null" ON "RECARGA" IS 'Exige un valor no nulo en "numeroTarjeta".';
COMMENT ON CONSTRAINT "RECARGA_idSucursal_not_null" ON "RECARGA" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "RECARGA_idRecarga_not_null" ON "RECARGA" IS 'Exige un valor no nulo en "idRecarga".';
COMMENT ON CONSTRAINT "RECARGA_CURP_not_null" ON "RECARGA" IS 'Exige un valor no nulo en "CURP".';
COMMENT ON CONSTRAINT "RECARGA_monto_not_null" ON "RECARGA" IS 'Exige un valor no nulo en monto.';
COMMENT ON CONSTRAINT "RECARGA_fecha_not_null" ON "RECARGA" IS 'Exige un valor no nulo en fecha.';
COMMENT ON CONSTRAINT "RECARGA_hora_not_null" ON "RECARGA" IS 'Exige un valor no nulo en hora.';
COMMENT ON CONSTRAINT "RECARGA_métodoAbono_not_null" ON "RECARGA" IS 'Exige un valor no nulo en "métodoAbono".';

COMMENT ON CONSTRAINT "ck_recarga_cliente" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK (("idCliente" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_tarjeta" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK (("numeroTarjeta" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_sucursal" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK (("idSucursal" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_id" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK (("idRecarga" > 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_curp" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK ((("CURP")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_monto" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK (("monto" >= 0)). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_fecha" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK (isfinite("fecha")). No sustituye la obligatoriedad de las columnas.';
COMMENT ON CONSTRAINT "ck_recarga_metodo" ON "RECARGA" IS 'Valida el dominio de los datos: CHECK ((("métodoAbono")::text ~ ''[^[:space:]]''::text)). No sustituye la obligatoriedad de las columnas.';

COMMENT ON CONSTRAINT "fk_recarga_tarjeta" ON "RECARGA" IS 'La recarga es un movimiento monetario: se protege el historial ante el borrado de la tarjeta y se propagan correcciones de la pareja de identificadores. ON DELETE RESTRICT; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "fk_recarga_sucursal" ON "RECARGA" IS 'Se preserva el historial de recargas por sucursal: se impide eliminar una sucursal con recargas y se propagan correcciones del identificador. ON DELETE RESTRICT; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "fk_recarga_cajero" ON "RECARGA" IS 'La recarga documenta quién procesó el cobro: se impide eliminar un cajero con recargas y se propagan correcciones de CURP. ON DELETE RESTRICT; ON UPDATE CASCADE; comprobación no diferible.';
COMMENT ON CONSTRAINT "pk_recarga" ON "RECARGA" IS 'Identifica cada fila sin duplicados ni nulos mediante PRIMARY KEY ("idCliente", "numeroTarjeta", "idSucursal", "idRecarga", "CURP").';

COMMIT;