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
│   │   ├── ejercicio_2a.tex  ← resumen (por equipo)
│   │   ├── ejercicio_2b_<apellido>.tex  ← ensayo individual (1 por persona)
│   │   └── ...
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

### Nota sobre la Sección 2 (lectura)

- **2a. Resumen** → es **por equipo** (un solo resumen). Archivo
  `ejercicio_2a.tex`.
- **2b. Ensayo** → es **individual** (uno por cada integrante). Hay un archivo
  por persona: `ejercicio_2b_<apellido>.tex`.

### Reparto sugerido (equitativo por dificultad)

El reparto equilibra la carga de la Sección 1 entre los 5 integrantes, emparejando
incisos de alta dificultad con otros más ligeros. Recuerda que **cada integrante
además redacta su propio ensayo (2b)**.

| Integrante | Incisos (Sección 1)    | Dificultad      | Archivos de Sección 1      |
|------------|------------------------|-----------------|----------------------------|
| 1          | 1h, 1d                 | alta + ligera   | `ejercicio_1h.tex`, `ejercicio_1d.tex` |
| 2          | 1j, 1e                 | alta + ligera   | `ejercicio_1j.tex`, `ejercicio_1e.tex` |
| 3          | 1b, 1f                 | alta + ligera   | `ejercicio_1b.tex`, `ejercicio_1f.tex` |
| 4          | 1a, 1i                 | media + ligera  | `ejercicio_1a.tex`, `ejercicio_1i.tex` |
| 5          | 1c, 1g                 | media + media   | `ejercicio_1c.tex`, `ejercicio_1g.tex` |

- **1h** (tabla comparativa de 4+ modelos) y **1j** (varias desventajas de
  sistema de archivos) son los de mayor extensión/razonamiento → van emparejados
  con **1d** y **1e** (conceptuales y cortos).
- **1b** (comparar 2 SMBD) y **1f** (investigación) son de extensión media-alta →
  emparejados con incisos cortos.
- **2a** (resumen) queda como esfuerzo **colaborativo** de todo el equipo o a
  cargo de quien coordine la sección; no se suma a la carga individual.

Para crear una nueva entrega, copia la carpeta `Tarea01/` y renómbrala según la
convención, vaciando el contenido de `secciones/`.

