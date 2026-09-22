# Práctica 03 - Modelo Entidad-Relación Extendido

Entrega final del equipo **ÑIPGG** para el caso de uso *PuellaGame*. El
diagrama editable, su exportación en alta resolución y el reporte describen la
misma versión del modelo.

## Entregable

El archivo listo para subir es `entrega/Practica03_ÑIPGG.zip` y contiene:

```text
Practica03_ÑIPGG.zip
├── README_ÑIPGG.pdf
├── Diagramas/
│   ├── ERÑIPGG.drawio
│   └── ERÑIPGG.png
└── Docs/
    └── Practica03.pdf
```

No se incluye una carpeta `SQL`, porque la Práctica 03 sólo solicita el
modelo E-R extendido, su imagen y los dos PDF. Los nombres siguen tanto la
especificación de la práctica como los lineamientos generales de entrega.

## Fuentes

- `reporte/`: fuente LaTeX modular de `Docs/Practica03.pdf`.
- `README_ÑIPGG.tex`: fuente de `README_ÑIPGG.pdf`.
- `Diagramas/ERÑIPGG.drawio`: XML editable de diagrams.net.
- `Diagramas/ERÑIPGG.png`: exportación final de 5490 x 4272 px.

## Verificación realizada

- se comparó el XML editable con el XML incrustado en la exportación final;
- se reconciliaron entidades, atributos, relaciones, cardinalidades,
  participaciones e identificadores con el reporte;
- se incorporó el diagrama al PDF, como exigen los lineamientos;
- se completaron especialización, ausencia de agregación, decisiones de
  diseño y conclusiones;
- se revisó la estructura y el contenido del ZIP antes de la entrega.

## Compilación

Desde esta carpeta:

```bash
(cd reporte && latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=../tmp/pdfs main.tex)
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=tmp/readme README_ÑIPGG.tex
```

Los PDF finales se copian a `Docs/Practica03.pdf` y
`README_ÑIPGG.pdf`, respectivamente.
