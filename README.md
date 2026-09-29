# ÑIPGG - Fundamentos de Bases de Datos (2027-1)

Repositorio del equipo **ÑIPGG** para las tareas, prácticas y el proyecto final
de *Fundamentos de Bases de Datos* (Facultad de Ciencias, UNAM).

## Entregas activas

Actualmente el equipo trabaja en las siguientes entregas:

- **Tarea 02 - Modelo Entidad-Relación:** incluye conceptos del modelo E-R,
  análisis de sitios de taxis, modificación de un modelo universitario y tres
  mini-mundos. La estructura modular y la asignación del equipo están en
  [`Tarea02/README.md`](Tarea02/README.md).
- **Práctica 03 - Modelo Entidad-Relación Extendido:** contiene la estructura
  modular para documentar el caso de uso, sus diagramas en Draw.io y el reporte
  correspondiente. La coordinación está en
  [`Practica03/README.md`](Practica03/README.md).
- **Práctica 04 - Modelo Relacional:** contiene la estructura modular para
  convertir el modelo E-R de la Práctica 03, registrar los dominios,
  restricciones y llaves, y preparar los diagramas y el reporte. Las opciones
  de trabajo y convenciones están en [`Practica04/README.md`](Practica04/README.md).

Los diagramas se trabajarán en línea y sus exportaciones se guardarán en la
carpeta `Diagramas/` de cada práctica. Las respuestas se integrarán por módulos
conforme avance el equipo.

```
ÑIPGG/
├── README.md
├── Tarea02/                    # entrega activa: Modelo E-R
│   ├── Diagramas/              # registro de diagramas en Draw.io
│   ├── Docs/                   # destino del PDF final
│   ├── reporte/                # fuentes modulares de LaTeX
│   ├── README_ÑIPGG.tex        # fuente del README de entrega
│   └── README.md               # coordinación y reparto
├── Practica03/                 # entrega activa: Modelo E-R Extendido
│   ├── Diagramas/              # registro de diagramas en Draw.io
│   ├── Docs/                   # destino del PDF final
│   ├── reporte/                # fuentes modulares de LaTeX
│   └── README.md               # coordinación y reparto
├── Practica04/                 # entrega activa: Modelo Relacional
│   ├── Diagramas/              # exportaciones de diagrams.net
│   ├── Docs/                   # destino del PDF final
│   ├── reporte/                # fuentes modulares del PDF
│   └── README.md               # opciones de trabajo y coordinación
├── Practica02/                 # práctica anterior
├── Practica01/                 # práctica anterior
└── Tarea01/                    # tarea anterior
```

## Convenciones de colaboración

- Cada cambio debe limitarse al módulo asignado y entrar mediante una rama
  corta; se recomienda el prefijo `codex/` para ramas creadas desde este
  repositorio.
- Los commits siguen Conventional Commits, por ejemplo:
  `docs(tarea02): integrar decisiones de diseño`.
- Antes de integrar se revisan los diagramas, la documentación de restricciones
  y la compilación del reporte correspondiente.
- No se versionan credenciales, datos personales reales ni archivos generados
  fuera de los entregables finales.

## Forma de entrega

Cada entrega tendrá su propio paquete final conforme a los lineamientos de
Classroom. Los nombres definitivos y el contenido exacto de cada ZIP se
verificarán antes de publicar las entregas.

Las carpetas de `Practica03/`, `Practica02/`, `Practica01/` y `Tarea01/` se
conservan como entregas anteriores; `Practica04/` es la práctica actual.
