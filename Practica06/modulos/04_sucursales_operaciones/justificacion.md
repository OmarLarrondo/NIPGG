
# Elección y validación de políticas del módulo 04

**Yahir · Módulo 04 · Sucursales, visitas y recargas**

## Alcance y criterio

Implemento las políticas de las seis FK cuya tabla origen pertenece a
`SUCURSAL`, `HORARIO_SUCURSAL`, `VISITA` o `RECARGA`. Documento sus cuatro
tablas, 24 columnas y todas sus restricciones (33 nombradas más las 24
`NOT NULL` que PostgreSQL 18 registra también en `pg_constraint`). La base
mantiene la estructura de la práctica 05. No modifico módulos ajenos.

Las acciones siguientes son decisiones de diseño para este módulo: preservar
el historial de visitas y recargas, tratar los horarios como dependientes de
la sucursal y propagar correcciones de identificadores. Ninguna de estas
políticas permite insertar hijos huérfanos.

## 5. Política elegida y motivos por relación

| FK | ON DELETE | ON UPDATE |
|---|---|---|
| `fk_horario_sucursal` | CASCADE | CASCADE |
| `fk_visita_tarjeta` | RESTRICT | CASCADE |
| `fk_visita_sucursal` | RESTRICT | CASCADE |
| `fk_recarga_tarjeta` | RESTRICT | CASCADE |
| `fk_recarga_sucursal` | RESTRICT | CASCADE |
| `fk_recarga_cajero` | RESTRICT | CASCADE |

### Horario: fk_horario_sucursal

El horario no tiene existencia independiente en el modelo: `idSucursal`
forma parte de su PK compuesta con el texto del horario. `DELETE CASCADE`
elimina los horarios cuando se elimina la sucursal; los horarios no son
historial y son reconstruibles. `UPDATE CASCADE` propaga la corrección de
`idSucursal`, conservando la PK compuesta. Descarto `NO ACTION` y `RESTRICT`
porque bloquearían el borrado de una sucursal cuyos horarios son fácilmente
reconstruibles. `SET NULL` rompería `NOT NULL` y la PK. No hay una sucursal
predeterminada válida.

### Visita: fk_visita_tarjeta

`DELETE RESTRICT` impide eliminar una tarjeta con visitas registradas. Las
visitas son historial de uso y no deben perderse como efecto de borrar la
tarjeta; la operación debe resolverse explícitamente. `UPDATE CASCADE`
propaga ambos componentes `(idCliente, numeroTarjeta)` a la PK compuesta de
`VISITA`, manteniendo la referencia completa. Elijo `RESTRICT` sobre
`NO ACTION` porque la verificación es inmediata y no permite diferir la
comprobación al final de una transacción: para historial se quiere el
rechazo en el punto exacto de la operación. `SET NULL` rompería `NOT NULL`
y la PK. Un valor predeterminado no identifica la tarjeta real.

### Visita: fk_visita_sucursal

`DELETE RESTRICT` conserva el registro de visitas por sucursal. La sucursal
puede darse de baja en su estado sin borrar su identidad histórica.
`UPDATE CASCADE` propaga `idSucursal` a la PK compuesta de `VISITA`,
conservando la referencia. Al igual que en `fk_visita_tarjeta`, elijo
`RESTRICT` sobre `NO ACTION` por el rechazo inmediato que se desea para
historial. Descarto `DELETE CASCADE` por pérdida de historial, y `SET NULL`
o `SET DEFAULT` por la obligatoriedad y por no existir una sucursal
sustituta válida.

### Recarga: fk_recarga_tarjeta

`DELETE RESTRICT` protege el historial financiero: una recarga no debe
quedar huérfana ni perderse como efecto de borrar la tarjeta. `UPDATE
CASCADE` propaga la pareja de identificadores a la PK compuesta de
`RECARGA`. Se prefiere `RESTRICT` sobre `NO ACTION` por la comprobación
inmediata. Descarto `DELETE CASCADE` porque borraría movimientos
monetarios; `SET NULL` por `NOT NULL` y PK; `SET DEFAULT` porque no existe
una tarjeta predeterminada que identifique la operación real.

### Recarga: fk_recarga_sucursal

`DELETE RESTRICT` preserva el historial de recargas por sucursal. La baja
de una sucursal no debe eliminar movimientos financieros. `UPDATE CASCADE`
propaga `idSucursal` a la PK compuesta de `RECARGA`. Descarto `DELETE
CASCADE` por la pérdida de historial, `NO ACTION` porque se quiere rechazo
inmediato en el punto de la operación, y `SET NULL` o `SET DEFAULT` por
incompatibilidad con `NOT NULL`/PK y por falta de una sucursal sustituta
válida.

### Recarga: fk_recarga_cajero

`DELETE RESTRICT` conserva la atribución de la recarga al cajero que
procesó el cobro. La baja operativa del cajero no se representa borrando
el registro referenciado. `UPDATE CASCADE` permite corregir su `CURP` sin
perder la atribución. Se prefiere `RESTRICT` sobre `NO ACTION` por el
rechazo inmediato. Descarto `DELETE CASCADE` por el riesgo de borrar
recargas ajenas a la existencia laboral del cajero. `SET NULL` rompería
`NOT NULL` y la PK compuesta (`CURP` forma parte de ella). No hay una CURP
predeterminada válida.

## Compatibilidad con la base y efectos entre módulos

Las seis FK permanecen `NOT DEFERRABLE`, con nombres, columnas y destinos
originales. Todas las columnas siguen siendo obligatorias y sin `DEFAULT`.
Las acciones CASCADE actualizan claves, pero no eliminan la validación de
sus `CHECK`, `PK` o `UNIQUE`.

El cambio respecto al DDL heredado es deliberado. Ahora:

- `HORARIO_SUCURSAL` pasa a borrado en cascada con la sucursal.
- `VISITA` y `RECARGA` bloquean el borrado de `Tarjeta`, `SUCURSAL` y
  `Cajero` con `RESTRICT`.
- Las seis usan `UPDATE CASCADE` para propagar correcciones de
  identificadores.

## Verificación ejecutada

Se utilizó PostgreSQL 18.6 en una base aislada con el DDL completo de 30
tablas, `politicas.sql` y `comentarios.sql` aplicados. El SHA-256 de la
base es
`588c7910e549284264d0a923dd7a5c6091cd62fd4987063dac388c12a2e99230`.

**Resultado: 29 casos correctos, ninguno fallido.**

- 24 casos: `DELETE` del padre, `UPDATE` del padre, `INSERT` huérfano y
  `UPDATE` huérfano para cada una de las 6 FK. En `DELETE` se verifica la
  acción declarada (`CASCADE` o `RESTRICT`); en `UPDATE` se verifica la
  propagación de la clave; los huérfanos se rechazan con la restricción
  esperada.
- 1 caso: cadena `SUCURSAL → HORARIO_SUCURSAL → VISITA → RECARGA` con
  `UPDATE CASCADE`. Se comprueba que una corrección del `idSucursal` se
  propaga a las tres tablas hijas dentro de la misma transacción y que
  ningún hijo conserva el id antiguo.
- 1 caso: 4 tablas con comentario registrado.
- 1 caso: 24 columnas con comentario registrado.
- 1 caso: todas las restricciones del módulo con comentario registrado.
- 1 caso: seis FK explícitas con `confupdtype='c'`, `NOT DEFERRABLE` y
  `confdeltype` consistente con `CASCADE` para `HORARIO_SUCURSAL` y
  `RESTRICT` para `VISITA` y `RECARGA`.

Las operaciones rechazadas comprueban la restricción que causó el error y
el estado conservado. Las permitidas comprueban las filas resultantes. El
conjunto termina con `ROLLBACK` y verifica que las tablas del módulo quedan
sin datos de prueba.

En PostgreSQL 18, los rechazos por `RESTRICT` produjeron
`restrict_violation` (23001); los rechazos por referencia inexistente
produjeron `foreign_key_violation` (23503). Ambos se manejan sin ocultar
errores inesperados.

## Reproducción y evidencia

En una base PostgreSQL 18 nueva, desde la raíz de `Practica06`:

```sh
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f base/DDL_practica05.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/04_sucursales_operaciones/politicas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/04_sucursales_operaciones/comentarios.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/04_sucursales_operaciones/pruebas.sql
