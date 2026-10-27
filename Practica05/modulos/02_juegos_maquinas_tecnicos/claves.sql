-- Práctica 05 | Juegos, máquinas y técnicos
-- Responsable: Ana
-- Tablas asignadas: TipoJuego, Juego, Máquina, Mantenimiento, Técnico, CertificacionTecnico
-- Llaves primarias tomadas de las marcas PK del diagrama relacional.

ALTER TABLE "TipoJuego"
    ADD CONSTRAINT pk_tipo_juego PRIMARY KEY ("idTipo");

ALTER TABLE "Juego"
    ADD CONSTRAINT pk_juego PRIMARY KEY ("idJuego");

ALTER TABLE "Máquina"
    ADD CONSTRAINT pk_maquina PRIMARY KEY ("idMaquina");

ALTER TABLE "Mantenimiento"
    ADD CONSTRAINT pk_mantenimiento PRIMARY KEY ("idMantenimiento");

ALTER TABLE "Técnico"
    ADD CONSTRAINT pk_tecnico PRIMARY KEY ("CURP");
    ADD CONSTRAINT ck_tecnico_rfc CHECK ("RFC" ~ '^[A-ZÑ&]{4}[0-9]{6}[A-Z0-9]{3}$');

ALTER TABLE "CertificacionTecnico"
    ADD CONSTRAINT pk_certificacion_tecnico PRIMARY KEY ("CURP", "Certificaciones");
    ADD CONSTRAINT ck_certificacion_tecnico_curp CHECK ("CURP" ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z]{2}$');
