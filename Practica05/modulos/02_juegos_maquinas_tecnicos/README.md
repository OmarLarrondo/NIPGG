# Módulo 02 · Juegos, máquinas y técnicos

**Responsable: Ana.**

## Tablas asignadas

- `tipoDeJuego`
- `Juego`
- `Máquina`
- `Mantenimiento`
- `Técnico`
- `Certificaciones`

Los identificadores definitivos se conservan en los archivos SQL y en el contrato técnico del modelo.

## Archivos del módulo

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

No se asignan a este módulo tareas de README, recopilación de diagramas, empaquetado ni integración general. Las fuentes están implementadas y validadas; véase la verificación final del equipo.

Estado de cierre: integrado en `../../SQL/DDL.sql`; pruebas individuales y conjuntas aprobadas. Los identificadores exactos se consultan en `../../acuerdos/contrato_modelo.md`.
