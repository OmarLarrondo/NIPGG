# Evidencias de restauración

Restauración de `ejemplo.backup` realizada el 26 de octubre de 2026 con PostgreSQL 16.15. El respaldo original procede de PostgreSQL 16.3 y utiliza la extensión `adminpack`.

## Resultados

- Restauración con transacción única y código de salida 0.
- 46 tablas, 31 secuencias, 22 claves primarias, 62 claves foráneas y 55 CHECK.
- Ninguna restricción sin validar.
- Cero filas en las tablas, coincidentes con los 46 bloques COPY vacíos del respaldo original. Se recuperan la estructura y los estados de las secuencias.

## Capturas incluidas

| Archivo | Contenido |
|---|---|
| [01_inspeccion.png](01_inspeccion.png) | Formato, versiones y base de destino vacía. |
| [02_restauracion.png](02_restauracion.png) | Comando de restauración y código de salida. |
| [03_verificacion.png](03_verificacion.png) | Objetos y restricciones recuperados. |
| [04_consultas.png](04_consultas.png) | Consultas y contraste con el contenido original. |

Las capturas se incorporan al [informe](../../../Docs/Práctica05.pdf) mediante [06_restauracion.tex](../../secciones/06_restauracion.tex). Los registros y consultas auxiliares permanecen fuera de la publicación.

## Compilar el informe

Desde `reporte/`, ejecutar dos veces `pdflatex -halt-on-error main.tex` y copiar `main.pdf` a `../Docs/Práctica05.pdf`.
