# Tarea 04 — Omar Larrondo

Resueltos: C02, C05, Q_a, Q_i y M_a.

- Documento individual: [PDF](output/pdf/Tarea04_OmarLarrondo.pdf).
- Fuente editable: [LaTeX](reporte/Tarea04_OmarLarrondo.tex).
- Desarrollo: [cardinalidades](cardinalidad.md), [consultas](consultas.md), [mantenimiento](mantenimiento.md).
- Expresiones ejecutables: archivos `.relax` de esta carpeta.
- Datos originales, procedencia y resultado completo de Q_a: `datos/`.
- Capturas reales de resultados y árboles: `evidencias/`.

Para comprobar una expresión, cargar en [Relax](https://dbis-uibk.github.io/relax/calc/gist/31074567738afef8c497f6ca89335782) el dataset indicado, seleccionar Relational Algebra y ejecutar el archivo correspondiente con Ctrl+Enter. Las cardinalidades declaran R y S dentro de la propia expresión. El mantenimiento calcula estados posteriores independientes; la operación con asignación está explicada en el documento.

Para recompilar el PDF, desde `reporte/`:

```sh
pdflatex -interaction=nonstopmode -halt-on-error -output-directory=../output/pdf Tarea04_OmarLarrondo.tex
```

La integración de la entrega del equipo requiere las aportaciones de los otros módulos. Este documento contiene los cinco incisos de Omar.


La portada y el diseño están en `reporte/portada_equipo.tex` y `reporte/estilo.tex`. El módulo incluye todas las dependencias necesarias para compilar. Ejecutar la compilación dos veces para actualizar el índice.
