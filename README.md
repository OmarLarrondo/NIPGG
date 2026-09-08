# ÑIPGG - Fundamentos de Bases de Datos (2027-1)

Repositorio del equipo **ÑIPGG** para las tareas, prácticas y el proyecto final
de *Fundamentos de Bases de Datos* (Facultad de Ciencias, UNAM).

## Entrega activa: Práctica 02

La práctica activa aborda el análisis de requerimientos del caso
**PuellaGame** y un prototipo en Java que persistirá información en archivos
CSV. En esta etapa el repositorio contiene solamente la estructura de trabajo;
la solución todavía no está implementada.

La organización detallada, las fronteras entre módulos y el reparto sugerido
para los cinco integrantes están en [`Practica02/README.md`](Practica02/README.md).

```
ÑIPGG/
├── README.md
├── Practica02/                 # entrega activa
│   ├── SRC/                    # Java, CSV y Javadoc
│   ├── Docs/                   # destino de Practica02.pdf
│   ├── reporte/                # fuentes modulares de LaTeX
│   ├── README_ÑIPGG.tex        # fuente del README de entrega
│   └── README.md               # coordinación y reparto
├── Practica01/                 # práctica anterior
└── Tarea01/                    # tarea anterior
```

## Convenciones de colaboración

- Cada cambio debe limitarse al módulo asignado y entrar mediante una rama
  corta; se recomienda el formato `practica02/<modulo>-<apellido>`.
- Los commits siguen Conventional Commits, por ejemplo:
  `feat(practica02): agregar persistencia de clientes`.
- Antes de integrar se revisan compilación, pruebas, Javadoc, formato de los CSV
  y compilación del reporte.
- No se versionan credenciales, datos personales reales de clientes ni archivos
  generados fuera de los entregables finales.

## Forma de entrega

El paquete final deberá llamarse exactamente `Practica02_ÑIPGG.zip`. Conforme a
la especificación de la práctica, contendrá `SRC/`, `Docs/Practica02.pdf` y
`README_ÑIPGG.pdf`. El líder entrega el ZIP en Classroom y los demás integrantes
entregan una copia del README del equipo.

Las carpetas de prácticas y tareas anteriores se conservan como historial; no
son la plantilla de la entrega activa.
