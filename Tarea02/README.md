# Tarea 02 - Modelo Entidad-Relación

Entrega del equipo **ÑIPGG** para Fundamentos de Bases de Datos.

## Contenido

- `Docs/Tarea02.pdf`: reporte completo con los ejercicios 1, 2-i, 2-ii y
  3-a a 3-c, las decisiones de diseño y las referencias.
- `Diagramas/`: fuentes editables de Draw.io y exportaciones PNG de los
  ejercicios 2-ii, 3-a, 3-b y 3-c.
- `README_ÑIPGG.pdf`: nombres completos y números de cuenta de los cinco
  integrantes.
- `reporte/`: fuentes LaTeX utilizadas para generar el reporte.

## Integrantes

| Integrante | Número de cuenta |
|---|---:|
| Omar Alejandro Juárez Larrondo | 322245244 |
| Yahir León Bautista | 322176542 |
| Diego Hernández Gómez | 321069942 |
| Miguel Ángel Jiménez Ramírez | 119000887 |
| Ana Lilia Carballido Camacateco | 315314601 |

## Compilación

El reporte se compila desde `reporte/`:

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error main.tex
```

El README de entrega se compila desde la raíz de `Tarea02/`:

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error README_ÑIPGG.tex
```

## Paquete de entrega

El archivo `Tarea02_ÑIPGG.zip` contiene únicamente:

```text
Tarea02_ÑIPGG/
├── README_ÑIPGG.pdf
├── Diagramas/
│   ├── Ejercicio2ii.drawio
│   ├── Ejercicio2ii.png
│   ├── Ejercicio3a.drawio
│   ├── Ejercicio3a.drawio.png
│   ├── Ejercicio3b.drawio
│   ├── Ejercicio3b.drawio.png
│   ├── Ejercicio 3c.drawio
│   └── Ejercicio 3c.png
└── Docs/
    └── Tarea02.pdf
```

No se incluye una carpeta `SQL`, ya que esta tarea no solicita archivos SQL.
