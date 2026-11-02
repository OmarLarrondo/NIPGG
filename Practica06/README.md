# Práctica 06: README interno de organización

Estado: distribución confirmada de cinco módulos técnicos para trabajar en paralelo.
**Responsables: Omar (01), Miguel (02), Ana (03), Yahir (04) y Diego (05).**
El módulo 01 de Omar está implementado y validado: 37 casos correctos en
PostgreSQL 18.6. Los módulos 02 a 05 conservan sus plantillas pendientes.
El PDF único en `Docs/Práctica06.pdf` tiene portada del equipo y contiene,
por ahora, la aportación del módulo 01; falta integrar las demás aportaciones.

Este README es de uso interno y es distinto del README en PDF de la entrega.

## Alcance y base común

El enunciado requiere investigar las políticas de mantenimiento de llaves foráneas
en PostgreSQL, justificar su elección, aplicarlas al DDL de la práctica anterior
y utilizar `COMMENT` para documentar tablas, columnas y restricciones.

Base revisada: `../Practica05/SQL/DDL.sql`: 30 tablas, 146 columnas y 38 FK.
SHA-256: `588c7910e549284264d0a923dd7a5c6091cd62fd4987063dac388c12a2e99230`.
El DDL declara PostgreSQL 18. Se propone usar esa misma versión para las pruebas.
El enlace a PostgreSQL 14 del enunciado corresponde a la referencia de `COMMENT`;
no establece por sí solo que deban migrar el esquema a esa versión.

Cada integrante investiga una política, implementa las decisiones de todas las FK
de sus tablas, comenta todos sus objetos y entrega pruebas y su explicación.
La política investigada por cada persona **no obliga a usar esa política en todas
sus tablas**: la elección se justifica por relación y por operación.

La integración general, el armado del PDF, el README de entrega, la recopilación
y el ZIP quedan a cargo de Omar, fuera de los cinco módulos técnicos.

## Distribución confirmada

Las FK se cuentan por tabla origen. Las restricciones de la última columna son
PK, FK, UNIQUE y CHECK explícitas; los NOT NULL se documentan además por columna.

| Módulo | Responsable | Investigación | Tablas | Columnas | FK | Restricciones |
|---|---|---|---:|---:|---:|---:|
| 01 Clientes, tarjetas y partidas | Omar | NO ACTION y concepto general (pregunta 1) | 5 | 26 | 6 | 36 |
| 02 Juegos, máquinas y técnicos | Miguel | CASCADE | 8 | 34 | 9 | 49 |
| 03 Premios, canjes y encargados | Ana | SET NULL | 6 | 32 | 9 | 45 |
| 04 Sucursales, visitas y recargas | Yahir | RESTRICT y comparación con NO ACTION | 4 | 24 | 6 | 33 |
| 05 Gerencia, cajas y administración | Diego | SET DEFAULT | 7 | 30 | 8 | 45 |
| **Total** | **5 integrantes** | **5 políticas** | **30** | **146** | **38** | **208** |

### Módulo 01: clientes, tarjetas y partidas — Omar

Tablas: `Cliente`, `correoElectrónico`, `teléfono`, `Tarjeta`, `Partida`.

- Elegir y justificar las acciones de sus seis FK; cubrir especialmente la FK
  compuesta de Partida a Tarjeta y el efecto de actualizar identificadores.
- Documentar sus tablas, columnas y restricciones.
- Investigar NO ACTION y redactar la definición general para la pregunta 1.
- Probar contactos, tarjeta y partida; incluir referencias hacia Cajero y Máquina.

### Módulo 02: juegos, máquinas y técnicos — Miguel

Tablas: `tipoDeJuego`, `Juego`, `Máquina`, `Mantenimiento`, `Técnico`,
`Certificaciones`, `CorreoElectrónicoTécnico`, `TeléfonoTécnivo`.

- Elegir y justificar las acciones de sus nueve FK.
- Documentar sus tablas, columnas y restricciones, incluidos los contactos del técnico.
- Investigar CASCADE para DELETE y UPDATE, sus ventajas y los riesgos de propagación.
- Probar las cadenas tipo de juego–juego–máquina–mantenimiento y los dependientes
  del técnico; tener presentes las Partidas que referencian Máquina desde el módulo 01.

### Módulo 03: premios, canjes y encargados — Ana

Tablas: `Premio`, `Canje`, `Disponer`, `Encargado de premios`,
`CorreoElectrónicoEncargado`, `TeléfonoEncargado`.

- Elegir y justificar las acciones de sus nueve FK, diferenciando inventario,
  contactos y conservación del historial de canjes.
- Documentar sus tablas, columnas y restricciones.
- Investigar SET NULL y su compatibilidad con NOT NULL y claves primarias.
- Probar Canje con sus cuatro referencias, Disponer y los dependientes del encargado.

### Módulo 04: sucursales, visitas y recargas — Yahir

Tablas: `SUCURSAL`, `HORARIO_SUCURSAL`, `VISITA`, `RECARGA`.

- Elegir y justificar las acciones de sus seis FK, incluidas las dos FK compuestas
  hacia Tarjeta y la conservación del historial de recargas y visitas.
- Documentar sus tablas, columnas y restricciones.
- Investigar RESTRICT y compararlo con NO ACTION; incluir un ejemplo que distinga
  la comprobación diferible cuando corresponda.
- Probar las operaciones sobre Tarjeta y SUCURSAL que afectan a estas tablas;
  documentar también los bloqueos producidos por referencias de otros módulos.

### Módulo 05: gerencia, cajas y administración — Diego

Tablas: `Genrente`, `Cajero`, `Administrar`, `CorreoElectrónicoGerente`,
`TeléfonoGerente`, `CorreoElectrónicoCajero`, `TeléfonoCajero`.

- Elegir y justificar las acciones de sus ocho FK.
- Documentar sus tablas, columnas y restricciones, incluidos los UNIQUE de Administrar.
- Investigar SET DEFAULT, los requisitos del valor predeterminado y su validez referencial.
- Probar contactos y Administrar; considerar que Tarjeta y RECARGA referencian Cajero.

### Criterio de equilibrio

Se distribuyen los ocho contactos del personal entre los módulos de su puesto.
El módulo 01 no concentra los contactos de todos los empleados. El módulo 03
incluye Encargado de premios y sus contactos para equilibrar su carga técnica.

El módulo 02 tiene más objetos que comentar; los módulos 01 y 04 tienen menos,
pero trabajan con claves compuestas, cadenas entre módulos y una parte conceptual
adicional. Los módulos 03 y 05 tienen más FK que los módulos 01 y 04, además
de varios puestos y contactos.
Es un equilibrio estimado por complejidad y volumen, no una igualdad de horas.
La integración adicional que retiene Omar no se usa para compensar el reparto técnico.

## Estructura de trabajo

```text
Practica06/
├── Práctica06.pdf                 # Enunciado original
├── README.md                     # Organización interna y distribución confirmada
├── base/
│   └── DDL_practica05.sql         # Copia fija del DDL anterior
├── modulos/
│   ├── 01_clientes_tarjetas_partidas/
│   ├── 02_juegos_maquinas_tecnicos/
│   ├── 03_premios_canjes_encargados/
│   ├── 04_sucursales_operaciones/
│   └── 05_personal_administracion/
├── SQL/
│   └── DDL.sql                   # Ensamblado final por Omar
├── reporte/                      # Fuentes del informe integrado por Omar
├── Docs/
│   └── Práctica06.pdf            # Informe final
└── README_ÑIPGG.pdf              # Entrega, a cargo de Omar
```

## Archivos que edita cada integrante

Cada integrante edita los seis archivos siguientes dentro de la carpeta de su
módulo asignado. Las rutas son relativas a `Practica06/`.

| Integrante | Módulo | Carpeta exclusiva de trabajo |
|---|---|---|
| Omar | Módulo 01 | `modulos/01_clientes_tarjetas_partidas/` |
| Miguel | Módulo 02 | `modulos/02_juegos_maquinas_tecnicos/` |
| Ana | Módulo 03 | `modulos/03_premios_canjes_encargados/` |
| Yahir | Módulo 04 | `modulos/04_sucursales_operaciones/` |
| Diego | Módulo 05 | `modulos/05_personal_administracion/` |

Dentro de **cada una** de esas carpetas ya están creadas las siguientes plantillas:

| Archivo | Contenido a producir |
|---|---|
| `investigacion.md` | Política de investigación del módulo: sintaxis para DELETE y UPDATE, funcionamiento, ventajas, desventajas, ejemplo y fuentes oficiales. |
| `decisiones.csv` | Una fila por FK: tabla origen, nombre de constraint, columnas origen, tabla y columnas destino, ON DELETE, ON UPDATE y justificación. |
| `politicas.sql` | ALTER TABLE para sustituir las FK existentes por sus definiciones con acciones explícitas. |
| `comentarios.sql` | COMMENT ON TABLE, COLUMN y CONSTRAINT de todos los objetos propios, no solo de las FK. |
| `pruebas.sql` | Datos de prueba, operaciones, comprobaciones y resultados esperados; trabajar en una base de pruebas y revertir los datos. |
| `justificacion.md` | Elección por relación, alternativas descartadas, compatibilidad con el esquema y resultados reales. |

Por ejemplo, Omar edita en el módulo 01
`modulos/01_clientes_tarjetas_partidas/investigacion.md`, `decisiones.csv`,
`politicas.sql`, `comentarios.sql`, `pruebas.sql` y `justificacion.md`, todos
dentro de esa misma carpeta. El mismo criterio se aplica a los otros cuatro módulos.

Las cinco carpetas y sus seis archivos por módulo ya están creados.
En el módulo 01, `decisiones.csv` contiene las seis decisiones justificadas;
`politicas.sql`, `comentarios.sql` y `pruebas.sql` están implementados. En los
módulos 02 a 05, las acciones, comentarios y pruebas siguen pendientes.
Todos parten de la copia fija `base/DDL_practica05.sql`, idéntica al DDL anterior.
`reporte/generar_informe.py` genera el PDF único `Docs/Práctica06.pdf` a partir
de la investigación y justificación del módulo 01. Requiere Python, ReportLab
y las fuentes DejaVu Sans y Liberation Mono; se ejecuta desde la raíz de
Practica06 con `python3 reporte/generar_informe.py`. El DDL integrado, el
README de entrega y el ZIP siguen pendientes de integración.
Los archivos compartidos `SQL/DDL.sql`, `reporte/`, `Docs/Práctica06.pdf` y
`README_ÑIPGG.pdf` quedan para la integración que realizará Omar.

## Acuerdos para trabajar en paralelo

1. Todos parten de la misma copia del DDL anterior en una base de pruebas propia.
   Para esta práctica el esquema completo ya existe como insumo, por lo que no
   necesitan esperar a que otros vuelvan a implementar sus tablas.
2. Cada persona modifica únicamente sus archivos. Quien posee la tabla origen
   implementa la FK; quien posee el destino confirma los efectos de la decisión.
3. `politicas.sql` parte del DDL completo ya cargado: elimina y vuelve a agregar
   cada FK propia mediante ALTER TABLE, conservando su nombre y columnas.
   Se ejecuta una vez, dentro de una transacción. Al integrar, los comentarios
   se aplican después de todas las sustituciones de constraints.
4. Conservar identificadores, acentos, mayúsculas, tipos y claves de la base,
   incluidos `Genrente` y `TeléfonoTécnivo`. Las correcciones necesarias se
   proponen con ALTER TABLE, como indica el enunciado.
5. Registrar DELETE y UPDATE por separado. Puede haber acciones distintas
   entre operaciones y relaciones, justificadas por un criterio común de negocio.
6. Las cinco políticas se investigan; no hace falta forzar el uso de todas.
   Las columnas del DDL actual son NOT NULL y no tienen DEFAULT. Cualquier
   propuesta de SET NULL o SET DEFAULT debe resolver y justificar su compatibilidad.
   Los ejemplos didácticos que requieran otro diseño van en tablas de prueba separadas.
7. En cada FK probar, como mínimo, DELETE y UPDATE de una fila referenciada,
   y rechazar un INSERT o UPDATE del hijo con una referencia inexistente.
   Comprobar los datos resultantes, no solo que la sentencia termine.
8. Para relaciones compuestas conservar todos los componentes. Probar cadenas
   de propagación y bloqueos, y explicar los casos que dependen de la política
   propuesta por otro módulo. Cada autor prepara sus pruebas; Omar ejecuta
   la comprobación conjunta durante la integración.
9. Verificar que los comentarios estén guardados en PostgreSQL, mediante
   consultas de catálogo o las herramientas de inspección de psql. Describir
   la obligatoriedad en los comentarios de columna; comprobar cómo representa
   NOT NULL la versión de PostgreSQL usada para no omitir objetos comentables.

## Cobertura de las cinco preguntas del informe

| Pregunta del enunciado | Aportación técnica |
|---|---|
| 1. Definición de política de mantenimiento | El módulo 01 aporta la definición general; cada módulo la aplica a su área. |
| 2. Sintaxis SQL de cada política | Cada integrante entrega la sintaxis de su política en `investigacion.md`. |
| 3. Objeto y funcionamiento | Cada integrante explica su política y aporta un ejemplo reproducible. |
| 4. Ventajas y desventajas | Cada integrante analiza su política. |
| 5. Política elegida y motivos | Los cinco entregan `decisiones.csv` y `justificacion.md` para sus FK. |

Omar reúne estas aportaciones en un PDF coherente y comprueba que lo descrito
coincida con el DDL final. Ningún integrante queda encargado únicamente de teoría:
los cinco implementan, comentan, documentan y prueban.

## Entrega de cada integrante

- Su investigación y justificación completas, con fuentes oficiales y ejemplos.
- Todas sus FK con ON DELETE y ON UPDATE explícitos y justificados.
- Comentarios de todas sus tablas, columnas y restricciones.
- Pruebas reproducibles y resultados registrados, indicando la versión de PostgreSQL.
- Ningún cambio a las fuentes de la práctica 5 ni a los módulos ajenos.

Omar conserva el ensamblado del DDL autónomo, la revisión conjunta, el informe
integrado, el README y el ZIP con `SQL/DDL.sql`, `Docs/Práctica06.pdf` y
`README_ÑIPGG.pdf`, conforme al enunciado y a los lineamientos del curso.

## Referencias para comenzar

- [Enunciado local](Práctica06.pdf).
- [DDL de la práctica anterior](../Practica05/SQL/DDL.sql).
- [PostgreSQL 18: restricciones y acciones referenciales](https://www.postgresql.org/docs/18/ddl-constraints.html#DDL-CONSTRAINTS-FK).
- [PostgreSQL 14: COMMENT, referencia citada por el enunciado](https://www.postgresql.org/docs/14/sql-comment.html).
