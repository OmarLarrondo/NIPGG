# Práctica 05 · Lenguaje de Definición de Datos

Equipo **ÑIPGG** · Fundamentos de Bases de Datos · UNAM · 2027-I.

**Avance local del 25 de octubre de 2026.** Repositorio actualizado a `8f2199f`.
Están integrados los módulos 01 (Miguel), 03 (Omar), 04 (Yahir) y 05 (Diego).
El módulo 02 (Ana) sigue pendiente en `main`. La restauración se hará después.

## Trabajo completado

- Omar: `Premio`, `Canje` y `Disponer`, con tipos, dominios, PK, seis FK,
  documentación y 58 casos de prueba correctos en PostgreSQL 18.
- Integración disponible: 24 tablas. Se corrigieron identificadores de personal
  para conservar mayúsculas, acentos y espacios del modelo; se completó la PK
  de `Administrar` y se repararon sus pruebas para aislar los errores esperados.
- Documentación de sucursales a partir del SQL de Yahir y ajustes de maquetación
  de contactos, sin cambiar sus reglas de dominio.
- Los dos modelos están en `Diagramas/`, como `.drawio` y `.png`.
- Informe y README de avance con identificación del equipo y pendientes visibles.

## Archivos de avance

| Archivo | Contenido |
|---|---|
| [SQL/DDL_disponible.sql](SQL/DDL_disponible.sql) | SQL autónomo ejecutable de los cuatro módulos disponibles. |
| [SQL/referencias_pendientes.sql](SQL/referencias_pendientes.sql) | Tres FK hacia Máquina y Técnico; no ejecutarlas todavía. |
| [Docs/Practica05_avance.pdf](Docs/Practica05_avance.pdf) | Informe parcial compilado y revisado visualmente. |
| [README_ÑIPGG_avance.pdf](README_ÑIPGG_avance.pdf) | Identificación del equipo y contenido disponible. |
| [acuerdos/contrato_modelo.md](acuerdos/contrato_modelo.md) | Fuente del modelo y decisiones de compatibilidad. |
| [reporte/evidencias/validacion/](reporte/evidencias/validacion/) | Registros reales de ejecución del DDL y pruebas. |

Los PDF son artefactos locales ignorados por la regla general `*.pdf` del
repositorio. Se regeneran desde las fuentes; no se incluyen automáticamente
al publicar código.

## Generación y pruebas

Desde esta carpeta:

```bash
python3 herramientas/ensamblar_ddl.py --disponible
python3 herramientas/compilar_avance.py
```

El ensamblado respeta el orden **tablas → dominios → claves → referencias**
y los módulos 01 a 05 dentro de cada fase. Las fuentes se corrigen primero;
no editar manualmente el SQL generado. El modo final, sin `--disponible`, se
detiene mientras falte el módulo 02. No se han creado tablas ficticias para
sustituirlo ni se han omitido referencias sin registrarlas.

Usar una **base vacía de pruebas** para ejecutar el avance:

```bash
psql -X -v ON_ERROR_STOP=1 -d BASE_VACIA -f SQL/DDL_disponible.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_VACIA -f modulos/03_premios_canjes/pruebas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_VACIA -f modulos/05_personal_administracion/pruebas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_VACIA -f modulos/01_clientes_contactos/pruebas.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_VACIA -f modulos/04_sucursales_operaciones/pruebas.sql
```

Las pruebas 01 y 04 crean dependencias mínimas en esquemas aislados dentro de
una transacción. Las pruebas de Omar y personal usan las tablas reales del
avance integrado. Todas finalizan en `ROLLBACK` y no restauran el respaldo.

## Pendiente para la entrega final

1. Recibir e integrar el módulo de Ana y comprobar las tres FK aplazadas.
2. Ejecutar la restauración en una base separada y agregar sus evidencias.
3. Revisar documentación y diagramas contra el esquema completo.
4. Generar `SQL/DDL.sql`, `Docs/Práctica05.pdf`, `README_ÑIPGG.pdf` y el ZIP final
   conforme a la consigna y a los lineamientos de Classroom.

La [consigna](Práctica05.pdf), la [guía de restauración](RestaurarBackup.pdf) y
`ejemplo.backup` son insumos. El ZIP final no se genera mientras falten las
actividades anteriores. Los cambios de esta sesión permanecen locales.
