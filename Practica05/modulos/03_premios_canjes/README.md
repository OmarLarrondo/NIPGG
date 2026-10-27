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
Las FK utilizan el identificador literal `Encargado de premios`, conservado también en el módulo de personal.

## Actividad adicional: restauración

- Insumo: [ejemplo.backup](../../ejemplo.backup).
- Guía: [RestaurarBackup.pdf](../../RestaurarBackup.pdf).
- Editar [06_restauracion.tex](../../reporte/secciones/06_restauracion.tex).
- Capturas incluidas en [evidencias/restauracion/](../../reporte/evidencias/restauracion/).
- Usar una base separada de la destinada a probar el DDL. Registrar el entorno, procedimiento, resultado y comprobación de tablas/datos restaurados.
- Restauración completada el 26 de octubre de 2026 en PostgreSQL 16.15: 46 tablas, 31 secuencias y todas las restricciones validadas. El respaldo original contiene cero filas. Se incluyen cuatro capturas de comprobación en la carpeta de evidencias.
- La prueba del módulo volvió a pasar sus 58 casos en la base separada `omar_modulo03`, con `ROLLBACK`.
- La contribución completa de Omar está en [Práctica05.pdf](../../Docs/Práctica05.pdf).

Estado de cierre: integrado en `../../SQL/DDL.sql`; pruebas individuales y conjuntas aprobadas. Los identificadores exactos se consultan en `../../acuerdos/contrato_modelo.md`.
