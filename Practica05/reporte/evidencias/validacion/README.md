# Validación del avance · 25 de octubre de 2026

Se usó la imagen local `postgres:18` en un contenedor temporal, sin red ni
puertos publicados, con almacenamiento temporal y una base nueva `p05_ddl`.
No se montaron directorios del usuario ni se utilizó `ejemplo.backup`.

| Registro | Resultado |
|---|---|
| `ddl.txt` | Creación y COMMIT correctos de las 24 tablas disponibles. |
| `omar.txt` | 58 casos correctos sobre las tablas reales del DDL integrado. |
| `clientes.txt` | Cuatro grupos válidos y 167 rechazos correctos, con dependencias mínimas aisladas. |
| `sucursales.txt` | 36 casos correctos, con dependencias mínimas aisladas. |
| `personal.txt` | Siete casos correctos sobre las tablas reales del DDL integrado. |
| `esquema.txt` | Versión de PostgreSQL, inventario de restricciones y comprobación final de tablas vacías. |

Los comandos usaron `psql -X -v ON_ERROR_STOP=1`; cada ejecución terminó sin
errores inesperados. Los fallos esperados se capturaron y comprobaron dentro
de las propias pruebas. Se verificó el ROLLBACK de los datos de prueba.

El ensamblador produjo el mismo SQL al regenerarlo y rechazó el modo final
porque falta el módulo 02. Sus tres FK aplazadas están identificadas en el
archivo correspondiente; la integración completa aún no está validada.

Los dos PDF se compilaron sin `Overfull` y se revisaron las 18 páginas del
informe y la página del README renderizadas a PNG. Los dos diagramas se
conservaron como imágenes y editables. Esta carpeta contiene evidencias de
DDL y pruebas; **no acredita restauración**.
