# Elección y validación de políticas del módulo 03

**Ana Lilia Carballido Camacateco**
Práctica 06 · Equipo ÑIPGG · 3 de noviembre de 2026.

## Alcance y criterio

Implemento las políticas de las nueve FK cuya tabla origen pertenece a Canje,
Disponer, Encargado de premios, CorreoElectrónicoEncargado o TeléfonoEncargado.
Premio participa como tabla destino. Documento sus seis tablas, 32 columnas y
todas sus restricciones. La base mantiene la estructura de la práctica 05:
Canje tiene PK (idCanje), Disponer tiene PK (idSucursal, idPremio) y los
contactos del encargado tienen PK compuesta con CURP. No modifico módulos ajenos.

Las acciones siguientes son decisiones de diseño para este módulo: eliminar
contactos y existencias dependientes, conservar el historial de canjes y al
personal que lo respalda, y propagar correcciones de claves. Ninguna de estas
políticas permite insertar hijos huérfanos.

Dos hechos del esquema acotan las opciones. Todas las columnas de estas FK son
NOT NULL y ninguna tiene DEFAULT, por lo que SET NULL y SET DEFAULT son inválidas
en las nueve relaciones. Además, ninguna FK necesita comprobación diferida, por
lo que entre las acciones que bloquean elijo RESTRICT en lugar de NO ACTION.

## 5. Política elegida y motivos por relación

| FK | ON DELETE | ON UPDATE |
|---|---|---|
| fk_correo_encargado | CASCADE | CASCADE |
| fk_telefono_encargado | CASCADE | CASCADE |
| fk_canje_sucursal | RESTRICT | CASCADE |
| fk_canje_cliente | RESTRICT | CASCADE |
| fk_canje_premio | RESTRICT | CASCADE |
| fk_canje_encargado | RESTRICT | CASCADE |
| fk_disponer_sucursal | CASCADE | CASCADE |
| fk_disponer_premio | CASCADE | CASCADE |
| fkencargadopremiossucursal | RESTRICT | CASCADE |

### Contactos: fk_correo_encargado y fk_telefono_encargado

El correo y el teléfono describen a su encargado y no tienen una existencia
independiente en el modelo. DELETE CASCADE elimina esos contactos cuando se
elimina un encargado sin otras dependencias protegidas, lo que además evita
retener datos personales sin finalidad. UPDATE CASCADE conserva la asociación
si se corrige la CURP, actualizando también la parte de su PK. Descarto
RESTRICT para el borrado de contactos porque exigiría una limpieza manual sin
aportar conservación de historial. SET NULL rompería NOT NULL y la PK compuesta.
No hay un propietario predeterminado al que reasignarlos.

Si el encargado tiene canjes, fk_canje_encargado bloquea el borrado completo.
La eliminación de contactos no debe interpretarse como una autorización para
eliminar al encargado cuando otras FK lo impiden: toda la sentencia se revierte
y los contactos se conservan.

### Canje: fk_canje_sucursal

DELETE RESTRICT impide eliminar una sucursal con canjes registrados. El canje
documenta un hecho (premio entregado, puntos descontados, lugar y momento) y no
debe perderse como efecto de borrar la sucursal. UPDATE CASCADE propaga
idSucursal a Canje, de modo que la corrección de un identificador no deja
canjes huérfanos. Descarto DELETE CASCADE por la pérdida de historial. SET NULL
rompería NOT NULL y SET DEFAULT no tiene un valor al que volver. El cierre de una
sucursal debe representarse en su estado, no borrando su identidad.

### Canje: fk_canje_cliente

DELETE RESTRICT impide eliminar a un cliente que tiene canjes. Esos registros
respaldan los puntos que gastó y los premios que recibió, por lo que borrarlos
en cascada sería una pérdida inadecuada como efecto de borrar al cliente.
UPDATE CASCADE propaga idCliente a Canje y se suma a la cadena que ya recorre
Cliente, Tarjeta y Partida. Descarto SET NULL porque idCliente es obligatorio y
dejaría canjes anónimos. No existe un cliente predeterminado válido.

### Canje: fk_canje_premio

DELETE RESTRICT conserva en el catálogo cualquier premio que ya se canjeó; sin
él, el historial perdería qué se entregó. Un premio que deja de ofrecerse se
representa con cantidadDisponible igual a 0 en Disponer, sin borrar su
identidad. UPDATE CASCADE corrige idPremio en Canje y también en Disponer.
Descarto DELETE CASCADE por la pérdida de historial y SET NULL o SET DEFAULT
por la obligatoriedad y por no existir un premio sustituto válido.

### Canje: fk_canje_encargado

DELETE RESTRICT conserva al encargado identificado como responsable del canje
mientras tenga canjes asociados. Su baja laboral no se representa borrando el
registro referenciado. UPDATE CASCADE permite corregir su CURP sin perder esa
atribución. Descarto DELETE CASCADE por el riesgo de borrar canjes ajenos a la
existencia laboral del encargado. CURP es NOT NULL, no tiene DEFAULT y no sería
correcto atribuir automáticamente los canjes a otra persona.

### Disponer: fk_disponer_sucursal

Disponer registra la existencia actual de cada premio en cada sucursal; es un
estado, no historial, porque los hechos pasados viven en Canje. DELETE CASCADE
elimina esas existencias cuando se elimina una sucursal sin otras dependencias
protegidas: si tiene canjes o encargados, fk_canje_sucursal o
fkencargadopremiossucursal bloquean la sentencia completa. UPDATE CASCADE
actualiza idSucursal en la PK. Descarto RESTRICT porque obligaría a vaciar el
inventario a mano sin proteger información valiosa. SET NULL rompería la PK.

### Disponer: fk_disponer_premio

Si un premio sale del catálogo, sus existencias por sucursal dejan de tener
utilidad. DELETE CASCADE solo alcanza premios sin canjes, porque
fk_canje_premio protege a los demás. UPDATE CASCADE corrige idPremio en la PK
de Disponer. RESTRICT sería una alternativa válida y más conservadora, pero
añadiría limpieza manual sin evitar ninguna pérdida real. SET NULL y SET DEFAULT
rompen NOT NULL y la PK.

### Encargado de premios: fkencargadopremiossucursal

DELETE RESTRICT impide eliminar una sucursal que todavía tiene encargados.
idSucursal es obligatorio y el encargado no puede quedar sin sucursal; borrar
al personal en cascada, y con él su historial de canjes, por un cambio
organizativo sería inadecuado. Se exige reasignar o dar de baja antes.
UPDATE CASCADE propaga idSucursal al encargado. Descarto SET NULL y SET DEFAULT
por NOT NULL y por no existir una sucursal predeterminada. El nombre de la
restricción se conserva como figura en el plan; se recomienda unificarlo a
fk_encargado_premios_sucursal.

## Compatibilidad con la base y efectos entre módulos

Las nueve FK se declaran NOT DEFERRABLE, con las columnas y destinos acordados.
Todas las columnas siguen siendo obligatorias y sin DEFAULT. Los tipos coinciden
entre origen y destino: CURP es char(18), idSucursal, idCliente e idPremio son
integer. Las acciones CASCADE actualizan claves, pero no eliminan la validación
de sus CHECK, PK o UNIQUE. Las políticas tampoco implementan una baja lógica ni
un sistema de auditoría de cambios de identificadores.

Tres FK dependen de tablas definidas fuera de este módulo. fk_canje_sucursal,
fk_disponer_sucursal y fkencargadopremiossucursal requieren que SUCURSAL exista y
tenga PK o UNIQUE en idSucursal; fk_canje_cliente requiere la PK de Cliente, que
pertenece al módulo 01. Esas FK solo pueden agregarse después de crear esas
claves.

El UPDATE CASCADE de fk_canje_cliente añade Canje a la cadena que ya recorre
Cliente, Tarjeta y Partida en el módulo 01, y el de fk_canje_sucursal extiende
la propagación de idSucursal. Una corrección puede seguir bloqueándose si otra
FK ajena conserva ON UPDATE NO ACTION; el resultado final depende de todas las
referencias existentes y debe acordarse antes de integrar. Este módulo no
modifica FK de otros integrantes.

El DELETE RESTRICT de Canje agrega además un bloqueo a la baja de clientes
(módulo 01): un cliente con tarjeta o con canjes no puede eliminarse. Esto es
coherente con la política de conservar historial del resto del equipo, que usa
NO ACTION para el mismo fin; ambas acciones bloquean la operación y solo
difieren en que RESTRICT no puede diferirse, lo que aquí no se necesita.

Limitaciones del modelo: las FK no garantizan que un canje use un premio
realmente disponible en su sucursal, porque no existe una FK compuesta de
Canje hacia Disponer, ni que el encargado pertenezca a la misma sucursal del
canje. Estas reglas requerirían cambios de modelo o disparadores y quedan fuera
de este módulo.

## Verificación ejecutada

Se ejecutó el DDL completo en una instancia temporal de PostgreSQL
`[COMPLETAR: salida de SELECT version();]`, con datos sintéticos y en una base
aislada y vacía. El SHA-256 del DDL base es `588c7910e549284264d0a923dd7a5c6091cd62fd4987063dac388c12a2e99230`.

**Resultado: 41 de 41 casos correctos, ninguno fallido.

- 36 casos: DELETE y UPDATE del padre, INSERT y UPDATE huérfanos para cada una
  de las nueve FK.
- 1 caso: baja de un encargado sin canjes, que elimina a la vez sus correos y
  teléfonos.
- 4 casos de catálogo: políticas de las nueve FK (explícitas y NOT DEFERRABLE) y
  comentarios de 6 tablas, 32 columnas y 77 constraints (incluidos 32 NOT NULL
  de PostgreSQL 18).

Cada caso verifica los datos resultantes y el nombre del constraint si se espera
un rechazo; no se capturan indiscriminadamente errores inesperados. El helper
usa subtransacciones de PL/pgSQL y una excepción controlada para revertir cada
caso exitoso, y el ROLLBACK final elimina los datos de prueba. La estructura del
mecanismo sigue la referencia de Omar, adaptada a estas nueve relaciones.

Esta validación comprueba los casos propios con las políticas disponibles; no
equivale a ejecutar las suites completas de los otros módulos. Una corrección de
`idSucursal`, `idCliente` o `idPremio` puede seguir bloqueándose si una FK ajena
conserva `ON UPDATE NO ACTION` y existen filas que la referencian; el resultado
depende de todas las referencias existentes.

## Reproducción y evidencia

En una base nueva y desechable de PostgreSQL, desde la raíz de Practica06, y
guardando cada salida como registro:

```sh
sha256sum base/DDL_practica05.sql | tee evidencia/03_sha256_ddl.log
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f base/DDL_practica05.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/03_premios_canjes_encargados/politicas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/03_premios_canjes_encargados/comentarios.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/03_premios_canjes_encargados/pruebas.sql 2>&1 | tee evidencia/03_pruebas_modulo03_base.log
```

Para comprobar el enlace con los demás módulos, cargar sus políticas antes de las
pruebas; los comentarios de cada módulo se aplican después de sustituir sus FK:

```sh
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/01_clientes_tarjetas_partidas/politicas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/03_premios_canjes_encargados/pruebas.sql 2>&1 | tee evidencia/03_pruebas_modulo03_con_otros.log
```

El resultado se reproduce ejecutando `pruebas.sql`: debe mostrar `[COMPLETAR]`
casos correctos y confirmar que no quedan datos tras ROLLBACK. La elección por FK
está registrada también en `decisiones.csv`. El PDF individual es material de
integración: Omar reúne decisiones, justificación y evidencia en el informe único
del equipo y prepara el README y el ZIP de la entrega; este módulo no sustituye
esos archivos.