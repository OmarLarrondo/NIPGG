# Tarea 02 - Modelo Entidad-Relación

Esta carpeta contiene la estructura modular de trabajo para la Tarea 02 de
Fundamentos de Bases de Datos. En esta etapa se preparan únicamente las
fronteras de trabajo, los archivos de coordinación y el esqueleto del reporte;
no se incluyen respuestas, modelos terminados, datos ni diagramas.

## Lineamientos considerados

La tarea solicita responder los conceptos del modelo E-R, analizar las
propuestas de sitios de taxis, modificar el modelo E-R de una universidad y
diseñar tres mini-mundos: números racionales, el modelo E-R y un SIG para
SEMARNAT. Los ejercicios que requieren modelo deben elaborarse con la
notación vista en clase y explicitar cardinalidad, participación,
identificadores, restricciones y decisiones de diseño. Los diagramas se
trabajarán en línea con Draw.io.

La entrega se realizará conforme a los lineamientos indicados en Classroom.
Los nombres definitivos del equipo y de los archivos de entrega se completarán
cuando el equipo los confirme.

## Estructura modular

```text
Tarea02/
├── README.md
├── Diagramas/
│   └── README.md
├── Docs/
│   └── .gitkeep
└── reporte/
    ├── main.tex
    ├── preambulo.tex
    ├── bibliografia.bib
    ├── figuras/
    │   └── .gitkeep
    └── secciones/
        ├── 00_portada.tex
        ├── 01_conceptos_modelo_er.tex
        ├── 02_sitios_taxis.tex
        ├── 03_modelo_universidad.tex
        ├── 04_numeros_racionales.tex
        ├── 05_modelo_er_modelo_er.tex
        ├── 06_sig_semarnat.tex
        ├── 07_decisiones_diseno.tex
        └── 08_conclusiones.tex
```

## División propuesta para cinco integrantes

La división separa cada ejercicio en un módulo principal. Cada integrante
documentará también las decisiones y restricciones de su propio ejercicio,
para evitar concentrar toda la integración conceptual en una sola persona.

| Integrante | Responsabilidad principal | Rutas editables | Revisión cruzada |
|---|---|---|---|
| Omar-1 | Conceptos del modelo E-R, coordinación del reporte y cierre editorial | `reporte/secciones/00_portada.tex`, `reporte/secciones/01_conceptos_modelo_er.tex` | Diego-3 |
| Yahir-2 | Análisis de sitios, choferes y taxis | `reporte/secciones/02_sitios_taxis.tex` | Ana-4 |
| Diego-3 | Modificación del modelo E-R de la universidad | `reporte/secciones/03_modelo_universidad.tex` | Miguel-5 |
| Ana-4 | Mini-mundos de números racionales y del modelo E-R | `reporte/secciones/04_numeros_racionales.tex`, `reporte/secciones/05_modelo_er_modelo_er.tex` | Yahir-2 |
| Miguel-5 | Sistema de Información Geográfica de SEMARNAT | `reporte/secciones/06_sig_semarnat.tex` | Omar-1 |

La sección `07_decisiones_diseno.tex` reunirá las decisiones transversales y
se completará con aportaciones de los cinco integrantes. La sección
`08_conclusiones.tex`, `main.tex`, `preambulo.tex`, `bibliografia.bib` y
`Diagramas/README.md` son archivos compartidos: se modifican únicamente por
acuerdo del equipo. Omar-1 coordina la integración editorial, pero
no absorbe el contenido técnico de los demás módulos.

## Reglas de colaboración

- Cada integrante trabaja principalmente dentro de las rutas asignadas.
- Los diagramas se mantienen en Draw.io en línea; esta estructura no crea una
  copia local provisional del archivo fuente.
- Antes de integrar, cada módulo debe acordar nombres, atributos,
  identificadores, cardinalidades, participación y restricciones.
- Las decisiones asumidas por falta de información deben quedar documentadas
  en el módulo correspondiente y resumidas en `07_decisiones_diseno.tex`.
- No se agregan respuestas, resultados ni implementaciones hasta que el equipo
  termine la etapa de estructura.

## Estructura prevista de entrega

```text
Tarea02_ÑIPGG.zip
├── Diagramas/
│   ├── <diagramas-exportados-desde-DrawIO>
│   └── README.md
├── Docs/
│   └── Tarea02.pdf
└── README_<nombre-del-equipo>.pdf
```

Los nombres exactos y formatos finales se verificarán contra los lineamientos
de entrega antes de preparar el archivo comprimido.
