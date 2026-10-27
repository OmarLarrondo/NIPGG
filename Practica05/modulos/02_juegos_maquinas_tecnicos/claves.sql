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
