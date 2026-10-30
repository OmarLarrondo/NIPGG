# Mantenimiento — Miguel

## M_e — Ajustar precios de Furniture y Technology/Machines

Se parte del dataset original. Tomo como inclusivos los límites «entre $600 y $900» para Furniture: `600 ≤ price ≤ 900`; el descuento es `price × 0.92`. Para Technology, subcategoría Machines, no se indica límite de precio, así que se actualizan **todas** sus tuplas con `price × 1.05`. Los grupos son disjuntos por categoría. No se modifican `orders` ni `customer`.

### Álgebra relacional con asignación

F ← σ_{category='Furniture' ∧ 600≤price≤900}(products)

M ← σ_{category='Technology' ∧ subcategory='Machines'}(products)

F' ← π_{productid,category,subcategory,price×0.92→price}(F)

M' ← π_{productid,category,subcategory,price×1.05→price}(M)

products ← (products − F − M) ∪ F' ∪ M'

Las selecciones parten del estado original. La proyección devuelve el mismo esquema de `products`, por lo que diferencias y uniones son compatibles. Relax calcula la relación resultante sin modificar el dataset.

### Tuplas afectadas

| Grupo | Variación | Tuplas |
| --- | --- | ---: |
| Furniture, precio de 600 a 900 | −8% | 13 |
| Technology / Machines | +5% | 63 |
| **Total** | | **76** |

Los **76 identificadores con precios antes y después** están en [`datos/mantenimiento_e_cambios.csv`](datos/mantenimiento_e_cambios.csv). Se conservan cuatro decimales exactos del cálculo porcentual; el enunciado no especifica redondeo a centavos. Relax muestra en algunas celdas residuos de precisión binaria, por ejemplo `568.2840000000001`; el CSV registra el valor decimal exacto `568.2840`. Ejemplos:

| productid | Grupo | Antes | Después |
| --- | --- | ---: | ---: |
| FUR-CH-10000454 | Furniture | 731.94 | 673.3848 |
| FUR-TA-10004289 | Furniture | 899.14 | 827.2088 |
| TEC-MA-10002937 | Machines | 1799.97 | 1889.9685 |
| TEC-MA-10004086 | Machines | 659.98 | 692.9790 |

### Comprobación

| Relación | Antes | Tuplas sustituidas | Después |
| --- | ---: | ---: | ---: |
| products | 1862 | 76 | 1862 |
| orders | 5999 | 0 | 5999 |
| customer | 793 | 0 | 793 |

Relax confirma 13 tuplas de Furniture, 63 de Machines y 1862 tuplas en la relación final: 1786 no afectadas + 13 nuevas de Furniture + 63 nuevas de Machines. Cada producto conserva `productid`, `category` y `subcategory`; solo cambia `price`. La comprobación independiente con los datos originales confirmó los 76 precios calculados.

Expresiones ejecutables: [`mantenimiento_e_final.relax`](mantenimiento_e_final.relax), [`mantenimiento_e_afectadas.relax`](mantenimiento_e_afectadas.relax), [`mantenimiento_e_resumen.relax`](mantenimiento_e_resumen.relax) y [`mantenimiento_e_comprobacion.relax`](mantenimiento_e_comprobacion.relax). La consulta de afectados usa encabezados cortos para mostrar las cuatro columnas completas; el CSV conserva además `subcategory` y los decimales normalizados. Capturas: [resumen por categoría](evidencias/mantenimiento_e_resumen.png), [precios afectados, página 1](evidencias/mantenimiento_e_afectadas_p1.png), [página 2](evidencias/mantenimiento_e_afectadas_p2.png) y [total final](evidencias/mantenimiento_e_total.png).
