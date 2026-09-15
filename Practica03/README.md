# Práctica 03 - Modelo Entidad-Relación Extendido

Esta carpeta contiene la estructura de trabajo para la Práctica 03 del caso de
uso del equipo. En esta etapa únicamente se preparan las fronteras de trabajo,
los archivos de coordinación y el esqueleto del documento; todavía no se
incluyen entidades, relaciones, restricciones ni decisiones del modelo.

## Lineamientos considerados

La práctica solicita una primera versión del modelo Entidad-Relación
Extendido, elaborada con DrawIO, legible y completamente ordenada. La entrega
debe contener los archivos `ERNombreDeSuEquipo.drawio` y
`ERNombreDeSuEquipo.png`. También se debe entregar `Practica03.pdf`, con la
documentación de cardinalidad, participación, identificadores y demás
restricciones, además de las decisiones y consideraciones de diseño del equipo.

Los diagramas se trabajarán en línea. Por ello, `Diagramas/README.md` funciona
como registro de enlaces, responsables y control de versiones del diagrama;
no se crea un archivo `.drawio` provisional ni se rellena el modelo en esta
fase.

## Estructura modular

```text
Practica03/
├── README.md
├── README_ÑIPGG.tex             # fuente del README de la entrega
├── Diagramas/
│   └── README.md                # enlaces y control del diagrama en línea
├── Docs/
│   └── .gitkeep                 # reservado para Practica03.pdf
└── reporte/
    ├── main.tex                 # ensamblador del documento
    ├── preambulo.tex            # configuración compartida
    ├── bibliografia.bib         # referencias acordadas por el equipo
    ├── figuras/                 # exportaciones para el PDF, si se requieren
    └── secciones/
        ├── 00_portada.tex
        ├── 01_descripcion_caso.tex
        ├── 02_entidades_atributos.tex
        ├── 03_relaciones_cardinalidad.tex
        ├── 04_participacion_identificadores.tex
        ├── 05_especializacion_generalizacion.tex
        ├── 06_agregacion.tex
        ├── 07_decisiones_diseno.tex
        └── 08_conclusiones.tex
```

Los archivos de las secciones contienen únicamente marcadores de trabajo. La
información del modelo se agregará después de que el equipo acuerde el caso de
uso y revise el diagrama colaborativamente.

## División confirmada para cinco integrantes

Cada integrante trabaja principalmente en su ruta y coordina los cambios que
afecten al diagrama o al ensamblador del reporte.

| Integrante | Responsabilidad principal | Rutas editables | Revisión cruzada |
|---|---|---|---|
| Omar - Integrante 1 | Caso de uso, alcance y portada | `reporte/secciones/00_portada.tex`, `reporte/secciones/01_descripcion_caso.tex` | Yahir |
| Miguel - Integrante 2 | Entidades y atributos | `reporte/secciones/02_entidades_atributos.tex` | Diego |
| Yahir - Integrante 3 | Relaciones y cardinalidades | `reporte/secciones/03_relaciones_cardinalidad.tex` | Ana |
| Diego - Integrante 4 | Participación e identificadores | `reporte/secciones/04_participacion_identificadores.tex` | Omar |
| Ana - Integrante 5 | EER avanzado y decisiones de diseño | `reporte/secciones/05_especializacion_generalizacion.tex`, `reporte/secciones/06_agregacion.tex`, `reporte/secciones/07_decisiones_diseno.tex` | Miguel |

Las conclusiones, la integración de `reporte/main.tex`, el preámbulo, la
bibliografía, la exportación del diagrama y la verificación final se realizan
entre todo el equipo. `Diagramas/README.md` es compartido y debe actualizarse
con acuerdos, enlaces y el nombre final del equipo.

## Reglas de colaboración

- El diagrama fuente se mantiene en DrawIO en línea; no se edita manualmente
  una copia local durante esta fase.
- Antes de exportar, el equipo debe acordar nombres, atributos, claves,
  cardinalidades, participación y restricciones de especialización o
  generalización.
- Cada integrante debe limitar sus cambios a sus rutas asignadas y comunicar
  cualquier modificación que impacte otra sección.
- `main.tex`, `preambulo.tex`, `bibliografia.bib`, `README.md` y
  `Diagramas/README.md` son archivos compartidos.
- La integración final debe verificar que el diagrama sea legible y ordenado,
  que el PDF documente las decisiones del equipo y que el ZIP conserve los
  nombres solicitados por los lineamientos.

## Estructura prevista de entrega

```text
Practica03_ÑIPGG.zip
├── Diagramas/
│   ├── ERNombreDeSuEquipo.drawio
│   └── ERNombreDeSuEquipo.png
├── Docs/
│   └── Practica03.pdf
└── README_NombreDeSuEquipo.pdf
```

Los nombres de equipo y de los archivos del diagrama se completarán cuando el
equipo los confirme.
