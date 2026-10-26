-- Práctica 05 | Personal y administración
-- Responsable: Diego
-- Tablas asignadas: Empleado, Gerente, Cajero, EncargadoDePremios, Administrar
-- Definir mediante ALTER TABLE las FOREIGN KEY de las tablas de este módulo; acordar nombre, tipo y clave destino con su responsable.

-- 1. Gerente -> Sucursal
ALTER TABLE gerente
	ADD CONSTRAINT fkgerentesucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 2. Cajero -> Sucursal
ALTER TABLE cajero
	ADD CONSTRAINT fkcajerosucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 3. EncargadoDePremios -> Sucursal
ALTER TABLE encargadodepremios
	ADD CONSTRAINT fkencargadopremiossucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");

-- 4. Administrar -> Gerente
ALTER TABLE administrar
	ADD CONSTRAINT fkadministrargerente
	FOREIGN KEY (CURP)
	REFERENCES gerente (CURP);

-- 5. Administrar -> Sucursal
ALTER TABLE administrar
	ADD CONSTRAINT fkadministrarsucursal
	FOREIGN KEY (idsucursal)
	REFERENCES "SUCURSAL" ("idSucursal");
