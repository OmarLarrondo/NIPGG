# Práctica 01 — estructura de trabajo

Esta carpeta contiene únicamente la estructura modular en LaTeX para las
bitácoras individuales y el README del equipo. Las preguntas se redactan en
Google Docs y no tienen un archivo fuente LaTeX en este repositorio.

## Organización

```text
Practica01/
├── preambulo.tex
├── README_ÑIPGG.tex
├── Docs/                         # PDFs finales para el archivo ZIP
└── bitacoras/
    ├── juarez/
    ├── leon/
    ├── hernandez/
    ├── jimenez/
    └── carballido/
```

Cada carpeta individual contiene un `main.tex`, módulos en `secciones/` y una
carpeta `capturas/`. Cada integrante debe modificar únicamente su propia
carpeta. El archivo `preambulo.tex` es compartido por todo el equipo.

## Compilación

Los comandos se ejecutan desde `Practica01/`. Por ejemplo:

```bash
latexmk -pdf -jobname='BitácoraJuárez' bitacoras/juarez/main.tex
```

Los nombres de salida previstos son:

- `BitácoraJuárez.pdf`
- `BitácoraLeón.pdf`
- `BitácoraHernández.pdf`
- `BitácoraJiménez.pdf`
- `BitácoraCarballido.pdf`
- `README_ÑIPGG.pdf`

Al preparar la entrega, los cinco PDF de bitácora y el PDF exportado desde
Google Docs con las preguntas deben colocarse en `Docs/`. El PDF del README se
coloca en la raíz del ZIP `Práctica01_ÑIPGG.zip`.
