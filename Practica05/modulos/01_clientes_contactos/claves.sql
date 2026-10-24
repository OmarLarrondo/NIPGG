-- Práctica 05 | Clientes y contactos
-- Responsable: Miguel

ALTER TABLE "Cliente"
    ADD CONSTRAINT pk_cliente PRIMARY KEY ("idCliente");

-- El contacto es único dentro de su propietario; puede compartirse entre
-- diferentes clientes o empleados. No se impone unicidad global.
ALTER TABLE "CorreoCliente"
    ADD CONSTRAINT pk_correo_cliente PRIMARY KEY ("idCliente", "correoElectrónico");

ALTER TABLE "TelefonoCliente"
    ADD CONSTRAINT pk_telefono_cliente PRIMARY KEY ("idCliente", "teléfono");

-- Poseer es 1:1: cada cliente tiene como máximo una tarjeta.
-- numeroTarjeta se conserva como atributo; el informe no lo hace único.
ALTER TABLE "Tarjeta"
    ADD CONSTRAINT pk_tarjeta PRIMARY KEY ("idCliente");

-- El discriminante idPartida es único dentro del contexto tarjeta/máquina.
ALTER TABLE "Partida"
    ADD CONSTRAINT pk_partida PRIMARY KEY ("idCliente", "idMaquina", "idPartida");

ALTER TABLE "CorreoEmpleado"
    ADD CONSTRAINT pk_correo_empleado PRIMARY KEY ("CURP", "correoElectrónico");

ALTER TABLE "TelefonoEmpleado"
    ADD CONSTRAINT pk_telefono_empleado PRIMARY KEY ("CURP", "teléfono");

-- No se agregan UNIQUE adicionales: las identidades anteriores ya quedan
-- cubiertas por las PK y no hay otras llaves candidatas en el informe base.
