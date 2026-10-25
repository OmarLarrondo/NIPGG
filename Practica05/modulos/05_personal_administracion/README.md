# Módulo 05 · Personal y administración

**Responsable: Diego.**

## Tablas asignadas

- `Empleado`
- `Gerente`
- `Cajero`
- `EncargadoDePremios`
- `Administrar`

Los nombres son el alcance acordado del reparto. Antes de implementar, contrastarlos con el modelo relacional definitivo, incluidos acentos, mayúsculas y columnas.

## Archivos que debes editar

| Archivo | Trabajo |
|---|---|
| [tablas.sql](tablas.sql) | Crear tablas con columnas y tipos. |
| [dominios.sql](dominios.sql) | Restricciones de dominio mediante `ALTER TABLE`. |
| [claves.sql](claves.sql) | PK simples/compuestas y `UNIQUE` mediante `ALTER TABLE`. |
| [referencias.sql](referencias.sql) | FK de tus tablas mediante `ALTER TABLE`. |
| [documentacion.tex](documentacion.tex) | Dominios de cada columna y explicación de restricciones. |
| [pruebas.sql](pruebas.sql) | Casos aceptados y rechazados, con resultado esperado. |

## Coordinación

Consulta el [contrato del modelo](../../acuerdos/contrato_modelo.md) y el [reparto completo](../../README.md). Quien posee la tabla origen escribe su FK; quien posee la tabla destino confirma su nombre, tipo y clave. Cada autor corrige su módulo y su documentación.

No se asignan a este módulo tareas de README, recopilación de diagramas, empaquetado ni integración general. Las fuentes están pendientes de implementación.

## Ajustes de integración del 25 de octubre

El SQL usa los nombres literales `Genrente`, `Cajero`, `Encargado de premios`,
`Administrar` y `SUCURSAL`, con columnas entre comillas. No se crea `Empleado`.
Se completó la PK compuesta de `Administrar` y se validaron siete casos sobre
el DDL real integrado; los errores esperados se aíslan y todo se revierte.
