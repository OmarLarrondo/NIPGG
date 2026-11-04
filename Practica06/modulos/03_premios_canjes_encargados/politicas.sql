-- Práctica 06 | Módulo 03 | Responsable: Ana Lilia Carballido Camacateco
-- Estado: implementado; ver decisiones.csv y justificacion.md.
-- Base: ../../base/DDL_practica05.sql cargada en una base de pruebas.
-- Cada FK se recrea con DROP CONSTRAINT y ADD CONSTRAINT con el mismo nombre,
-- con ON DELETE y ON UPDATE explícitos, dentro de una transacción.
BEGIN;

-- El correo carece de utilidad sin su encargado; una corrección de CURP conserva su asociación.
ALTER TABLE "CorreoElectrónicoEncargado" DROP CONSTRAINT fk_correo_encargado;
ALTER TABLE "CorreoElectrónicoEncargado" ADD CONSTRAINT fk_correo_encargado
    FOREIGN KEY ("CURP")
    REFERENCES "Encargado de premios" ("CURP")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- El teléfono es dependiente del encargado; eliminar al propietario elimina sus contactos y corregir su CURP los conserva.
ALTER TABLE "TeléfonoEncargado" DROP CONSTRAINT fk_telefono_encargado;
ALTER TABLE "TeléfonoEncargado" ADD CONSTRAINT fk_telefono_encargado
    FOREIGN KEY ("CURP")
    REFERENCES "Encargado de premios" ("CURP")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- El canje es historial: se impide eliminar la sucursal que lo registró; una corrección del identificador se propaga.
ALTER TABLE "Canje" DROP CONSTRAINT fk_canje_sucursal;
ALTER TABLE "Canje" ADD CONSTRAINT fk_canje_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- El canje respalda puntos y premios del cliente: se impide eliminarlo mientras tenga canjes; una corrección de idCliente se propaga.
ALTER TABLE "Canje" DROP CONSTRAINT fk_canje_cliente;
ALTER TABLE "Canje" ADD CONSTRAINT fk_canje_cliente
    FOREIGN KEY ("idCliente")
    REFERENCES "Cliente" ("idCliente")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- El canje conserva el premio entregado; se impide eliminarlo del catálogo y se propagan correcciones de idPremio.
ALTER TABLE "Canje" DROP CONSTRAINT fk_canje_premio;
ALTER TABLE "Canje" ADD CONSTRAINT fk_canje_premio
    FOREIGN KEY ("idPremio")
    REFERENCES "Premio" ("idPremio")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- Se conserva la atribución del canje al encargado; se impide su eliminación y se propagan correcciones de CURP.
ALTER TABLE "Canje" DROP CONSTRAINT fk_canje_encargado;
ALTER TABLE "Canje" ADD CONSTRAINT fk_canje_encargado
    FOREIGN KEY ("CURP")
    REFERENCES "Encargado de premios" ("CURP")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;

-- La existencia por sucursal es estado, no historial: se elimina con la sucursal y una corrección del identificador se conserva.
ALTER TABLE "Disponer" DROP CONSTRAINT fk_disponer_sucursal;
ALTER TABLE "Disponer" ADD CONSTRAINT fk_disponer_sucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- Si el premio sale del catálogo sus existencias carecen de utilidad; fk_canje_premio protege a los premios ya canjeados.
ALTER TABLE "Disponer" DROP CONSTRAINT fk_disponer_premio;
ALTER TABLE "Disponer" ADD CONSTRAINT fk_disponer_premio
    FOREIGN KEY ("idPremio")
    REFERENCES "Premio" ("idPremio")
    ON DELETE CASCADE ON UPDATE CASCADE NOT DEFERRABLE;

-- El encargado no puede quedar sin sucursal: se impide eliminarla mientras tenga personal y se propagan correcciones de idSucursal.
ALTER TABLE "Encargado de premios" DROP CONSTRAINT fkencargadopremiossucursal;
ALTER TABLE "Encargado de premios" ADD CONSTRAINT fkencargadopremiossucursal
    FOREIGN KEY ("idSucursal")
    REFERENCES "SUCURSAL" ("idSucursal")
    ON DELETE RESTRICT ON UPDATE CASCADE NOT DEFERRABLE;
COMMIT;