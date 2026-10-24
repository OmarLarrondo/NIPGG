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
