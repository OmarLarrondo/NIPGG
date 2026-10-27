# Práctica 05 · Lenguaje de Definición de Datos

Equipo **ÑIPGG** · Fundamentos de Bases de Datos · UNAM · 2027-I.

**Entrega completa, integrada y validada localmente.**

- [Informe](Docs/Práctica05.pdf): dominios de las 146 columnas, validación integral, restauración y ambos modelos.
- [README del equipo](README_ÑIPGG.pdf): nombres, números de cuenta y descripción del contenido.
- [DDL autónomo](SQL/DDL.sql): ejecutado sin errores en PostgreSQL 18.

## Estructura de la entrega

```text
Práctica05_ÑIPGG.zip
├── Diagramas/ERÑIPGG.png
├── Diagramas/ERÑIPGG.drawio
├── Diagramas/RelacionalÑIPGG.png
├── Diagramas/RelacionalÑIPGG.drawio
├── SQL/DDL.sql
├── Docs/Práctica05.pdf
└── README_ÑIPGG.pdf
```

## Fuentes y validación

Cada módulo conserva sus archivos de tablas, dominios, claves, referencias, documentación y pruebas. Las restricciones se aplican mediante ALTER TABLE. El ensamblado incorpora todos los módulos por fases: tablas → dominios → claves → referencias. Las pruebas no forman parte del DDL.

El esquema tiene 30 tablas, 30 PK, 38 FK, seis UNIQUE, 134 CHECK y 146 columnas NOT NULL. La prueba conjunta verifica 363 rechazos esperados y termina con ROLLBACK. Los cinco módulos también pasan sus pruebas aisladas.

El [contrato técnico](acuerdos/contrato_modelo.md) documenta nombres literales, claves y decisiones de integración. La [restauración](reporte/evidencias/restauracion/README.md) corresponde al respaldo original, separado del DDL del equipo.

| Módulo original | Integrante |
|---|---|
| Clientes y contactos | Miguel Ángel Jiménez Ramírez |
| Juegos, máquinas y técnicos | Ana Lilia Carballido Camacateco |
| Premios, canjes y restauración | Omar Alejandro Juárez Larrondo |
| Sucursales y operaciones | Yahir León Bautista |
| Personal y administración | Diego Hernández Gómez |

Las fuentes del informe están en `reporte/main.tex`, con portada compartida en `reporte/portada_equipo.tex`; la identificación se genera con `reporte/README_ÑIPGG.tex`.

La consigna original es `Práctica05.pdf` en la raíz; el informe entregable es `Docs/Práctica05.pdf`. Las fuentes, registros, consigna, respaldo y avances históricos quedan fuera del ZIP.
