# Tarea 04 — Propuesta de estructura modular

Fuente: `Tarea04_AlgebraRelacional.pdf`, páginas 1–2. Aunque se mencionó “práctica 04”, esta estructura corresponde a la **Tarea 4 de Álgebra Relacional** adjunta.

Estado: estructura inicial creada; reparto y responsables confirmados y ejercicios sin resolver.

## Reparto técnico entre cinco integrantes

Se numeran C01–C10 las diez filas de cardinalidad en el orden del PDF. Q_a–Q_j son las consultas del ejercicio 2 y M_a–M_e sus operaciones de mantenimiento; las letras de ambas secciones son independientes.

| Módulo | Cardinalidad | Consultas | Mantenimiento | Motivo del balance |
| --- | --- | --- | --- | --- |
| 01 / Diego | C08, C10 | Q_c, Q_j | M_d | Filtros de varias tablas y máximo de órdenes, más agrupación con junta externa; actualización sencilla. |
| 02 / Omar | C02, C05 | Q_a, Q_i | M_a | Dos juntas condicionales, filtros y ordenación, mínimo de órdenes y alcance del borrado de un cliente. |
| 03 / Miguel | C03, C04 | Q_b, Q_f | M_e | Juntas externas, productos sin órdenes y clientes con umbral de productos; dos reglas de actualización. |
| 04 / Yahir | C01, C06 | Q_d, Q_h | M_b | Producto cartesiano y renombrado, consulta sencilla y agregación de ventas exigente; borrado con varias relaciones. |
| 05 / Ana | C07, C09 | Q_e, Q_g | M_c | Cardinalidades más ligeras para compensar clientes sin órdenes, máximo de productos vendidos e inserción por subcategoría. |

Todos tienen dos expresiones de cardinalidad, dos consultas y una operación de mantenimiento. La dificultad no es idéntica por inciso: el balance considera juntas, ausencia de coincidencias, agrupaciones, extremos, interpretación y construcción de tuplas. Es una estimación previa a ejecutar las consultas, no una medición de horas.

Cada integrante resuelve, explica y comprueba sus propios ejercicios, incluidas sus capturas. La integración, portada, README general, empaquetado y entrega quedan a cargo de Omar y no cuentan como carga asignada a ninguno de los cinco módulos. Omar tiene asignado el módulo 02, además de las tareas de integración que conserva.

## Carpetas creadas

```text
Tarea04/
├── Tarea04_AlgebraRelacional.pdf
├── ESTRUCTURA_MODULAR.md
└── modulos/
    ├── 01_diego/
    ├── 02_omar/
    ├── 03_miguel/
    ├── 04_yahir/
    └── 05_ana/
```

Cada módulo contiene:

```text
cardinalidad.md       # Expresiones, derivación, tablas completas y cardinalidades.
consultas.md          # Interpretación, álgebra, expresión Relax y resultados propios.
mantenimiento.md     # Álgebra con asignación, tuplas afectadas y comprobación propia.
evidencias/          # Capturas del módulo; inicialmente solo contiene .gitkeep.
```

Al resolver, añadir junto a `consultas.md` un archivo `consulta_<letra>.relax` por consulta con el texto realmente ejecutado. Las plantillas Markdown separan el contenido del formato del reporte final; no presuponen que la entrega sea Markdown. No se incluyen scripts de integración ni un documento maestro.

## Acuerdo mínimo para trabajar en paralelo

- Usar el dataset original con ID `31074567738afef8c497f6ca89335782`, indicado en el PDF. El dataset todavía no se descargó ni verificó; los nombres de atributos se deben confirmar al cargarlo.
- Cada consulta y operación de mantenimiento parte del dataset original. No encadenar las modificaciones de distintos integrantes.
- Conservar las etiquetas C, Q y M. Cada integrante edita su carpeta y guarda sus propias evidencias allí.
- Usar la notación vista en clase en la explicación y conservar también la expresión exacta que se ejecutó en Relax.
- Cardinalidad: entregar la tabla completa de cada resultado y su número de tuplas. En consultas: expresión, captura del resultado y árbol cuando sea legible; explicar resultados vacíos, como pide el PDF.

## Criterios por aclarar antes de resolver los incisos afectados

Estos puntos deben quedar explícitos en la interpretación de cada solución; no se impone aquí una respuesta sin revisar el dataset y la notación de clase.

1. **Órdenes y productos (Q_f, Q_g, Q_h, Q_i, Q_j):** distinguir órdenes diferentes por OrderID, renglones, productos distintos y suma de Quantity. En Q_f aclarar si “al menos 6 productos” se evalúa por orden y si significa unidades o productos distintos.
2. **Ventas (Q_h):** el esquema muestra Price y Quantity, pero no un atributo de venta. Acordar la derivación del importe y si promedio/máximo/mínimo se calculan por orden o por renglón antes de agrupar por ubicación.
3. **Extremos (Q_g, Q_i, Q_j):** definir cómo se conservan los empates. Para Q_i, aclarar también qué significa “órdenes que haya entregado” y si se incluyen estados sin órdenes.
4. **Ubicación (M_b):** el enunciado dice “ciudad Utah”. Verificar los datos y confirmar la interpretación; no sustituir City por State silenciosamente. Precisar además si se eliminan órdenes completas o solo los renglones con Tables.
5. **Borrado del cliente (M_a):** precisar qué relaciones abarca “toda la información” y cómo se evitan órdenes que referencien al cliente borrado.
6. **Salida y ordenación (Q_a):** aclarar qué cantidad se muestra y qué hacer si un cliente tiene varias órdenes o renglones; conservar lo necesario para justificar la ordenación.
7. **Inserción (M_c):** confirmar las subcategorías reales de Furniture y completar los atributos de Orders, no solo elegir ProductID.
8. **Cardinalidad:** documentar semántica de conjuntos, atributos compartidos en juntas naturales y comportamiento de nulos/COUNT en C10.

El PDF sigue siendo la fuente de los enunciados completos; los objetivos de las plantillas son resúmenes para orientar el trabajo.
