# Módulo 03 · Premios y canjes

**Responsable: Omar.**

## Tablas asignadas

- `Premio`
- `Canje`
- `Disponer`

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

La integración general y los documentos de avance se prepararon por separado de estas tres tablas. Las seis fuentes técnicas están implementadas. Se validaron 58 casos en PostgreSQL 18; consulta `../../reporte/evidencias/validacion/omar.txt`.

## Actividad adicional: restauración

- Insumo: [ejemplo.backup](../../ejemplo.backup).
- Guía: [RestaurarBackup.pdf](../../RestaurarBackup.pdf).
- Editar [06_restauracion.tex](../../reporte/secciones/06_restauracion.tex).
- Guardar capturas y registros seleccionados en [evidencias/restauracion/](../../reporte/evidencias/restauracion/).
- Usar una base separada de la destinada a probar el DDL. Registrar el entorno, procedimiento, resultado y comprobación de tablas/datos restaurados.
- La restauración está pendiente; la existencia del respaldo no acredita su ejecución.
