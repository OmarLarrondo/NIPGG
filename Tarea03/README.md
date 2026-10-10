# Tarea 03 - Modelo Relacional

Estructura de coordinación para la tarea del equipo **ÑIPGG**. La actividad
cubre preguntas de repaso sobre el modelo relacional, traducción de modelos
E-R al modelo relacional, inserción de tuplas y restricciones de integridad.
Este documento propone cinco opciones de trabajo; no asigna integrantes ni
confirma un reparto.

## Opciones para dividir el trabajo

El reparto quedó acordado: Omar toma la opción 1, Yahir la 2, Ana la 3,
Miguel la 4 y Diego la 5. Cada opción incluye el ejercicio y los artefactos
relacionados.

| Integrante | Opción | Módulo | Alcance asignado |
| --- | --- | --- | --- |
| Omar | 1 | Repaso + integridad (parte 1) | **Archivos:** `01_repaso.tex`, `06_integridad_4abcde.tex`. **Reporte:** responder el Ejercicio 1 completo (incisos i a v) y resolver el Ejercicio 4 incisos a a e con justificación. |
| Yahir | 2 | Ejercicio 2.a – Traducción E-R a relacional | **Archivos:** `02_ejercicio2a.tex`. **Diagramas:** E-R y modelo relacional del inciso 2.a en Draw.io. **Reporte:** traducción, restricciones de entidad e integridad referencial, y decisiones de diseño. |
| Ana | 3 | Ejercicio 2.b – SIG SEMARNAT | **Archivos:** `03_ejercicio2b.tex`. **Diagramas:** E-R (con las mejoras sobre Tarea 02) y modelo relacional en Draw.io. **Reporte:** traducción, restricciones, justificación de los cambios al diseño original. |
| Miguel | 4 | Ejercicio 3 – Inserción de tuplas (parte 1) | **Archivos:** `04_insercion_3abc.tex`. **Reporte:** tabla de cardinalidades del 3.a y resolución justificada de los incisos 3.b y 3.c. |
| Diego | 5 | Inserción de tuplas (parte 2) + integridad (parte 2) | **Archivos:** `05_insercion_3d.tex`, `07_integridad_4fghij.tex`. **Reporte:** resolver el inciso 3.d (conjuntos insertables y no insertables, con justificación) y el Ejercicio 4 incisos f a j. |

La integración final (nomenclatura, decisiones de diseño, revisión global y
compilación del PDF) es responsabilidad de todo el equipo; se recomienda que
quien integre verifique cada módulo contra los diagramas en Draw.io.

## Estructura

```text
Tarea03/
├── Diagramas/
│   ├── README.md
│   ├── Ejercicio2a_ER.drawio / .png
│   ├── Ejercicio2a_Relacional.drawio / .png
│   ├── Ejercicio2b_ER.drawio / .png
│   └── Ejercicio2b_Relacional.drawio / .png
├── Docs/
│   └── Tarea03.pdf
├── reporte/
│   ├── main.tex
│   └── secciones/
│       ├── 01_repaso.tex
│       ├── 02_ejercicio2a.tex
│       ├── 03_ejercicio2b.tex
│       ├── 04_insercion_3abc.tex
│       ├── 05_insercion_3d.tex
│       ├── 06_integridad_4abcde.tex
│       ├── 07_integridad_4fghij.tex
│       └── 08_decisiones_diseno.tex
├── Tarea03_ModeloR.pdf
└── README.md
```

Los nombres de diagramas y destinos siguen la convención de las entregas
anteriores. Los archivos de diagramas, fuentes y PDF se agregarán al avanzar
el equipo.

## Diagramas

Los diagramas se crearán en línea con diagrams.net (draw.io) y luego se
exportarán a `Diagramas/`. Se conservarán tanto el archivo editable `.drawio`
como la exportación `.png` de cada diagrama (ejercicios 2.a, 2.b y los que
hagan falta del ejercicio 3).

## Contenido solicitado

- Respuestas a las preguntas de repaso (Ejercicio 1).
- Modelo relacional completo para 2.a y 2.b con restricciones de entidad e
  integridad referencial, diagramas E-R y relacionales, y justificación de
  cambios.
- Tabla de cardinalidades y análisis de inserción de tuplas (Ejercicio 3).
- Evaluación de afirmaciones sobre restricciones de integridad (Ejercicio 4).
- PDF `Docs/Tarea03.pdf` integrador de los cinco módulos.

La tarea se entrega por equipo conforme a los lineamientos de Classroom. La
preparación del paquete final se hará cuando estén listos los artefactos.

## Organización del reporte

Cada archivo de `reporte/secciones/` pertenece a una opción concreta, de modo
que cada integrante trabaje en sus propios archivos sin solaparse con los
demás. La opción 1 escribe en `01_repaso.tex` y `06_integridad_4abcde.tex`;
la opción 5 en `05_insercion_3d.tex` y `07_integridad_4fghij.tex`; las
opciones 2, 3 y 4 en `02_ejercicio2a.tex`, `03_ejercicio2b.tex` y
`04_insercion_3abc.tex`, respectivamente. `08_decisiones_diseno.tex` es
compartido y se completa al integrar. Al desarrollar el contenido,
documentar las decisiones de diseño, las llaves primarias y foráneas, y la
integridad referencial donde aplique. La integración debe asegurar que la
nomenclatura y las decisiones coincidan con los diagramas.

## Ensamblado del reporte

`reporte/main.tex` es el único punto de integración: invoca los ocho módulos en
el orden del enunciado y no debe modificarse al escribir contenido. El preámbulo
común vive en `reporte/preambulo.tex` y las referencias en
`reporte/bibliografia.bib`, de modo que las secciones no dependan entre sí.

Para que los incisos de un mismo ejercicio queden agrupados bajo un único
encabezado, cada módulo debe respetar el siguiente contrato de niveles de
sección:

| Archivo | Encabezado | Ejercicio |
| --- | --- | --- |
| `01_repaso.tex` | `\section` | Ejercicio 1 |
| `02_ejercicio2a.tex` | `\section` | Ejercicio 2 |
| `03_ejercicio2b.tex` | `\subsection` | Ejercicio 2.b |
| `04_insercion_3abc.tex` | `\section` | Ejercicio 3 |
| `05_insercion_3d.tex` | `\subsection` | Ejercicio 3.d |
| `06_integridad_4abcde.tex` | `\section` | Ejercicio 4 |
| `07_integridad_4fghij.tex` | `\subsection` | Ejercicio 4, incisos f a j |
| `08_decisiones_diseno.tex` | `\section` | Decisiones de diseño |

La regla es que el primer módulo de cada ejercicio abre con `\section` y los que
lo continúan usan `\subsection`. Las decisiones de diseño de cada módulo se
registran en la subsección correspondiente de `08_decisiones_diseno.tex`.

El PDF final se genera en `Docs/Tarea03.pdf` con cuatro pasadas de `pdflatex` y
`bibtex`. Antes de publicar la entrega conviene comprobar que no queden
referencias indefinidas ni cajas de texto desbordadas.

## Paquete preparado

`Tarea03_ÑIPGG.zip` contiene el README del equipo, el PDF integrado y los
diagramas disponibles. El E/R de 2.a es la imagen del enunciado; el de 2.b
se recuperó del SIG de Tarea02 (`Ejercicio 3c`).

El inciso 3.d justifica la incompatibilidad del enunciado: en 1:1, con
cuatro claves de A, el máximo conjunto válido tiene cuatro tuplas.
El diagrama `Ejercicio3a.drawio` y su exportación `Ejercicio3a.png`
contienen las cuatro traducciones M:N, 1:N, N:1 y 1:1. Se incluyen en
el ZIP y en el reporte final.
