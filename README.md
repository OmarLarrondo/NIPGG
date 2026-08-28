# ÑIPGG — Fundamentos de Bases de Datos (2027-1)

Repositorio del equipo **ÑIPGG** para la materia *Fundamentos de Bases de
Datos* (Facultad de Ciencias, UNAM). Aquí se desarrollan y versionan todas las
entregas del semestre (tareas, prácticas y proyecto final).

## Estructura del repositorio

```
ÑIPGG/
├── README.md            ← este archivo (general del repositorio)
├── Tarea01/             ← proyecto LaTeX de la Tarea 1
│   ├── main.tex         ← documento principal que junta todos los módulos
│   ├── preambulo.tex    ← paquete, idioma y estilo común
│   ├── bibliografia.bib ← referencias (APA)
│   ├── secciones/       ← un archivo por inciso (trabajo modular)
│   │   ├── portada.tex
│   │   ├── ejercicio_1a.tex  …  ejercicio_1j.tex
│   │   ├── ejercicio_2a.tex
│   │   └── ejercicio_2b.tex
│   └── README_Equipo.tex  ← README de entrega (README_Equipo.pdf)
└── Tarea02/ ...         ← copiar la plantilla para las siguientes entregas
└── PracticaNN/ ...
└── ProyectoFinal/ ...
```

## ¿Cómo compilar una tarea?

Desde la carpeta de la entrega (p. ej. `Tarea01/`):

```bash
pdflatex main.tex
bibtex   main
pdflatex main.tex
pdflatex main.tex
```

El PDF resultante es `main.pdf`. También funciona subir la carpeta a Overleaf.

## Convención de nombres (obligatoria según lineamientos)

La entrega final se empaqueta como `TareaNN_Equipo.zip` (p. ej.
`Tarea01_ÑIPGG.zip`) y su estructura interna es:

```
Tarea01_Equipo.zip
├── README_Equipo.pdf      ← nombre y nº de cuenta de cada integrante + observaciones
└── Docs/
    └── Tarea01.pdf        ← documento con todos los ejercicios en orden
```

- Las carpetas `Diagramas/` y `SQL/` **solo** se incluyen si la tarea/práctica
  lo solicita. Para la Tarea 1 no hacen falta.
- El **líder** sube el `.zip` en Classroom; los demás suben solo una copia de
  `README_Equipo.pdf`.
- No usar caracteres extra en los nombres de archivo (se penaliza con −10 pts).

## Trabajo modular por equipo

Cada inciso vive en su propio archivo de `secciones/`. Así cada integrante
edita únicamente sus archivos y no hay conflictos de edición en el repositorio.

Reparto sugerido (5 integrantes; ajusten cuando decidan quién hace qué):

| Integrante | Incisos asignados       | Archivos                     |
|------------|-------------------------|------------------------------|
| 1          | 1a, 1b                  | `ejercicio_1a.tex`, `ejercicio_1b.tex` |
| 2          | 1c, 1d                  | `ejercicio_1c.tex`, `ejercicio_1d.tex` |
| 3          | 1e, 1f, 1g              | `ejercicio_1e.tex`, `ejercicio_1f.tex`, `ejercicio_1g.tex` |
| 4          | 1h, 1i, 1j              | `ejercicio_1h.tex`, `ejercicio_1i.tex`, `ejercicio_1j.tex` |
| 5          | 2a, 2b                  | `ejercicio_2a.tex`, `ejercicio_2b.tex` |

Para crear una nueva entrega, copia la carpeta `Tarea01/` y renómbrala según la
convención, vaciando el contenido de `secciones/`.

