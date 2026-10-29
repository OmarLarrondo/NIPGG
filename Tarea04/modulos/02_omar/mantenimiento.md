# Mantenimiento — Omar Larrondo

## M_a — Borrar toda la información del cliente Paul Stevenson

Trabajo sobre el dataset original. La selección por nombre identifica una sola tupla, cuyo customerid es `PS-18970`. Se eliminan sus renglones de orders antes de eliminar el cliente. products es un catálogo compartido y no almacena información personal del cliente; se conserva íntegro.

### Álgebra con asignación

P ← σ_{customername='Paul Stevenson'}(customer)

I ← π_{customerid}(P)

B ← orders ⋈ I

orders ← orders − B

customer ← customer − P

P, I y B se calculan sobre el estado original. La junta con I solo agrega el atributo ya presente customerid, por lo que B tiene exactamente el esquema de orders y la diferencia es compatible.

### Cliente afectado

| customerid | customername | segment | country | city | state | postalcode | region |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PS-18970 | Paul Stevenson | Home Office | United States | Chicago | Illinois | 60610 | Central |

### Renglones afectados

| orderid | orderdate | shipdate | shipmode | productid | quantity |
| --- | --- | --- | --- | --- | --- |
| US-2015-164175 | 2015-04-30 | 2015-05-05 | Standard Class | FUR-CH-10001146 | 5 |
| CA-2015-140830 | 2015-11-30 | 2015-12-02 | Second Class | OFF-EN-10000461 | 2 |
| CA-2015-140830 | 2015-11-30 | 2015-12-02 | Second Class | OFF-EN-10002831 | 2 |
| US-2017-111920 | 2017-10-22 | 2017-10-26 | Standard Class | OFF-AR-10003179 | 4 |
| CA-2017-163818 | 2017-10-04 | 2017-10-08 | Standard Class | FUR-FU-10000076 | 1 |
| CA-2016-161158 | 2016-05-09 | 2016-05-13 | Standard Class | OFF-AR-10000462 | 5 |

### Comprobación

| Relación | Antes | Eliminadas | Después |
| --- | ---: | ---: | ---: |
| customer | 793 | 1 | 792 |
| orders | 5999 | 6 | 5993 |
| products | 1862 | 0 | 1862 |

Las cardinalidades usan semántica de conjuntos: el archivo contiene 6000 renglones de orders, uno de ellos duplicado; Relax opera con 5999 tuplas distintas.

Se afectan 5 órdenes distintas: CA-2015-140830 tiene dos productos. Después no queda el cliente ni ningún renglón con customerid='PS-18970'. La diferencia entre los conjuntos original y posterior coincide exactamente con las tuplas seleccionadas para borrar. No se generan referencias huérfanas hacia customer.

Relax calcula relaciones; estas expresiones no modifican permanentemente el gist. `mantenimiento_a_cliente.relax` calcula customer posterior, `mantenimiento_a_ordenes.relax` calcula orders posterior y `mantenimiento_a_afectadas.relax` muestra los renglones a borrar. Cada archivo se ejecuta desde el dataset original. Las asignaciones anteriores expresan la operación de mantenimiento solicitada.
