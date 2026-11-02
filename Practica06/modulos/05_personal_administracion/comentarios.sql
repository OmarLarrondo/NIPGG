-- Módulo 05 | Responsable: Diego
-- Estado: plantilla; comentarios pendientes de implementar.
-- Aplicar después de las políticas para no perder comentarios al recrear FK.
-- Completar COMMENT ON TABLE, COLUMN y CONSTRAINT de todos los objetos propios.
-- Describir finalidad, significado de columnas y reglas de las restricciones.
-- Consultar nombres de constraints en ../../base/DDL_practica05.sql.

-- 1. TABLA Genrente
COMMENT ON TABLE "Genrente" IS
'Contiene la información personal, laboral y profesional de los gerentes. Cada gerente pertenece a una sucursal.';

COMMENT ON COLUMN "Genrente"."CURP" IS 'Identificador del gerente y llave primaria de la tabla.';
COMMENT ON COLUMN "Genrente"."idSucursal" IS 'Identificador de la sucursal a la que pertenece el gerente.';
COMMENT ON COLUMN "Genrente"."Nombre" IS 'Nombre del gerente.';
COMMENT ON COLUMN "Genrente"."ApellidoMaterno" IS 'Apellido materno del gerente.';
COMMENT ON COLUMN "Genrente"."ApellidoPaterno" IS 'Apellido paterno del gerente.';
COMMENT ON COLUMN "Genrente"."RFC" IS 'Registro Federal de Contribuyentes del gerente.';
COMMENT ON COLUMN "Genrente"."fechaContratación" IS 'Fecha en la que el gerente fue contratado.';
COMMENT ON COLUMN "Genrente"."salario" IS 'Salario asignado al gerente.';
COMMENT ON COLUMN "Genrente"."fechaNacimiento" IS 'Fecha de nacimiento del gerente.';
COMMENT ON COLUMN "Genrente"."cédulaProfesional" IS 'Número de cédula profesional del gerente.';

-- 2. TABLA Cajero
COMMENT ON TABLE "Cajero" IS
'Contiene la información personal y laboral de los cajeros que trabajan en las sucursales.';

COMMENT ON COLUMN "Cajero"."CURP" IS 'Identificador del cajero y llave primaria de la tabla.';
COMMENT ON COLUMN "Cajero"."idSucursal" IS 'Identificador de la sucursal donde trabaja el cajero.';
COMMENT ON COLUMN "Cajero"."Nombre" IS 'Nombre del cajero.';
COMMENT ON COLUMN "Cajero"."ApellidoMaterno" IS 'Apellido materno del cajero.';
COMMENT ON COLUMN "Cajero"."ApellidoPaterno" IS 'Apellido paterno del cajero.';
COMMENT ON COLUMN "Cajero"."RFC" IS 'Registro Federal de Contribuyentes del cajero.';
COMMENT ON COLUMN "Cajero"."fechaContratación" IS 'Fecha en la que el cajero fue contratado.';
COMMENT ON COLUMN "Cajero"."salario" IS 'Salario asignado al cajero.';
COMMENT ON COLUMN "Cajero"."fechaNacimiento" IS 'Fecha de nacimiento del cajero.';
COMMENT ON COLUMN "Cajero"."horarioTrabajo" IS 'Horario de trabajo asignado al cajero.';

-- 3. TABLA Administrar

COMMENT ON TABLE "Administrar" IS
'Representa la relación entre gerentes y sucursales que administran. Cada gerente y cada sucursal participan como máximo en una asignación.';

COMMENT ON COLUMN "Administrar"."CURP" IS 'CURP del gerente que administra la sucursal.';
COMMENT ON COLUMN "Administrar"."idSucursal" IS 'Identificador de la sucursal administrada.';

-- 4. TABLA CorreoElectrónicoGerente
COMMENT ON TABLE "CorreoElectrónicoGerente" IS
'Almacena las direcciones de correo electrónico correspondientes a los gerentes.';

COMMENT ON COLUMN "CorreoElectrónicoGerente"."CURP" IS 'CURP del gerente propietario del correo electrónico.';
COMMENT ON COLUMN "CorreoElectrónicoGerente"."correoGerente" IS 'Dirección de correo electrónico del gerente.';

-- 5. TABLA TeléfonoGerente
COMMENT ON TABLE "TeléfonoGerente" IS
'Almacena los números telefónicos correspondientes a los gerentes.';

COMMENT ON COLUMN "TeléfonoGerente"."CURP" IS 'CURP del gerente propietario del número telefónico.';
COMMENT ON COLUMN "TeléfonoGerente"."telefonoGerente" IS 'Número telefónico del gerente.';

-- 6. TABLA CorreoElectrónicoCajero
COMMENT ON TABLE "CorreoElectrónicoCajero" IS
'Almacena las direcciones de correo electrónico correspondientes a los cajeros.';

COMMENT ON COLUMN "CorreoElectrónicoCajero"."CURP" IS 'CURP del cajero propietario del correo electrónico.';
COMMENT ON COLUMN "CorreoElectrónicoCajero"."correoCajero" IS 'Dirección de correo electrónico del cajero.';

-- 7. TABLA TeléfonoCajero
COMMENT ON TABLE "TeléfonoCajero" IS
'Almacena los números telefónicos correspondientes a los cajeros.';

COMMENT ON COLUMN "TeléfonoCajero"."CURP" IS 'CURP del cajero propietario del número telefónico.';
COMMENT ON COLUMN "TeléfonoCajero"."telefonoCajero" IS 'Número telefónico del cajero.';

-- 8. RESTRICCIONES NOT NULL DE Genrente
COMMENT ON CONSTRAINT "Genrente_CURP_not_null" ON "Genrente" IS
'Exige que el CURP del gerente no sea nulo.';

COMMENT ON CONSTRAINT "Genrente_idSucursal_not_null" ON "Genrente" IS
'Exige que el gerente tenga asignada una sucursal.';

COMMENT ON CONSTRAINT "Genrente_Nombre_not_null" ON "Genrente" IS
'Exige que el gerente tenga un nombre.';

COMMENT ON CONSTRAINT "Genrente_ApellidoMaterno_not_null" ON "Genrente" IS
'Exige que el gerente tenga un apellido materno.';

COMMENT ON CONSTRAINT "Genrente_ApellidoPaterno_not_null" ON "Genrente" IS
'Exige que el gerente tenga un apellido paterno.';

COMMENT ON CONSTRAINT "Genrente_RFC_not_null" ON "Genrente" IS
'Exige que el gerente tenga un RFC.';

COMMENT ON CONSTRAINT "Genrente_fechaContratación_not_null" ON "Genrente" IS
'Exige que se registre la fecha de contratación del gerente.';

COMMENT ON CONSTRAINT "Genrente_salario_not_null" ON "Genrente" IS
'Exige que se registre el salario del gerente.';

COMMENT ON CONSTRAINT "Genrente_fechaNacimiento_not_null" ON "Genrente" IS
'Exige que se registre la fecha de nacimiento del gerente.';

COMMENT ON CONSTRAINT "Genrente_cédulaProfesional_not_null" ON "Genrente" IS
'Exige que se registre la cédula profesional del gerente.';

-- 9. RESTRICCIONES CHECK DE Genrente

COMMENT ON CONSTRAINT ckgerentecurp ON "Genrente" IS
'Valida que el CURP del gerente cumpla con el formato establecido.';

COMMENT ON CONSTRAINT ckgerenteidsucursalpositivo ON "Genrente" IS
'Valida que el identificador de la sucursal sea positivo.';

COMMENT ON CONSTRAINT ckgerentenombrenovacio ON "Genrente" IS
'Evita que el nombre del gerente sea una cadena vacía o de espacios.';

COMMENT ON CONSTRAINT ckgerenteapellidomaternonovacio ON "Genrente" IS
'Evita que el apellido materno sea una cadena vacía o de espacios.';

COMMENT ON CONSTRAINT ckgerenteapellidopaternonovacio ON "Genrente" IS
'Evita que el apellido paterno sea una cadena vacía o de espacios.';

COMMENT ON CONSTRAINT ckgerenterfc ON "Genrente" IS
'Valida que el RFC del gerente cumpla con el formato establecido.';

COMMENT ON CONSTRAINT ckgerentesalariononegativo ON "Genrente" IS
'Valida que el salario sea mayor o igual a cero y no sea NaN.';

COMMENT ON CONSTRAINT ckgerentefechacontrataciónfutura ON "Genrente" IS
'Valida que la fecha de contratación sea finita y no sea posterior a la fecha actual.';

COMMENT ON CONSTRAINT ckgerentefechanacimientonofutura ON "Genrente" IS
'Valida que la fecha de nacimiento sea finita y no sea posterior a la fecha actual.';

COMMENT ON CONSTRAINT ckgerentecedulaprofesional ON "Genrente" IS
'Valida que la cédula profesional contenga entre siete y ocho dígitos.';

-- 10. LLAVES DE Genrente
COMMENT ON CONSTRAINT pkgerente ON "Genrente" IS
'Llave primaria que identifica de manera única a cada gerente mediante su CURP.';

COMMENT ON CONSTRAINT uqgerenterfc ON "Genrente" IS
'Impide que dos gerentes tengan el mismo RFC.';

COMMENT ON CONSTRAINT fkgerentesucursal ON "Genrente" IS
'Relaciona al gerente con una sucursal. Impide eliminar una sucursal que tenga gerentes asignados y propaga las actualizaciones de su identificador. ON DELETE NO ACTION; ON UPDATE CASCADE.';

-- 11. RESTRICCIONES NOT NULL DE Cajero
COMMENT ON CONSTRAINT "Cajero_CURP_not_null" ON "Cajero" IS
'Exige que el CURP del cajero no sea nulo.';

COMMENT ON CONSTRAINT "Cajero_idSucursal_not_null" ON "Cajero" IS
'Exige que el cajero tenga asignada una sucursal.';

COMMENT ON CONSTRAINT "Cajero_Nombre_not_null" ON "Cajero" IS
'Exige que el cajero tenga un nombre.';

COMMENT ON CONSTRAINT "Cajero_ApellidoMaterno_not_null" ON "Cajero" IS
'Exige que el cajero tenga un apellido materno.';

COMMENT ON CONSTRAINT "Cajero_ApellidoPaterno_not_null" ON "Cajero" IS
'Exige que el cajero tenga un apellido paterno.';

COMMENT ON CONSTRAINT "Cajero_RFC_not_null" ON "Cajero" IS
'Exige que el cajero tenga un RFC.';

COMMENT ON CONSTRAINT "Cajero_fechaContratación_not_null" ON "Cajero" IS
'Exige que se registre la fecha de contratación del cajero.';

COMMENT ON CONSTRAINT "Cajero_salario_not_null" ON "Cajero" IS
'Exige que se registre el salario del cajero.';

COMMENT ON CONSTRAINT "Cajero_fechaNacimiento_not_null" ON "Cajero" IS
'Exige que se registre la fecha de nacimiento del cajero.';

COMMENT ON CONSTRAINT "Cajero_horarioTrabajo_not_null" ON "Cajero" IS
'Exige que se registre el horario de trabajo del cajero.';

-- 12. RESTRICCIONES CHECK DE Cajero
COMMENT ON CONSTRAINT ckcajerocurp ON "Cajero" IS
'Valida que el CURP del cajero cumpla con el formato establecido.';

COMMENT ON CONSTRAINT ckcajeroidsucursalpositivo ON "Cajero" IS
'Valida que el identificador de la sucursal sea positivo.';

COMMENT ON CONSTRAINT ckcajeronombrenovacio ON "Cajero" IS
'Evita que el nombre del cajero sea una cadena vacía o de espacios.';

COMMENT ON CONSTRAINT ckcajeroapellidomaternonovacio ON "Cajero" IS
'Evita que el apellido materno sea una cadena vacía o de espacios.';

COMMENT ON CONSTRAINT ckcajeroapellidopaternonovacio ON "Cajero" IS
'Evita que el apellido paterno sea una cadena vacía o de espacios.';

COMMENT ON CONSTRAINT ck_ajerorfc ON "Cajero" IS
'Valida que el RFC del cajero cumpla con el formato establecido.';

COMMENT ON CONSTRAINT ckcajerosalariononegativo ON "Cajero" IS
'Valida que el salario sea mayor o igual a cero y no sea NaN.';

COMMENT ON CONSTRAINT ckgerentefechacontrataciónfutura ON "Cajero" IS
'Valida que la fecha de contratación del cajero sea finita y no sea posterior a la fecha actual.';

COMMENT ON CONSTRAINT ckcajero_echanacimientonofutura ON "Cajero" IS
'Valida que la fecha de nacimiento del cajero sea finita y no sea posterior a la fecha actual.';

COMMENT ON CONSTRAINT ckcajerohorariotrabajo ON "Cajero" IS
'Limita el horario de trabajo del cajero a las 07:00 o a las 15:00 horas.';

-- 13. LLAVES DE Cajero
COMMENT ON CONSTRAINT pkcajero ON "Cajero" IS
'Llave primaria que identifica de manera única a cada cajero mediante su CURP.';

COMMENT ON CONSTRAINT uqcajerorfc ON "Cajero" IS
'Impide que dos cajeros tengan el mismo RFC.';

COMMENT ON CONSTRAINT fkcajerosucursal ON "Cajero" IS
'Relaciona al cajero con una sucursal. Impide eliminar una sucursal que tenga cajeros asignados y propaga las actualizaciones de su identificador. ON DELETE NO ACTION; ON UPDATE CASCADE.';

-- 14. RESTRICCIONES DE Administrar
COMMENT ON CONSTRAINT "Administrar_CURP_not_null" ON "Administrar" IS
'Exige que la relación tenga un gerente asociado.';

COMMENT ON CONSTRAINT "Administrar_idSucursal_not_null" ON "Administrar" IS
'Exige que la relación tenga una sucursal asociada.';

COMMENT ON CONSTRAINT ck_administrar_curp ON "Administrar" IS
'Valida que el CURP del gerente cumpla con el formato establecido.';

COMMENT ON CONSTRAINT ck_administrar_idsucursal_positivo ON "Administrar" IS
'Valida que el identificador de la sucursal sea positivo.';

COMMENT ON CONSTRAINT pkadministrar ON "Administrar" IS
'Llave primaria compuesta por CURP e idSucursal que identifica cada relación de administración.';

COMMENT ON CONSTRAINT uqadministrarsucursal ON "Administrar" IS
'Impide que una sucursal tenga más de un gerente asignado en esta relación.';

COMMENT ON CONSTRAINT uqadministrargerente ON "Administrar" IS
'Impide que un gerente tenga más de una sucursal asignada en esta relación.';

COMMENT ON CONSTRAINT fkadministrargerente ON "Administrar" IS
'Relaciona la asignación administrativa con un gerente. Elimina la relación cuando se elimina al gerente y propaga las correcciones de CURP. ON DELETE CASCADE; ON UPDATE CASCADE.';

COMMENT ON CONSTRAINT fkadministrarsucursal ON "Administrar" IS
'Relaciona la asignación administrativa con una sucursal. Elimina la relación cuando se elimina la sucursal y propaga las correcciones de su identificador. ON DELETE CASCADE; ON UPDATE CASCADE.';

-- 15. RESTRICCIONES DE CorreoElectrónicoGerente
COMMENT ON CONSTRAINT "CorreoElectrónicoGerente_CURP_not_null" ON "CorreoElectrónicoGerente" IS
'Exige que cada correo electrónico esté asociado con un gerente.';

COMMENT ON CONSTRAINT "CorreoElectrónicoGerente_correoGerente_not_null" ON "CorreoElectrónicoGerente" IS
'Exige que se registre una dirección de correo electrónico.';

COMMENT ON CONSTRAINT ck_correo_gerente_formato ON "CorreoElectrónicoGerente" IS
'Valida que el correo del gerente contenga una dirección con formato básico y sin espacios.';

COMMENT ON CONSTRAINT pk_correo_gerente ON "CorreoElectrónicoGerente" IS
'Llave primaria compuesta por CURP y correoGerente para identificar cada correo de un gerente.';

COMMENT ON CONSTRAINT fk_correo_gerente ON "CorreoElectrónicoGerente" IS
'Relaciona el correo electrónico con su gerente. Elimina el contacto al eliminar al gerente y propaga las correcciones de CURP. ON DELETE CASCADE; ON UPDATE CASCADE.';

-- 16. RESTRICCIONES DE TeléfonoGerente
COMMENT ON CONSTRAINT "TeléfonoGerente_CURP_not_null" ON "TeléfonoGerente" IS
'Exige que cada número telefónico esté asociado con un gerente.';

COMMENT ON CONSTRAINT "TeléfonoGerente_telefonoGerente_not_null" ON "TeléfonoGerente" IS
'Exige que se registre un número telefónico.';

COMMENT ON CONSTRAINT ck_telefono_gerente_formato ON "TeléfonoGerente" IS
'Valida que el teléfono del gerente contenga exactamente diez dígitos.';

COMMENT ON CONSTRAINT pk_telefono_gerente ON "TeléfonoGerente" IS
'Llave primaria compuesta por CURP y telefonoGerente para identificar cada teléfono de un gerente.';

COMMENT ON CONSTRAINT fk_telefono_gerente ON "TeléfonoGerente" IS
'Relaciona el teléfono con su gerente. Elimina el contacto al eliminar al gerente y propaga las correcciones de CURP. ON DELETE CASCADE; ON UPDATE CASCADE.';

-- 17. RESTRICCIONES DE CorreoElectrónicoCajero
COMMENT ON CONSTRAINT "CorreoElectrónicoCajero_CURP_not_null" ON "CorreoElectrónicoCajero" IS
'Exige que cada correo electrónico esté asociado con un cajero.';

COMMENT ON CONSTRAINT "CorreoElectrónicoCajero_correoCajero_not_null" ON "CorreoElectrónicoCajero" IS
'Exige que se registre una dirección de correo electrónico.';

COMMENT ON CONSTRAINT ck_correo_cajero_formato ON "CorreoElectrónicoCajero" IS
'Valida que el correo del cajero contenga una dirección con formato básico y sin espacios.';

COMMENT ON CONSTRAINT pk_correo_cajero ON "CorreoElectrónicoCajero" IS
'Llave primaria compuesta por CURP y correoCajero para identificar cada correo de un cajero.';

COMMENT ON CONSTRAINT fk_correo_cajero ON "CorreoElectrónicoCajero" IS
'Relaciona el correo electrónico con su cajero. Elimina el contacto al eliminar al cajero y propaga las correcciones de CURP. ON DELETE CASCADE; ON UPDATE CASCADE.';

-- 18. RESTRICCIONES DE TeléfonoCajero
COMMENT ON CONSTRAINT "TeléfonoCajero_CURP_not_null" ON "TeléfonoCajero" IS
'Exige que cada número telefónico esté asociado con un cajero.';

COMMENT ON CONSTRAINT "TeléfonoCajero_telefonoCajero_not_null" ON "TeléfonoCajero" IS
'Exige que se registre un número telefónico.';

COMMENT ON CONSTRAINT ck_telefono_cajero_formato ON "TeléfonoCajero" IS
'Valida que el teléfono del cajero contenga exactamente diez dígitos.';

COMMENT ON CONSTRAINT pk_telefono_cajero ON "TeléfonoCajero" IS
'Llave primaria compuesta por CURP y telefonoCajero para identificar cada teléfono de un cajero.';

COMMENT ON CONSTRAINT fk_telefono_cajero ON "TeléfonoCajero" IS
'Relaciona el teléfono con su cajero. Elimina el contacto al eliminar al cajero y propaga las correcciones de CURP. ON DELETE CASCADE; ON UPDATE CASCADE.';

