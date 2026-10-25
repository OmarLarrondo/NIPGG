# Módulo 01 · Clientes y contactos

**Responsable: Miguel.**

## Fuente y alcance

Las trece tablas implementadas conservan nombres, columnas, tipos y PK del diagrama entregado en `Practica04/Diagramas/RelacionalÑIPGG.drawio`. Se sigue el criterio de Diego para distribuir los contactos de personal por puesto. No se usa una tabla general de empleados.

- `Cliente`
- `correoElectrónico`
- `teléfono`
- `Tarjeta`
- `Partida`
- `CorreoElectrónicoCajero`
- `TeléfonoCajero`
- `CorreoElectrónicoTécnico`
- `TeléfonoTécnivo`
- `CorreoElectrónicoGerente`
- `TeléfonoGerente`
- `CorreoElectrónicoEncargado`
- `TeléfonoEncargado`

## Archivos del módulo

| Archivo | Contenido |
|---|---|
| [tablas.sql](tablas.sql) | Trece tablas y 42 columnas, sin restricciones embebidas. |
| [dominios.sql](dominios.sql) | Obligatoriedad y dominios con `ALTER TABLE`. |
| [claves.sql](claves.sql) | PK del diagrama y `UNIQUE(idCliente)` en Tarjeta por la cardinalidad 1:1. |
| [referencias.sql](referencias.sql) | Catorce FK, incluidas la pareja completa de Tarjeta y las referencias por puesto. |
| [documentacion.tex](documentacion.tex) | Dominios por columna, claves, decisiones y límites de las restricciones. |
| [pruebas.sql](pruebas.sql) | Cuatro grupos válidos y 167 rechazos esperados en un esquema aislado. |

## Correspondencia con el diagrama

- Los contactos del cliente se llaman `correoElectrónico` y `teléfono`, como en el dibujo; se sustituyeron los alias de la propuesta anterior.
- La PK de `Tarjeta` es `(idCliente, numeroTarjeta)`. `UNIQUE(idCliente)` conserva el máximo de una tarjeta por cliente de la conexión 1:1. No se exige unicidad global de `numeroTarjeta`.
- La PK de `Partida` es `(idCliente, numeroTarjeta, idMaquina, idPartida)`. Su FK a Tarjeta utiliza ambos componentes, no únicamente el cliente.
- Los ocho contactos de personal tienen PK por CURP y contacto; cada FK referencia a su puesto.
- `TeléfonoTécnivo` conserva la **v** del rótulo original. Su columna es `telefonoTécnico`. Una corrección de la errata debe acordarse y reflejarse también en el diagrama.
- Se verifican los nombres y orden de las 42 columnas, sus tipos, las trece PK y las catorce FK. Se considera `int` sinónimo de `integer`.

## Interfaces para integrar

Se usan comillas dobles para conservar los identificadores, incluidos acentos y espacios.

| Módulo propietario | Tabla destino | Columna y tipo requeridos |
|---|---|---|
| Ana (02) | `Máquina` | `idMaquina integer`, PK/UNIQUE |
| Ana (02) | `Técnico` | `CURP char(18)`, PK/UNIQUE |
| Diego (05) | `Gerente` | `CURP char(18)`, PK/UNIQUE |
| Diego (05) | `Cajero` | `CURP char(18)`, PK/UNIQUE |
| Diego (05) | `Encargado de premios` | `CURP char(18)`, PK/UNIQUE |

Las tablas de otros módulos que identifiquen una tarjeta conforme al diagrama deben usar `(idCliente, numeroTarjeta)`. Se conserva también la clave candidata `Tarjeta(idCliente)` por la relación 1:1.

El [contrato del modelo](../../acuerdos/contrato_modelo.md) y los scripts de los otros módulos siguen pendientes en la copia actual del repo. No se han modificado aquí. La validación conjunta requiere sus implementaciones reales; la prueba aislada no confirma su compatibilidad. La participación total Cliente–Tarjeta y las reglas entre puestos o movimientos no se presentan como resueltas por un `CHECK` local.

## Verificación realizada

Revisión local del 24 de octubre de 2026:

- Se extrajeron de `RelacionalÑIPGG.drawio` las trece tablas de este módulo, con sus columnas, tipos y marcas PK. Se contrastaron contra el catálogo de un esquema PostgreSQL creado con estos archivos: coinciden los trece nombres, las 42 columnas en su orden y tipo, y las trece PK con el orden de sus componentes.
- Se comprobaron las catorce FK, sus columnas y destinos, la pareja completa Partida–Tarjeta y la unicidad del propietario de Tarjeta por la cardinalidad 1:1.
- Las pruebas de datos válidos e inválidos pasaron en PostgreSQL 18.6 mediante PGlite 0.5.11; se revirtió el esquema de prueba al terminar.
- La documentación compiló dentro de una copia temporal del reporte completo con el compilador LaTeX de la aplicación.

Es una validación aislada. Los módulos ajenos disponibles en esta copia todavía son plantillas, por lo que no se ha comprobado una integración con sus tablas reales. Las reglas entre tablas que exceden las PK, FK y restricciones locales se describen en la documentación sin presentarlas como implementadas.

## Pruebas

Desde la raíz del repositorio:

```bash
psql -X -v ON_ERROR_STOP=1 -d BASE_DE_PRUEBAS -f Practica05/modulos/01_clientes_contactos/pruebas.sql
```

El script usa comandos de `psql` (`\ir`), prepara dependencias mínimas, prueba las restricciones y revierte todo al terminar. No se incorpora a `DDL.sql` y no utiliza las tablas reales del equipo. Si el esquema de prueba ya existe, se detiene sin borrarlo ni reutilizarlo.

La restauración, los README generales, la recopilación de diagramas, el empaquetado y la integración general conservan el reparto del equipo.
