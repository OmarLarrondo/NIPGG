-- Práctica 06 | Módulo 03 | Responsable: Ana
-- Base: ../../base/DDL_practica05.sql con politicas.sql ya aplicado.
-- Aplicar después de las políticas para no perder comentarios al recrear FK.
BEGIN;

-- Tablas y columnas
COMMENT ON TABLE "Premio" IS 'Catálogo de premios que los clientes pueden canjear con los puntos de su tarjeta.';
COMMENT ON COLUMN "Premio"."idPremio" IS 'Identificador positivo del premio; llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Premio"."valorAproximado" IS 'Valor monetario aproximado del premio, entero no negativo; se conserva la unidad del esquema original. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Premio"."puntosNecesarios" IS 'Puntos que se descuentan por cada unidad canjeada, enteros positivos. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Premio"."nombre" IS 'Nombre del premio, con al menos un carácter distinto de espacio. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Premio"."categoría" IS 'Categoría del premio como texto no vacío; sin catálogo impuesto. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Premio"."rangoEdad" IS 'Rango de edad al que se dirige el premio como texto no vacío; sin catálogo impuesto. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "Canje" IS 'Historial de canjes de premios: cliente, sucursal, premio y encargado que intervinieron, con los puntos utilizados; se conserva frente al borrado de sus referencias.';
COMMENT ON COLUMN "Canje"."idCanje" IS 'Identificador positivo del canje; llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."idSucursal" IS 'Sucursal donde se realizó el canje; referencia a SUCURSAL. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."idCliente" IS 'Cliente que realizó el canje; referencia a Cliente. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."idPremio" IS 'Premio entregado; referencia a Premio. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."CURP" IS 'CURP del encargado de premios que atendió el canje; debe existir en Encargado de premios. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."hora" IS 'Hora del canje, sin zona horaria (time). Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."puntosUtilizados" IS 'Puntos descontados en el canje, enteros positivos. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."cantidadPremios" IS 'Unidades del premio entregadas, enteros positivos. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Canje"."fecha" IS 'Fecha finita del canje; el esquema no prohíbe fechas futuras. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "Disponer" IS 'Existencia actual de cada premio en cada sucursal; una fila por pareja sucursal-premio de la relación M:N.';
COMMENT ON COLUMN "Disponer"."idSucursal" IS 'Sucursal que tiene el premio; referencia a SUCURSAL y parte de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Disponer"."idPremio" IS 'Premio del que se registra la existencia; referencia a Premio y parte de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Disponer"."cantidadDisponible" IS 'Unidades disponibles en la sucursal, enteros no negativos; 0 indica que no hay existencia. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "Encargado de premios" IS 'Personal de sucursal que atiende los canjes de premios; se identifica por su CURP.';
COMMENT ON COLUMN "Encargado de premios"."CURP" IS 'CURP de 18 caracteres del encargado; llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."idSucursal" IS 'Sucursal a la que está adscrito el encargado; referencia a SUCURSAL. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."Nombre" IS 'Nombre del encargado, con al menos un carácter distinto de espacio. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."ApellidoMaterno" IS 'Apellido materno del encargado, no vacío. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."ApellidoPaterno" IS 'Apellido paterno del encargado, no vacío. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."RFC" IS 'RFC de 13 caracteres del encargado; único entre encargados. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."fechaContratación" IS 'Fecha finita de contratación, no posterior al día actual. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."salario" IS 'Salario con dos decimales, no negativo. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."fechaNacimiento" IS 'Fecha de nacimiento finita, no posterior al día actual. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "Encargado de premios"."horarioTrabajo" IS 'Hora de inicio del turno; solo se admiten las 07:00 y las 15:00. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "CorreoElectrónicoEncargado" IS 'Direcciones de correo de cada encargado de premios; dependientes de su propietario.';
COMMENT ON COLUMN "CorreoElectrónicoEncargado"."CURP" IS 'Encargado propietario; parte de la llave primaria y referencia a Encargado de premios. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "CorreoElectrónicoEncargado"."correoEncargado" IS 'Dirección de correo; parte de la llave primaria. Un @, sin espacios y con ambas partes no vacías; no certifica la existencia del buzón. Obligatorio (NOT NULL); sin valor predeterminado.';

COMMENT ON TABLE "TeléfonoEncargado" IS 'Números telefónicos de cada encargado de premios; dependientes de su propietario.';
COMMENT ON COLUMN "TeléfonoEncargado"."CURP" IS 'Encargado propietario; parte de la llave primaria y referencia a Encargado de premios. Obligatorio (NOT NULL); sin valor predeterminado.';
COMMENT ON COLUMN "TeléfonoEncargado"."telefonoEncargado" IS 'Número de exactamente diez dígitos; parte de la llave primaria. Obligatorio (NOT NULL); sin valor predeterminado.';

-- Restricciones: Premio
COMMENT ON CONSTRAINT "pk_premio" ON "Premio" IS 'Llave primaria: idPremio identifica de forma única cada premio.';
COMMENT ON CONSTRAINT "ck_premio_id" ON "Premio" IS 'Exige idPremio mayor que cero.';
COMMENT ON CONSTRAINT "ck_premio_valor" ON "Premio" IS 'Exige valorAproximado no negativo.';
COMMENT ON CONSTRAINT "ck_premio_puntos" ON "Premio" IS 'Exige puntosNecesarios mayor que cero.';
COMMENT ON CONSTRAINT "ck_premio_nombre" ON "Premio" IS 'Exige nombre con al menos un carácter distinto de espacio.';
COMMENT ON CONSTRAINT "ck_premio_categoria" ON "Premio" IS 'Exige categoría con al menos un carácter distinto de espacio.';
COMMENT ON CONSTRAINT "ck_premio_edad" ON "Premio" IS 'Exige rangoEdad con al menos un carácter distinto de espacio.';
COMMENT ON CONSTRAINT "Premio_idPremio_not_null" ON "Premio" IS 'Exige un valor no nulo en "idPremio".';
COMMENT ON CONSTRAINT "Premio_valorAproximado_not_null" ON "Premio" IS 'Exige un valor no nulo en "valorAproximado".';
COMMENT ON CONSTRAINT "Premio_puntosNecesarios_not_null" ON "Premio" IS 'Exige un valor no nulo en "puntosNecesarios".';
COMMENT ON CONSTRAINT "Premio_nombre_not_null" ON "Premio" IS 'Exige un valor no nulo en "nombre".';
COMMENT ON CONSTRAINT "Premio_categoría_not_null" ON "Premio" IS 'Exige un valor no nulo en "categoría".';
COMMENT ON CONSTRAINT "Premio_rangoEdad_not_null" ON "Premio" IS 'Exige un valor no nulo en "rangoEdad".';

-- Restricciones: Canje
COMMENT ON CONSTRAINT "pk_canje" ON "Canje" IS 'Llave primaria: idCanje identifica de forma única cada canje.';
COMMENT ON CONSTRAINT "ck_canje_id" ON "Canje" IS 'Exige idCanje mayor que cero.';
COMMENT ON CONSTRAINT "ck_canje_sucursal" ON "Canje" IS 'Exige idSucursal mayor que cero.';
COMMENT ON CONSTRAINT "ck_canje_cliente" ON "Canje" IS 'Exige idCliente mayor que cero.';
COMMENT ON CONSTRAINT "ck_canje_premio" ON "Canje" IS 'Exige idPremio mayor que cero.';
COMMENT ON CONSTRAINT "ck_canje_curp" ON "Canje" IS 'Exige el formato de CURP: cuatro letras, seis dígitos, H o M, cinco letras y dos caracteres alfanuméricos.';
COMMENT ON CONSTRAINT "ck_canje_puntos" ON "Canje" IS 'Exige puntosUtilizados mayor que cero.';
COMMENT ON CONSTRAINT "ck_canje_cantidad" ON "Canje" IS 'Exige cantidadPremios mayor que cero.';
COMMENT ON CONSTRAINT "ck_canje_fecha" ON "Canje" IS 'Exige fecha finita.';
COMMENT ON CONSTRAINT "fk_canje_sucursal" ON "Canje" IS 'Referencia a SUCURSAL(idSucursal). ON DELETE RESTRICT conserva el historial; ON UPDATE CASCADE propaga correcciones del identificador.';
COMMENT ON CONSTRAINT "fk_canje_cliente" ON "Canje" IS 'Referencia a Cliente(idCliente). ON DELETE RESTRICT impide borrar clientes con canjes; ON UPDATE CASCADE propaga correcciones del identificador.';
COMMENT ON CONSTRAINT "fk_canje_premio" ON "Canje" IS 'Referencia a Premio(idPremio). ON DELETE RESTRICT impide borrar premios ya canjeados; ON UPDATE CASCADE propaga correcciones del identificador.';
COMMENT ON CONSTRAINT "fk_canje_encargado" ON "Canje" IS 'Referencia a Encargado de premios(CURP). ON DELETE RESTRICT conserva la atribución del canje; ON UPDATE CASCADE propaga correcciones de CURP.';
COMMENT ON CONSTRAINT "Canje_idCanje_not_null" ON "Canje" IS 'Exige un valor no nulo en "idCanje".';
COMMENT ON CONSTRAINT "Canje_idSucursal_not_null" ON "Canje" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "Canje_idCliente_not_null" ON "Canje" IS 'Exige un valor no nulo en "idCliente".';
COMMENT ON CONSTRAINT "Canje_idPremio_not_null" ON "Canje" IS 'Exige un valor no nulo en "idPremio".';
COMMENT ON CONSTRAINT "Canje_CURP_not_null" ON "Canje" IS 'Exige un valor no nulo en "CURP".';
COMMENT ON CONSTRAINT "Canje_hora_not_null" ON "Canje" IS 'Exige un valor no nulo en "hora".';
COMMENT ON CONSTRAINT "Canje_puntosUtilizados_not_null" ON "Canje" IS 'Exige un valor no nulo en "puntosUtilizados".';
COMMENT ON CONSTRAINT "Canje_cantidadPremios_not_null" ON "Canje" IS 'Exige un valor no nulo en "cantidadPremios".';
COMMENT ON CONSTRAINT "Canje_fecha_not_null" ON "Canje" IS 'Exige un valor no nulo en "fecha".';

-- Restricciones: Disponer
COMMENT ON CONSTRAINT "pk_disponer" ON "Disponer" IS 'Llave primaria compuesta: una sola fila por pareja sucursal-premio.';
COMMENT ON CONSTRAINT "ck_disponer_sucursal" ON "Disponer" IS 'Exige idSucursal mayor que cero.';
COMMENT ON CONSTRAINT "ck_disponer_premio" ON "Disponer" IS 'Exige idPremio mayor que cero.';
COMMENT ON CONSTRAINT "ck_disponer_cantidad" ON "Disponer" IS 'Exige cantidadDisponible no negativa.';
COMMENT ON CONSTRAINT "fk_disponer_sucursal" ON "Disponer" IS 'Referencia a SUCURSAL(idSucursal). ON DELETE CASCADE elimina las existencias de una sucursal sin actividad; ON UPDATE CASCADE propaga correcciones del identificador.';
COMMENT ON CONSTRAINT "fk_disponer_premio" ON "Disponer" IS 'Referencia a Premio(idPremio). ON DELETE CASCADE elimina las existencias de un premio sin canjes; ON UPDATE CASCADE propaga correcciones del identificador.';
COMMENT ON CONSTRAINT "Disponer_idSucursal_not_null" ON "Disponer" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "Disponer_idPremio_not_null" ON "Disponer" IS 'Exige un valor no nulo en "idPremio".';
COMMENT ON CONSTRAINT "Disponer_cantidadDisponible_not_null" ON "Disponer" IS 'Exige un valor no nulo en "cantidadDisponible".';

-- Restricciones: Encargado de premios
COMMENT ON CONSTRAINT "pkencargadodepremios" ON "Encargado de premios" IS 'Llave primaria: la CURP identifica de forma única a cada encargado.';
COMMENT ON CONSTRAINT "uqencargadodepremiosrfc" ON "Encargado de premios" IS 'Exige RFC único entre encargados.';
COMMENT ON CONSTRAINT "ckencargadopremioscurp" ON "Encargado de premios" IS 'Exige el formato de CURP: cuatro letras, seis dígitos, H o M, cinco letras y dos caracteres alfanuméricos.';
COMMENT ON CONSTRAINT "ckencargadopremiosidsucursalpositivo" ON "Encargado de premios" IS 'Exige idSucursal mayor que cero.';
COMMENT ON CONSTRAINT "ckencargadopremiosnombrenovacio" ON "Encargado de premios" IS 'Exige Nombre no vacío.';
COMMENT ON CONSTRAINT "ckencargadopremiosapellidomaternonovacio" ON "Encargado de premios" IS 'Exige ApellidoMaterno no vacío.';
COMMENT ON CONSTRAINT "ckencargadopremios_pellidopaternonovacio" ON "Encargado de premios" IS 'Exige ApellidoPaterno no vacío.';
COMMENT ON CONSTRAINT "ckencargadopremiosrfc" ON "Encargado de premios" IS 'Exige el formato de RFC: letras, fecha de seis dígitos y homoclave.';
COMMENT ON CONSTRAINT "ckencargadopremiossalariononegativo" ON "Encargado de premios" IS 'Exige salario no negativo y distinto de NaN.';
COMMENT ON CONSTRAINT "ckencargadopremiosfechacontrataciónfutura" ON "Encargado de premios" IS 'Exige fechaContratación finita y no posterior al día actual.';
COMMENT ON CONSTRAINT "ck_ncargadopremiosfechanacimientonofutura" ON "Encargado de premios" IS 'Exige fechaNacimiento finita y no posterior al día actual.';
COMMENT ON CONSTRAINT "ckencargadopremioshorariotrabajo" ON "Encargado de premios" IS 'Exige horarioTrabajo igual a 07:00:00 o 15:00:00.';
COMMENT ON CONSTRAINT "fkencargadopremiossucursal" ON "Encargado de premios" IS 'Referencia a SUCURSAL(idSucursal). ON DELETE RESTRICT impide borrar sucursales con encargados; ON UPDATE CASCADE propaga correcciones del identificador.';
COMMENT ON CONSTRAINT "Encargado de premios_CURP_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "CURP".';
COMMENT ON CONSTRAINT "Encargado de premios_idSucursal_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "idSucursal".';
COMMENT ON CONSTRAINT "Encargado de premios_Nombre_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "Nombre".';
COMMENT ON CONSTRAINT "Encargado de premios_ApellidoMaterno_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "ApellidoMaterno".';
COMMENT ON CONSTRAINT "Encargado de premios_ApellidoPaterno_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "ApellidoPaterno".';
COMMENT ON CONSTRAINT "Encargado de premios_RFC_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "RFC".';
COMMENT ON CONSTRAINT "Encargado de premios_fechaContratación_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "fechaContratación".';
COMMENT ON CONSTRAINT "Encargado de premios_salario_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "salario".';
COMMENT ON CONSTRAINT "Encargado de premios_fechaNacimiento_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "fechaNacimiento".';
COMMENT ON CONSTRAINT "Encargado de premios_horarioTrabajo_not_null" ON "Encargado de premios" IS 'Exige un valor no nulo en "horarioTrabajo".';

-- Restricciones: CorreoElectrónicoEncargado
COMMENT ON CONSTRAINT "pk_correo_encargado" ON "CorreoElectrónicoEncargado" IS 'Llave primaria compuesta: un correo no se repite para el mismo encargado.';
COMMENT ON CONSTRAINT "ck_correo_encargado_formato" ON "CorreoElectrónicoEncargado" IS 'Comprobación básica de correo: un @, partes no vacías y sin espacios; no verifica la existencia del buzón.';
COMMENT ON CONSTRAINT "fk_correo_encargado" ON "CorreoElectrónicoEncargado" IS 'Referencia a Encargado de premios(CURP). ON DELETE CASCADE elimina los correos con su encargado; ON UPDATE CASCADE propaga correcciones de CURP.';
COMMENT ON CONSTRAINT "CorreoElectrónicoEncargado_CURP_not_null" ON "CorreoElectrónicoEncargado" IS 'Exige un valor no nulo en "CURP".';
COMMENT ON CONSTRAINT "CorreoElectrónicoEncargado_correoEncargado_not_null" ON "CorreoElectrónicoEncargado" IS 'Exige un valor no nulo en "correoEncargado".';

-- Restricciones: TeléfonoEncargado
COMMENT ON CONSTRAINT "pk_telefono_encargado" ON "TeléfonoEncargado" IS 'Llave primaria compuesta: un teléfono no se repite para el mismo encargado.';
COMMENT ON CONSTRAINT "ck_telefono_encargado_formato" ON "TeléfonoEncargado" IS 'Exige telefonoEncargado de exactamente diez dígitos.';
COMMENT ON CONSTRAINT "fk_telefono_encargado" ON "TeléfonoEncargado" IS 'Referencia a Encargado de premios(CURP). ON DELETE CASCADE elimina los teléfonos con su encargado; ON UPDATE CASCADE propaga correcciones de CURP.';
COMMENT ON CONSTRAINT "TeléfonoEncargado_CURP_not_null" ON "TeléfonoEncargado" IS 'Exige un valor no nulo en "CURP".';
COMMENT ON CONSTRAINT "TeléfonoEncargado_telefonoEncargado_not_null" ON "TeléfonoEncargado" IS 'Exige un valor no nulo en "telefonoEncargado".';
COMMIT;