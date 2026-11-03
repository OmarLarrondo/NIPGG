# Elección y validación de políticas del módulo 02

**Miguel Ángel Jiménez Ramírez · 119000887**
Práctica 06 · Equipo ÑIPGG · 2 de noviembre de 2026.

## Alcance y criterio

El módulo asignado comprende tipoDeJuego, Juego, Máquina, Mantenimiento,
Técnico, Certificaciones, CorreoElectrónicoTécnico y TeléfonoTécnivo.
Implementa las nueve FK cuya tabla origen pertenece a esas tablas y documenta
8 tablas, 34 columnas y 49 restricciones explícitas, más sus 34 NOT NULL.
La distribución confirmada del README identifica a Miguel como responsable 02.

Se conserva el historial y la identidad de equipos y empleados. Solo se borran
en cascada los valores dependientes de un técnico que puede eliminarse sin
romper otras referencias. Las correcciones de claves se propagan. Las acciones
son propuestas razonadas para este modelo y no añaden supuestos al esquema.

## 5. Política elegida y motivos por relación

| FK | ON DELETE | ON UPDATE |
|---|---|---|
| fk_correo_tecnico | CASCADE | CASCADE |
| fk_telefono_tecnico | CASCADE | CASCADE |
| fk_mantenimiento_maquina | NO ACTION | CASCADE |
| fk_mantenimiento_tecnico | NO ACTION | CASCADE |
| fk_maquina_juego | NO ACTION | CASCADE |
| fk_maquina_sucursal | NO ACTION | CASCADE |
| fk_juego_tipo | NO ACTION | CASCADE |
| fk_tecnico_sucursal | NO ACTION | CASCADE |
| fk_certificacion_tecnico | CASCADE | CASCADE |

### fk_correo_tecnico: CorreoElectrónicoTécnico → Técnico

ON DELETE CASCADE; ON UPDATE CASCADE.

El correo carece de propietario sin el técnico. DELETE CASCADE limpia sus
direcciones; UPDATE CASCADE conserva su asociación y actualiza la parte CURP de
la PK (CURP, correoTécnico). No se impone unicidad global al correo. NO ACTION
para borrar contactos exigiría limpieza manual. SET NULL rompería NOT NULL y
la PK; no existe técnico predeterminado para SET DEFAULT. Si el técnico tiene
mantenimientos, su borrado completo queda bloqueado y conserva los contactos.

### fk_telefono_tecnico: TeléfonoTécnivo → Técnico

ON DELETE CASCADE; ON UPDATE CASCADE.

El teléfono es un valor del técnico. DELETE CASCADE elimina esos valores y
UPDATE CASCADE conserva su propietario, incluida la PK (CURP, telefonoTécnico).
Se conserva el identificador literal TeléfonoTécnivo. NO ACTION obligaría a una
limpieza manual sin conservar una entidad independiente. SET NULL violaría
NOT NULL y la PK; SET DEFAULT no tiene propietario válido definido. Un técnico
con historial de mantenimiento no puede borrarse para limpiar sus contactos.

### fk_mantenimiento_maquina: Mantenimiento → Máquina

ON DELETE NO ACTION; ON UPDATE CASCADE.

El mantenimiento registra una intervención realizada sobre una máquina.
DELETE NO ACTION impide borrar el equipo mientras tenga ese historial;
UPDATE CASCADE corrige idMaquina en la PK (idMaquina, idMantenimiento) sin cambiar
el discriminante. Descarto DELETE CASCADE por pérdida de historial. SET NULL
rompería NOT NULL y la PK; SET DEFAULT atribuiría la intervención a un equipo
no definido. La baja operativa puede representarse con estado, sin agregar aquí
un catálogo nuevo. Partida también puede impedir eliminar la máquina.

### fk_mantenimiento_tecnico: Mantenimiento → Técnico

ON DELETE NO ACTION; ON UPDATE CASCADE.

Se debe conservar quién hizo la intervención. DELETE NO ACTION impide borrar
al técnico con mantenimientos. UPDATE CASCADE corrige su CURP sin cambiar la
máquina, la fecha ni idMantenimiento. Descarto DELETE CASCADE por pérdida de
historial, SET NULL por obligatoriedad y SET DEFAULT por ausencia de un técnico
sustituto que represente al responsable real. Los CHECK de CURP siguen vigentes.
El rechazo del borrado conserva también contactos y certificaciones.

### fk_maquina_juego: Máquina → Juego

ON DELETE NO ACTION; ON UPDATE CASCADE.

Un juego de catálogo clasifica equipos con identidad propia. DELETE NO ACTION
exige resolver la asignación antes de borrar el juego; no borra equipos ni sus
dependientes. UPDATE CASCADE corrige idJuego en las máquinas, sin cambiar sus
idMaquina. Descarto DELETE CASCADE por borrar inventario como efecto secundario;
SET NULL por NOT NULL y SET DEFAULT por no existir juego predeterminado. No
hay propagación posterior a Mantenimiento al cambiar solamente idJuego, pues
esa tabla referencia idMaquina.

### fk_maquina_sucursal: Máquina → SUCURSAL

ON DELETE NO ACTION; ON UPDATE CASCADE.

Eliminar una sucursal no debe eliminar equipos. DELETE NO ACTION exige
reasignar o resolver sus máquinas primero. UPDATE CASCADE conserva la asociación
cuando se corrige idSucursal; idMaquina permanece igual. Descarto DELETE CASCADE
por pérdida de identidad e historial indirecto. SET NULL viola NOT NULL y
SET DEFAULT no tiene sucursal válida definida. Otras tablas que referencian
SUCURSAL pueden bloquear la misma operación; el módulo no cambia sus FK.

### fk_juego_tipo: Juego → tipoDeJuego

ON DELETE NO ACTION; ON UPDATE CASCADE.

El tipo es un catálogo compartido por juegos. DELETE NO ACTION impide borrar
un tipo todavía usado. UPDATE CASCADE corrige idTipo en Juego. No altera
idJuego, por lo que no actualiza idJuego de Máquina. Descarto DELETE CASCADE
porque quitar una clasificación no debe eliminar juegos. SET NULL es
incompatible con NOT NULL y SET DEFAULT no tiene tipo sustituto definido.
RESTRICT también bloquearía borrados en este diseño no diferible; conservo el
criterio NO ACTION usado para las relaciones protegidas del módulo de Omar.

### fk_tecnico_sucursal: Técnico → SUCURSAL

ON DELETE NO ACTION; ON UPDATE CASCADE.

La identidad del empleado existe más allá de su asignación a una sucursal.
DELETE NO ACTION obliga a resolver los técnicos asignados antes de borrar la
sucursal. UPDATE CASCADE corrige idSucursal sin alterar CURP, contactos ni
mantenimientos. Descarto DELETE CASCADE por el riesgo de borrar empleados y
dependientes al cerrar una sucursal. SET NULL viola NOT NULL; SET DEFAULT no
tiene una asignación válida definida. No implemento una baja laboral ni un
traslado automático: esas operaciones requieren una decisión explícita.

### fk_certificacion_tecnico: Certificaciones → Técnico

ON DELETE CASCADE; ON UPDATE CASCADE.

Certificaciones almacena un valor por técnico, sin identidad independiente.
DELETE CASCADE elimina esos valores al borrar a un técnico sin historial
protegido. UPDATE CASCADE actualiza CURP en la PK (CURP, Certificaciones) y
mantiene el texto de la certificación. Descarto NO ACTION para el borrado porque
solo exigiría limpieza manual. SET NULL rompería la PK y NOT NULL; SET DEFAULT
reasignaría credenciales a otra identidad sin fundamento. Si se necesitara
auditoría permanente de certificaciones habría que ampliar el modelo; aquí
se conserva la estructura entregada.

## Compatibilidad con la base y efectos entre módulos

Se conserva el DDL base cuyo SHA-256 es
`588c7910e549284264d0a923dd7a5c6091cd62fd4987063dac388c12a2e99230`.
No cambian los 30 CREATE TABLE, sus columnas, PK, UNIQUE, CHECK ni nulabilidad.
Las nueve sustituciones mantienen nombres, destinos, columnas y NOT DEFERRABLE.

Partida pertenece a Omar. Su política fk_partida_maquina usa DELETE NO ACTION
y UPDATE CASCADE; permite corregir idMaquina conservando la partida. El DDL
base todavía usa UPDATE NO ACTION: sin cargar las políticas de Omar, ese cambio
queda bloqueado si hay partidas. pruebas.sql reconoce ambos estados y verifica
el resultado correspondiente sin redefinir la FK ajena.

Para SUCURSAL, las políticas revisadas de Yahir y Diego propagan actualizaciones,
pero el módulo 03 sigue como plantilla en la revisión examinada. Una fila de
Encargado de premios o Canje puede bloquear una corrección de idSucursal si su
FK conserva NO ACTION. No se promete propagación global por el solo hecho de
que las dos FK propias hacia SUCURSAL usen CASCADE.

En la cadena tipo-juego-máquina-mantenimiento, un cambio de idTipo llega a
Juego.idTipo; no cambia Juego.idJuego ni Máquina.idMaquina. Un cambio de
idJuego alcanza Máquina.idJuego; un cambio de idMaquina alcanza Mantenimiento
y, con las políticas de Omar, Partida. En DELETE, las relaciones protegidas
interrumpen la eliminación. El ejemplo temporal muestra por separado lo que
ocurriría si toda la cadena tuviera DELETE CASCADE.

## Verificación ejecutada

Se ejecutó el DDL completo en una instancia temporal de PostgreSQL 18.6,
compilada con GCC 14.2.0, sin conexiones de red y con datos sintéticos.

**Resultado: 50 casos correctos, ninguno fallido, en cada uno de tres escenarios.**

| Escenario | Resultado | Evidencia |
|---|---|---|
| DDL base + módulo 02 | 50/50 | 03_pruebas_modulo02_base.log |
| Anterior + políticas de Omar (01) | 50/50 | 06_pruebas_modulo02_con_omar.log |
| Anterior + políticas de Yahir (04) y Diego (05) | 50/50 | 10_pruebas_modulo02_con_modulos_01_04_05.log |

Las **37 pruebas originales de Omar** también aprobaron con el módulo 02
aplicado, antes de incorporar 04 y 05; evidencia: 07_regresion_omar.log.
Son 187 ejecuciones correctas; los 50 casos del módulo 02 se repiten en tres
configuraciones, no son 150 casos distintos.

Los 50 casos propios se desglosan en 36 por FK, 5 de cadenas e historial,
2 de Partida, 2 del ejemplo temporal, 1 de colisión de PK y 4 de catálogo.
Se verificaron 8 comentarios de tabla, 34 de columna y 83 de constraint,
para un total de 125 objetos documentados. Los registros confirman que las
30 tablas quedan vacías después de ROLLBACK en cada ejecución.

Se compararon además columnas, tipos, nulabilidad, DEFAULT y las otras
345 restricciones antes y después de aplicar el módulo 02: sin diferencias.
La integración conjunta comprueba los casos propios con las políticas
actuales disponibles; no equivale a ejecutar las suites completas de Yahir
y Diego ni a validar una futura implementación del módulo 03.

Cada caso verifica los datos resultantes y el nombre del constraint si se
espera un rechazo. No se capturan indiscriminadamente errores inesperados.
El helper usa subtransacciones de PL/pgSQL y una excepción controlada para
revertir cada caso exitoso; el ROLLBACK final elimina los datos de prueba.
La última comprobación exige que las 30 tablas permanezcan vacías.
La estructura del mecanismo sigue la referencia de Omar, adaptada a estas
nueve relaciones y a las cadenas del módulo 02.

## Reproducción y evidencia

En una base nueva y desechable de PostgreSQL 18, desde la raíz de Practica06:

```sh
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f base/DDL_practica05.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/02_juegos_maquinas_tecnicos/politicas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/02_juegos_maquinas_tecnicos/comentarios.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/02_juegos_maquinas_tecnicos/pruebas.sql
```

Para comprobar el enlace con Omar, cargar sus políticas antes de las pruebas;
los comentarios de cada módulo se aplican después de sustituir sus FK:

```sh
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/01_clientes_tarjetas_partidas/politicas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_PRUEBA -f modulos/02_juegos_maquinas_tecnicos/pruebas.sql
```

Los registros externos acompañan la preparación independiente. El PDF
individual es material de integración: Omar reúne investigación, decisiones,
justificación y evidencia en el informe único del equipo, ensambla SQL/DDL.sql
y prepara el README y ZIP de la entrega. Este módulo no sustituye esos archivos.

## Alcance de la revisión de requisitos

Se revisó la distribución confirmada y la base real del repositorio. La
notificación de Classroom identifica la práctica y fecha de entrega, pero el
acceso al enunciado, adjuntos y rúbrica requiere verificar la sesión de Google.
El PDF de Docs revisado corresponde al informe de Omar, no al enunciado.
Por tanto, esta validación técnica no certifica requisitos originales todavía
no consultados. Las referencias oficiales y lineamientos consultados se
registran en la guía de entrega independiente.
