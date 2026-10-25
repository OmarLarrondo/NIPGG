# Contrato del modelo · Práctica 05

Estado: pendiente de acuerdo técnico. Los responsables de los cinco módulos están confirmados en el [README](../README.md).

## Fuente de verdad

La consigna exige conservar nombres de tablas y columnas del modelo relacional anterior. El informe de Práctica 04 señala diferencias con el diagrama original. Antes de implementar, resolver esas diferencias y registrar aquí qué versión del modelo utilizará el equipo.

- Modelo definitivo: **pendiente**.
- Diferencias resueltas y acuerdos: **pendiente**.
- Versión de PostgreSQL para validación: **pendiente**.

## Acuerdos mínimos por tabla

Registrar nombre exacto, responsable, columnas y tipos, PK con orden de columnas, claves candidatas, nulabilidad y FK con acciones referenciales. Acordar el uso consistente de identificadores y comillas para conservar los nombres del modelo.

## Referencias entre módulos

Quien implementa la tabla origen escribe la FK. Quien implementa la tabla destino confirma nombre, tipo y clave. Esto incluye referencias internas y externas; no se duplican restricciones en ambos módulos.

## Reglas que requieren revisión

Distinguir restricciones locales que pueden expresarse mediante ALTER TABLE de reglas entre tablas u operaciones (por ejemplo, especialización, disponibilidad y suficiencia de puntos). Documentar su alcance y acordar su tratamiento; no declarar que están implementadas hasta comprobarlo.
