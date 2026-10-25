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

Las seis fuentes técnicas de este módulo están implementadas. Para probarlas
por separado, ejecutar desde esta carpeta:

```bash
psql -X -v ON_ERROR_STOP=1 -d BASE_DE_PRUEBAS -f pruebas.sql
```

La prueba crea un esquema aislado con dependencias mínimas, incluye los cuatro
archivos DDL del módulo y comprueba 58 casos. Termina en `ROLLBACK`.
No modifica los módulos de otros integrantes ni realiza la restauración.
Las FK usan los nombres del diagrama; la integración debe conciliar el nombre
`Encargado de premios` con `EncargadoDePremios` del SQL recibido de Diego.

## Actividad adicional: restauración

- Insumo: [ejemplo.backup](../../ejemplo.backup).
- Guía: [RestaurarBackup.pdf](../../RestaurarBackup.pdf).
- Editar [06_restauracion.tex](../../reporte/secciones/06_restauracion.tex).
- Guardar capturas y registros seleccionados en [evidencias/restauracion/](../../reporte/evidencias/restauracion/).
- Usar una base separada de la destinada a probar el DDL. Registrar el entorno, procedimiento, resultado y comprobación de tablas/datos restaurados.
- La restauración está pendiente; la existencia del respaldo no acredita su ejecución.
