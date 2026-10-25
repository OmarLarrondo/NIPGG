-- Práctica 05 | Omar | Modelo: Practica04.drawio.xml proporcionado.
-- Canje: el diagrama marca solamente idCanje como PK.
-- Disponer: una fila por pareja sucursal-premio de la relación M:N.
ALTER TABLE "Premio"
    ADD CONSTRAINT pk_premio PRIMARY KEY ("idPremio");
ALTER TABLE "Canje"
    ADD CONSTRAINT pk_canje PRIMARY KEY ("idCanje");
ALTER TABLE "Disponer"
    ADD CONSTRAINT pk_disponer PRIMARY KEY ("idSucursal", "idPremio");
-- No se agrega UNIQUE a nombres ni a las FK de Canje.
