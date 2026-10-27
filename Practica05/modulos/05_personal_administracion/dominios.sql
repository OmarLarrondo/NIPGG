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
