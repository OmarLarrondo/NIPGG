# Mantenimiento — Diego

Estado: pendiente.

## M_d — Mantenimiento d

**Objetivo:** Aumentar los precios de productos de Phones en un 8%.

### Interpretación y relaciones afectadas

La operación consiste en actualizar el atributo Price de todos los productos cuya subcategoría sea Phones.

El nuevo precio se calcula multiplicando el precio actual por 1.08, lo que representa un incremento del 8%.

La única relación afectada es Products.

### Expresión en álgebra relacional con asignación

Primero, se obtiene la relación con los productos que pertenecen a la subcategoría Phones:

$$ P_{Phones} = \sigma_{\text{subcategory} = 'Phones'}(products) $$

Se actualiza el precio de cada producto seleccionado:

$$ P_{Actualizados} = \pi_{productid, \text{productname}, \text{category}, \text{subcategory}, \text{price} \times 1.08 \rightarrow \text{price}}(P_{Phones}) $$

Se obtiene la relación con los productos que no pertenecen a Phones:

$$ P_{Otros} = products - P_{Phones} $$

Finalmente, se reconstruye la relación Products con los productos que no se modificaron y los productos actualizados:

$$ productsupdated = P_{Otros} \cup P_{Actualizados} $$

### Expresión ejecutable en Relax

PP = σ subcategory = 'Phones' (products)

PA = π productid,category,subcategory,price*1.08→price (PP)

PO = products - PP

productsupdated = PO∪PA

productsupdated

### Datos y comprobación

Los productos afectados por los cambios se pueden ver en `datos/mantenimiento_d_afectadas.csv` y los productos ya actualizados se puedn ver en `datos/mantenimiento_d_productosActualizados.csv`

En cuanto al resultado final que es la tabla products actualizada con los productos con el aumento del precio en 8% y los otros porductos que no fueron autualizado, se pueden ver en `datos/mantenimiento_d_final.csv` y su resultado y arbol en `evidencias/mantenimento_d_resultado.png` y `evidencias/mantenimento_d_arbol.png`
