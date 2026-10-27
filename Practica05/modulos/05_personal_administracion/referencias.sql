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
