# Elección y validación de políticas del módulo 01

**Omar Alejandro Juárez Larrondo · 322245244**
Práctica 06 · Equipo ÑIPGG · 2 de noviembre de 2026.

## Alcance y criterio

Implemento las políticas de las seis FK cuya tabla origen pertenece a Cliente,
correoElectrónico, teléfono, Tarjeta o Partida. Documento sus cinco tablas,
26 columnas y todas sus restricciones. La base mantiene la estructura de la
práctica 05, incluida la unicidad de idCliente en Tarjeta: cada cliente tiene
como máximo una tarjeta. No modifico módulos ajenos.

Las acciones siguientes son decisiones de diseño para este módulo: eliminar
contactos dependientes, conservar recursos e historial, y propagar correcciones
de claves. Ninguna de estas políticas permite insertar hijos huérfanos.

## 5. Política elegida y motivos por relación

| FK | ON DELETE | ON UPDATE |
|---|---|---|
| fk_correo_cliente | CASCADE | CASCADE |
| fk_telefono_cliente | CASCADE | CASCADE |
| fk_tarjeta_cliente | NO ACTION | CASCADE |
| fk_tarjeta_cajero | NO ACTION | CASCADE |
| fk_partida_tarjeta | NO ACTION | CASCADE |
| fk_partida_maquina | NO ACTION | CASCADE |

### Contactos: fk_correo_cliente y fk_telefono_cliente

El correo y el teléfono describen a su cliente y no tienen una existencia
independiente en el modelo. DELETE CASCADE elimina esos contactos cuando se
elimina un cliente sin otras dependencias protegidas. UPDATE CASCADE conserva
la asociación si se corrige idCliente, actualizando también la parte de su PK.
Descarto NO ACTION para el borrado de contactos porque exigiría una limpieza
manual sin aportar conservación de historial. SET NULL rompería NOT NULL y la
PK compuesta. No hay un propietario predeterminado al que reasignarlos.

Si el cliente tiene tarjeta, fk_tarjeta_cliente bloquea el borrado completo.
La eliminación de contactos no debe interpretarse como una autorización para
eliminar al cliente cuando otras FK lo impiden: toda la sentencia se revierte.

### Tarjeta: fk_tarjeta_cliente

DELETE NO ACTION impide eliminar al propietario de una tarjeta existente. La
tarjeta tiene saldo y puntos, por lo que borrarla en cascada sería una pérdida
inadecuada como efecto de borrar al cliente. UPDATE CASCADE propaga idCliente
a Tarjeta y, mediante fk_partida_tarjeta, a sus partidas. Mantiene la PK
(idCliente, numeroTarjeta) y UNIQUE(idCliente); la corrección a un identificador
ya ocupado sigue sujeta a las restricciones de unicidad.

Descarto SET NULL porque idCliente es obligatorio y pertenece a la PK. No
existe un cliente predeterminado válido que preserve la propiedad. Un UPDATE
NO ACTION haría necesaria la corrección manual coordinada de las referencias.

### Tarjeta: fk_tarjeta_cajero

DELETE NO ACTION conserva al cajero identificado como responsable de la venta
mientras tenga tarjetas asociadas. Su baja operativa no se representa borrando
el registro referenciado. UPDATE CASCADE permite corregir su CURP sin perder
esa atribución. Descarto DELETE CASCADE por el riesgo de borrar tarjetas ajenas
a la existencia laboral del cajero. CURP es NOT NULL, no tiene DEFAULT y no
sería correcto atribuir automáticamente las ventas a otra persona.

### Partida: fk_partida_tarjeta

DELETE NO ACTION evita perder partidas por eliminar su tarjeta. UPDATE CASCADE
propaga los dos componentes (idCliente, numeroTarjeta), conservando la
referencia completa; idMaquina e idPartida no cambian por esa corrección.
La PK de Partida sigue siendo (idCliente, numeroTarjeta, idMaquina, idPartida).

Descarto DELETE CASCADE porque las partidas constituyen historial. SET NULL
rompería tanto NOT NULL como la PK. Un valor predeterminado no identifica la
tarjeta real de la actividad. Probé cambios de numeroTarjeta, de idCliente por
la cadena desde Cliente y de ambos componentes simultáneamente.

### Partida: fk_partida_maquina

DELETE NO ACTION conserva la referencia al equipo en el que ocurrió la partida.
La retirada de una máquina puede representarse en su estado, sin borrar su
identidad histórica. UPDATE CASCADE corrige idMaquina también en la PK de
Partida. Descarto DELETE CASCADE por la pérdida de historial, y SET NULL o
SET DEFAULT por la obligatoriedad y por no existir una máquina sustituta válida.

## Compatibilidad con la base y efectos entre módulos

Las seis FK permanecen NOT DEFERRABLE, con nombres, columnas y destinos
originales. Todas las columnas siguen siendo obligatorias y sin DEFAULT.
Las acciones CASCADE actualizan claves, pero no eliminan la validación de sus
CHECK, PK o UNIQUE. Las políticas tampoco implementan una baja lógica ni un
sistema de auditoría de cambios de identificadores.

Las FK de VISITA y RECARGA hacia Tarjeta conservan en la base ON UPDATE
NO ACTION. Probé que, cuando existen esas filas, una corrección de idCliente
se bloquea y revierte la cadena Cliente-Tarjeta-Partida. Es un resultado válido
de integridad con la base actual, no una propagación global garantizada. Yahir
puede elegir UPDATE CASCADE en sus relaciones si el equipo desea permitir esa
corrección a través de todo el historial. La elección debe quedar acordada
antes de integrar; este módulo no modifica esas FK.

Otras relaciones también pueden bloquear operaciones: Canje referencia Cliente;
RECARGA y los contactos del cajero referencian Cajero; Mantenimiento referencia
Máquina. El resultado final depende de todas las referencias existentes. Los
casos de mi módulo aíslan cada FK y añaden pruebas explícitas de VISITA y RECARGA.

## Verificación ejecutada

Se utilizó PostgreSQL 18.6 en un contenedor aislado y el DDL completo de 30
tablas. El SHA-256 de la base es
`588c7910e549284264d0a923dd7a5c6091cd62fd4987063dac388c12a2e99230`.

**Resultado: 37 casos correctos, ninguno fallido.**

- 24 casos: DELETE y UPDATE del padre, INSERT y UPDATE huérfanos para cada FK.
- 4 casos: cadena Cliente-Tarjeta-Partida, cambio de ambos componentes,
  referencia compuesta inexistente y borrado de cliente sin tarjeta.
- 2 casos: bloqueo y reversión de la cadena por VISITA y por RECARGA.
- 3 casos: NO ACTION inmediato, NO ACTION diferido reparado y RESTRICT.
- 4 casos de catálogo: políticas de las seis FK y comentarios de 5 tablas,
  26 columnas y 62 constraints (incluidos 26 NOT NULL de PostgreSQL 18).

Las operaciones rechazadas comprueban la restricción que causó el error y el
estado conservado; las permitidas comprueban las filas resultantes. El conjunto
termina con ROLLBACK y verifica que las 30 tablas quedan sin datos de prueba.
Las pruebas se ejecutan sobre una base aislada vacía, nunca sobre datos reales.

En PostgreSQL 18, el ejemplo RESTRICT produjo restrict_violation (23001);
los rechazos por NO ACTION y las referencias inexistentes produjeron
foreign_key_violation (23503). Ambos se manejan sin ocultar errores inesperados.

## Reproducción y evidencia

En una base PostgreSQL 18 nueva, desde la raíz de Practica06:

```sh
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f base/DDL_practica05.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/01_clientes_tarjetas_partidas/politicas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/01_clientes_tarjetas_partidas/comentarios.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/01_clientes_tarjetas_partidas/pruebas.sql
```

El resultado se reproduce ejecutando `pruebas.sql`: debe mostrar 37 casos
correctos y confirmar que no quedan datos tras ROLLBACK. El PDF único
`Docs/Práctica06.pdf` contiene por ahora la aportación de este módulo, con
portada del equipo. La integración con las aportaciones de los otros cuatro
integrantes queda fuera de esta validación individual.
