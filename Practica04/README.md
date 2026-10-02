# Práctica 04 - Modelo Relacional

Estructura de coordinación para la práctica del equipo **ÑIPGG**. La actividad
parte del modelo E-R elaborado en la Práctica 03 y solicita su conversión a un
diagrama relacional, además de un PDF que describa dominios, restricciones y
llaves de cada relación. El equipo confirmó la distribución de las cinco
opciones que se detalla a continuación.

## Opciones para dividir el trabajo

Cada opción incluye una zona del diagrama y el contenido relacionado del
reporte. El trabajo del diagrama se realizará sobre un único archivo Draw.io;
las conexiones que crucen zonas se coordinarán entre las personas responsables.

| Opción | Responsable | Módulo | Alcance |
| --- | --- | --- | --- |
| 1 | Diego | Clientes y partidas | **Diagrama:** `Cliente`, `Tarjeta`, `Partida` y sus atributos; revisar las relaciones `Poseer` y `Registrar`. **Reporte:** documentar la conversión de esas entidades y relaciones, con dominios, tipos y llaves. |
| 2 | Miguel | Juegos y máquinas | **Diagrama:** `Máquina`, `Juego`, `Tipo de juego`, `Mantenimiento` y sus atributos; revisar `Ejecutar`, `Corresponder`, `Clasificar` y `Tener`. **Reporte:** documentar sus relaciones, dominios, tipos, llaves y restricciones. |
| 3 | Yahir | Canjes y premios | **Diagrama:** `Canje`, `Premio` y sus atributos; revisar `Hacer`, `Otorgar`, `Disponer` y `Saldar`. **Reporte:** documentar su conversión, incluidas las llaves y los atributos que pertenecen a las relaciones. |
| 4 | Omar | Sucursal, visitas y recargas | **Diagrama:** `Sucursal`, `Visita`, `Recarga` y sus atributos; revisar `Pertenecer`, `ingresar`, `Recibir`, `Efectuar` y `Proceder en`. **Reporte:** documentar dominios, tipos, llaves y restricciones de esta zona. |
| 5 | Ana | Personal e integración | **Diagrama:** `Empleado`, `Gerente`, `Cajero`, `Encargado de premios` y `Técnico`, incluida la especialización y relaciones `Vender`, `Reflejar`, `Trabajar`, `Administrar` y `Realizar`. **Reporte:** documentar esta conversión y revisar de extremo a extremo llaves, dominios, tipos, cardinalidades, participaciones y consistencia entre ambos diagramas y el PDF. |

Las conexiones que cruzan zonas deben conservarse en el diagrama y revisarse
entre las personas responsables de las zonas involucradas. La revisión global
de la opción 5 complementa la responsabilidad compartida de integrar el
diagrama y el PDF.

## Estructura

```text
Practica04/
├── Diagramas/
│   ├── README.md
│   ├── RelacionalÑIPGG.drawio
│   ├── RelacionalÑIPGG.png
│   ├── ERÑIPGG.drawio
│   └── ERÑIPGG.png
├── Docs/
│   └── Practica04.pdf
├── reporte/
│   ├── main.tex
│   └── secciones/
│       ├── 01_clientes_partidas.tex
│       ├── 02_juegos_maquinas.tex
│       ├── 03_canjes_premios.tex
│       ├── 04_sucursal_visitas_recargas.tex
│       └── 05_personal_integracion.tex
└── README.md
```

Los nombres de diagramas y destinos siguen la convención del ejemplo de
entrega de la práctica. Los archivos de diagramas, fuentes y PDF se agregarán
al avanzar el equipo.

## Diagramas

Los diagramas se crearán en línea con diagrams.net (draw.io) y luego se
exportarán a `Diagramas/`. El diagrama relacional se trabajará como un único
archivo compartido: cada opción prepara su zona y coordina los enlaces con las
zonas vecinas, sin duplicar entidades o relaciones. Al integrarlo, revisar el
diagrama completo contra el E-R de la Práctica 03. Se deben conservar tanto el
archivo editable `.drawio` como la exportación `.png` de cada diagrama.

## Contenido solicitado

- Diagrama relacional con las entidades, atributos y sus tipos, así como las
  cardinalidades y participaciones indicadas por el modelo E-R.
- PDF `Docs/Practica04.pdf` con los dominios de los atributos, restricciones
  cuando existan, y llaves primarias, foráneas y compuestas de cada relación.
- Diagramas editables y exportados: `RelacionalÑIPGG.drawio`,
  `RelacionalÑIPGG.png`, `ERÑIPGG.drawio` y `ERÑIPGG.png`.

La práctica solicita un ZIP para Classroom con la organización que especifica
el documento. La preparación del paquete final se hará cuando estén listos los
artefactos.

## Organización del reporte

Cada archivo de `reporte/secciones/` corresponde a una de las opciones
propuestas. Al desarrollar el contenido, registrar para cada relación los
atributos con sus dominios y tipos, sus llaves y las restricciones aplicables.
La integración debe asegurar que la nomenclatura y las decisiones coincidan
con ambos diagramas.
