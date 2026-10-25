# Contrato del modelo · Práctica 05

## Fuente de estructura y estado

Para este avance se usa el archivo `Practica04.drawio.xml` proporcionado por
Omar, copiado a `Diagramas/RelacionalÑIPGG.drawio`. Su PNG se exportó desde ese
editable con Draw.io. El E-R se recuperó de la entrega de Práctica04. Estos
criterios documentan la integración local; no constituyen una confirmación
nueva de los otros integrantes.

El informe de Práctica04 propone cambios respecto de su diagrama. Para el
DDL se priorizan los nombres y marcas del **diagrama**, conforme a la consigna.
Se valida en PostgreSQL 18. Los módulos disponibles son 01, 03, 04 y 05; falta
la implementación de Ana (02).

## Decisiones aplicadas

- Identificadores con comillas dobles. Se conservan `SUCURSAL`,
  `HORARIO_SUCURSAL`, `VISITA`, `RECARGA`, `Encargado de premios` y `Genrente`.
  `Genrente` y `TeléfonoTécnivo` son rótulos literales con erratas del modelo:
  no se corrigen en el SQL mientras no cambie el propio modelo.
- En los puestos de personal se conservan `Nombre`, `ApellidoMaterno`,
  `ApellidoPaterno`, `CURP`, `RFC` y el resto de columnas del diagrama. Se
  corrigió el SQL sin comillas que antes las convertía a minúsculas.
- No se agrega una tabla `Empleado`: el modelo guarda los datos generales en
  cada puesto. Los contactos referencian directamente a su puesto.
- `Premio`: PK `idPremio`; enteros para valor y puntos, textos de hasta 50
  caracteres. `Canje`: PK simple `idCanje`, `hora time`, cuatro FK a
  `SUCURSAL(idSucursal)`, `Cliente(idCliente)`, `Premio(idPremio)` y
  `Encargado de premios(CURP)`. Todas sus columnas son obligatorias.
- `Disponer`: PK `(idSucursal, idPremio)` para la asociación M:N; inventario
  entero no negativo, con cero permitido. Dos FK a los participantes.
- `Administrar`: PK `(CURP, idSucursal)` para impedir parejas duplicadas.
  No se agrega unicidad por participante: las marcas del diagrama no
  justifican esa restricción adicional en esta integración.
- Se conservan las PK recibidas de `Tarjeta`, `Partida`, `VISITA` y `RECARGA`.
  La PK de recarga incluye `CURP`, tal como aparece marcada en el modelo.
- Todas las restricciones se declaran mediante `ALTER TABLE`.
  Las FK de Omar usan `NO ACTION` en ambas acciones referenciales.

## Integración pendiente

El avance no define `Máquina` ni `Técnico`. Se aplazan solamente las tres FK
que apuntan a esas tablas: Partida–Máquina y los dos contactos–Técnico.
Permanecen en `SQL/referencias_pendientes.sql`; no se añaden tablas ficticias
al esquema integrado. El ensamblador impide generar el DDL final mientras
falte el módulo 02. Revisar también los nombres del módulo de Ana cuando llegue.

## Alcance de las reglas

Las FK comprueban existencia de participantes. No comprueban inventario
suficiente al canjear, suficiencia de puntos, costo histórico, descuento de
existencias ni coincidencia de la sucursal del encargado con la del canje.
Son reglas operativas entre tablas y requieren una operación transaccional.
No se declaran resueltas por CHECK locales. La restauración queda pendiente
y se realizará en una base diferente de la usada para validar el DDL.
