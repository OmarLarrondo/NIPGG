# Práctica 02 - estructura modular de trabajo

Esta carpeta contiene únicamente el esqueleto colaborativo de la Práctica 02.
No incluye respuestas del reporte, clases Java, métodos, archivos CSV con datos
ni resultados de ejecución.

## Estructura

```text
Practica02/
├── README.md
├── README_ÑIPGG.tex             # fuente del README_ÑIPGG.pdf
├── Docs/                        # destino de Practica02.pdf
├── reporte/
│   ├── main.tex
│   ├── preambulo.tex
│   ├── bibliografia.bib
│   ├── figuras/
│   └── secciones/
│       ├── 00_portada.tex
│       ├── 01_introduccion.tex
│       ├── 02_requerimientos_candidatos.tex
│       ├── 03_contexto_sistema.tex
│       ├── 04_requerimientos_funcionales.tex
│       ├── 05_requerimientos_no_funcionales.tex
│       ├── 06_diseno_prototipo.tex
│       ├── 07_archivos_vs_bd.tex
│       ├── 08_eleccion_tecnologica.tex
│       └── 09_conclusiones.tex
└── SRC/
    ├── datos/                    # CSV persistentes, cuando se implementen
    ├── Doc/                      # Javadoc generado para la entrega
    ├── main/java/mx/unam/ciencias/nipgg/puellagame/
    │   ├── app/                  # composición y punto de entrada
    │   ├── model/                # Sucursal, Premio y Cliente
    │   ├── repository/           # contrato y persistencia CSV
    │   ├── service/              # casos de uso y reglas de negocio
    │   ├── ui/                   # menú e interacción por consola
    │   ├── validation/           # validación de entradas y tipos
    │   └── exception/            # excepciones del dominio/persistencia
    └── test/java/mx/unam/ciencias/nipgg/puellagame/
        ├── repository/
        └── service/
```

La separación sigue una arquitectura por capas. El patrón **Repository** aísla
el almacenamiento CSV del resto del programa y la capa **Service** concentra
los casos de uso. Esto permite desarrollar o probar una capa sin mezclarla con
el menú ni con el formato físico de los archivos.

## División sugerida para cinco integrantes

El reparto combina una responsabilidad de Java y una de documentación por
persona. La integración y la revisión cruzada son responsabilidad compartida.

| Opción | Responsabilidad Java | Módulos del reporte | Revisión cruzada |
|---|---|---|---|
| Integrante 1 - Yahir León Bautista | Modelos de las tres entidades y contratos comunes | Introducción y requerimientos candidatos | Revisa a Ana Lilia |
| Integrante 2 - Omar Alejandro Juárez Larrondo | Repositorios CSV y estrategia de lectura/escritura | Contexto del sistema | Revisa a Miguel Ángel |
| Integrante 3 - Ana Lilia Carballido Camacateco | Servicios CRUD y búsqueda por llave | Requerimientos funcionales | Revisa a Diego |
| Integrante 4 - Miguel Ángel Jiménez Ramírez | Menú, navegación e interacción por consola | Requerimientos no funcionales | Revisa a Yahir |
| Integrante 5 - Diego Hernández Gómez | Validaciones, excepciones y pruebas transversales | Diseño, comparación y elección tecnológica | Revisa a Omar |

Para equilibrar la carga, los modelos incluyen las tres entidades y sus
contratos; persistencia y servicios comparten los casos de prueba; interfaz se
encarga también del flujo completo del menú; y la responsabilidad transversal
de validación incluye las pruebas de error. Portada, conclusiones, bibliografía,
Javadoc final, empaquetado y prueba integral se cierran entre todo el equipo.

## Archivos y directorios por opción

Las rutas siguientes establecen el área principal de edición de cada opción.
Los nombres de las clases todavía no están definidos; cada archivo Java nuevo
deberá crearse dentro del paquete indicado. Nadie debe modificar módulos ajenos
sin coordinarlo previamente con su responsable.

### Integrante 1 - Yahir León Bautista

Responsabilidad: modelos y requerimientos iniciales.

- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/model/`
- `reporte/secciones/01_introduccion.tex`
- `reporte/secciones/02_requerimientos_candidatos.tex`
- Pruebas de modelos, si se requieren, dentro de la ruta equivalente en
  `SRC/test/java/mx/unam/ciencias/nipgg/puellagame/`.

### Integrante 2 - Omar Alejandro Juárez Larrondo

Responsabilidad: persistencia CSV y contexto.

- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/repository/`
- `SRC/datos/`, para definir y mantener los archivos CSV de las entidades.
- `reporte/secciones/03_contexto_sistema.tex`
- `SRC/test/java/mx/unam/ciencias/nipgg/puellagame/repository/`

### Integrante 3 - Ana Lilia Carballido Camacateco

Responsabilidad: servicios CRUD y requerimientos funcionales.

- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/service/`
- `reporte/secciones/04_requerimientos_funcionales.tex`
- `SRC/test/java/mx/unam/ciencias/nipgg/puellagame/service/`

### Integrante 4 - Miguel Ángel Jiménez Ramírez

Responsabilidad: menú y requerimientos no funcionales.

- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/ui/`
- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/app/`
- `reporte/secciones/05_requerimientos_no_funcionales.tex`
- Pruebas de interacción, si se requieren, dentro de la ruta equivalente en
  `SRC/test/java/mx/unam/ciencias/nipgg/puellagame/`.

### Integrante 5 - Diego Hernández Gómez

Responsabilidad: validación, errores y análisis comparativo.

- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/validation/`
- `SRC/main/java/mx/unam/ciencias/nipgg/puellagame/exception/`
- `reporte/secciones/06_diseno_prototipo.tex`
- `reporte/secciones/07_archivos_vs_bd.tex`
- `reporte/secciones/08_eleccion_tecnologica.tex`
- Pruebas de validación y excepciones, dentro de la ruta equivalente en
  `SRC/test/java/mx/unam/ciencias/nipgg/puellagame/`.

### Archivos compartidos

Estos archivos no pertenecen a una sola opción y deben modificarse mediante
acuerdo del equipo para evitar conflictos:

- `reporte/main.tex` y `reporte/preambulo.tex`.
- `reporte/secciones/00_portada.tex`.
- `reporte/secciones/09_conclusiones.tex`.
- `reporte/bibliografia.bib` y `reporte/figuras/`.
- `README_ÑIPGG.tex` y este `README.md`.
- `SRC/Doc/`, porque contendrá el Javadoc generado durante la integración.

## Contratos de integración que deben acordarse antes de programar

- Campos, tipos y llave única de `Sucursal`, `Premio` y `Cliente`.
- Encabezado, delimitador, codificación y reglas de escape de cada CSV.
- Operaciones comunes de alta, consulta, edición y eliminación.
- Forma de comunicar errores entre repositorio, servicio e interfaz.
- Ubicación de los archivos al ejecutar y al preparar el ZIP.

## Entregables previstos

```text
Practica02_ÑIPGG.zip
├── SRC/
│   ├── ... fuentes .java, compilados .class y archivos .csv
│   └── Doc/                      # documentación generada
├── Docs/
│   └── Practica02.pdf
└── README_ÑIPGG.pdf
```

No se crea `Diagramas/` ni `SQL/` porque la Práctica 02 no los solicita. La
estructura de desarrollo podrá conservar pruebas y paquetes; al cierre deberá
verificarse que el paquete entregable incluya exactamente los artefactos pedidos.
