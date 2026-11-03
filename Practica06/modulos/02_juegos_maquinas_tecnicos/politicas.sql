-- Práctica 06 | Módulo 02 | Miguel Ángel Jiménez Ramírez
-- Requiere el DDL completo de práctica 05. Aplicar antes de comentarios.sql.
BEGIN;

-- El correo depende del técnico; eliminarlo limpia sus contactos y corregir la CURP conserva su asociación.
ALTER TABLE "CorreoElectrónicoTécnico" DROP CONSTRAINT fk_correo_tecnico;
ALTER TABLE "CorreoElectrónicoTécnico" ADD CONSTRAINT fk_correo_tecnico
    FOREIGN KEY ("CURP")
    REFERENCES "Técnico" ("CURP")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- El teléfono depende del técnico; eliminarlo limpia sus contactos y corregir la CURP conserva su asociación.
ALTER TABLE "TeléfonoTécnivo" DROP CONSTRAINT fk_telefono_tecnico;
ALTER TABLE "TeléfonoTécnivo" ADD CONSTRAINT fk_telefono_tecnico
    FOREIGN KEY ("CURP")
    REFERENCES "Técnico" ("CURP")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- El mantenimiento es historial del equipo: impide borrar la máquina referenciada y propaga correcciones de su identificador a la PK compuesta.
ALTER TABLE "Mantenimiento" DROP CONSTRAINT fk_mantenimiento_maquina;
ALTER TABLE "Mantenimiento" ADD CONSTRAINT fk_mantenimiento_maquina
    FOREIGN KEY ("idMaquina")
    REFERENCES "Máquina" ("idMaquina")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- Se conserva la atribución del mantenimiento al técnico; se impide borrar al responsable y se propagan correcciones de CURP.
ALTER TABLE "Mantenimiento" DROP CONSTRAINT fk_mantenimiento_tecnico;
ALTER TABLE "Mantenimiento" ADD CONSTRAINT fk_mantenimiento_tecnico
    FOREIGN KEY ("CURP")
    REFERENCES "Técnico" ("CURP")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- El juego clasifica equipos con existencia propia; no se eliminan máquinas al borrar su juego y se propagan correcciones de idJuego.
ALTER TABLE "Máquina" DROP CONSTRAINT fk_maquina_juego;
ALTER TABLE "Máquina" ADD CONSTRAINT fk_maquina_juego
    FOREIGN KEY ("idJuego")
    REFERENCES "Juego" ("idJuego")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- Una sucursal no debe borrar equipos como efecto secundario; se impide eliminarla mientras tenga máquinas y se propaga su identificador.
ALTER TABLE "Máquina" DROP CONSTRAINT fk_maquina_sucursal;
ALTER TABLE "Máquina" ADD CONSTRAINT fk_maquina_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- El tipo es un catálogo compartido; se impide borrarlo mientras clasifique juegos y se propagan correcciones de idTipo.
ALTER TABLE "Juego" DROP CONSTRAINT fk_juego_tipo;
ALTER TABLE "Juego" ADD CONSTRAINT fk_juego_tipo
    FOREIGN KEY ("idTipo")
    REFERENCES "tipoDeJuego" ("idTipo")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- La sucursal no es propietaria de la identidad laboral del técnico; se impide borrarla mientras tenga técnicos y se propaga su identificador.
ALTER TABLE "Técnico" DROP CONSTRAINT fk_tecnico_sucursal;
ALTER TABLE "Técnico" ADD CONSTRAINT fk_tecnico_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- La certificación es un valor dependiente de su técnico; se elimina con él y se conserva al corregir la CURP, incluida su PK compuesta.
ALTER TABLE "Certificaciones" DROP CONSTRAINT fk_certificacion_tecnico;
ALTER TABLE "Certificaciones" ADD CONSTRAINT fk_certificacion_tecnico
    FOREIGN KEY ("CURP")
    REFERENCES "Técnico" ("CURP")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;
COMMIT;
