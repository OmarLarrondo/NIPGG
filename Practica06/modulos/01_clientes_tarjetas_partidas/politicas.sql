-- Práctica 06 | Módulo 01 | Omar Alejandro Juárez Larrondo
-- Requiere el DDL completo de práctica 05. Aplicar antes de comentarios.sql.
BEGIN;

-- El contacto carece de utilidad sin su cliente; una corrección del identificador conserva su asociación.
ALTER TABLE "correoElectrónico" DROP CONSTRAINT fk_correo_cliente;
ALTER TABLE "correoElectrónico" ADD CONSTRAINT fk_correo_cliente
    FOREIGN KEY ("idCliente")
    REFERENCES "Cliente" ("idCliente")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- El teléfono es dependiente del cliente; eliminar al propietario elimina sus contactos y corregir su identificador los conserva.
ALTER TABLE "teléfono" DROP CONSTRAINT fk_telefono_cliente;
ALTER TABLE "teléfono" ADD CONSTRAINT fk_telefono_cliente
    FOREIGN KEY ("idCliente")
    REFERENCES "Cliente" ("idCliente")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- La tarjeta conserva saldo y puntos: se impide eliminar al cliente que la posee; una corrección del identificador se propaga.
ALTER TABLE "Tarjeta" DROP CONSTRAINT fk_tarjeta_cliente;
ALTER TABLE "Tarjeta" ADD CONSTRAINT fk_tarjeta_cliente
    FOREIGN KEY ("idCliente")
    REFERENCES "Cliente" ("idCliente")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- Se conserva la atribución de la venta al cajero; se impide su eliminación y se propagan correcciones de CURP.
ALTER TABLE "Tarjeta" DROP CONSTRAINT fk_tarjeta_cajero;
ALTER TABLE "Tarjeta" ADD CONSTRAINT fk_tarjeta_cajero
    FOREIGN KEY ("CURP")
    REFERENCES "Cajero" ("CURP")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- La partida es historial: se impide eliminar su tarjeta y se propagan los dos componentes de la clave.
ALTER TABLE "Partida" DROP CONSTRAINT fk_partida_tarjeta;
ALTER TABLE "Partida" ADD CONSTRAINT fk_partida_tarjeta
    FOREIGN KEY ("idCliente", "numeroTarjeta")
    REFERENCES "Tarjeta" ("idCliente", "numeroTarjeta")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;

-- La partida conserva la máquina usada; se impide eliminarla y se propagan correcciones de su identificador.
ALTER TABLE "Partida" DROP CONSTRAINT fk_partida_maquina;
ALTER TABLE "Partida" ADD CONSTRAINT fk_partida_maquina
    FOREIGN KEY ("idMaquina")
    REFERENCES "Máquina" ("idMaquina")
    ON DELETE NO ACTION ON UPDATE CASCADE NOT DEFERRABLE;
COMMIT;
