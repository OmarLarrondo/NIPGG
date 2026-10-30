# Mantenimiento — Ana


## M_c — Mantenimiento c

**Objetivo:** Registrar la compra de Lena Cacioppo de un producto de cada subcategoría de Furniture; elegir los productos e indicar toda la información que se agregará en cada caso.

### Interpretación y relaciones afectadas

Esta operación consiste en insertar la orden de los productos que compró la cliente Lena Cacioppo, las cuales son
una por cada subcategoría de Funiture. Para hacer la inserción de cada uno de estos productos es necesario conocer la información de los mismos, es decir, las subcategorías existentes en Furniture y el id de cada uno de los productos de estas subcategorías.

### Expresión en álgebra relacional con asignación

En este caso, como no podemos modificar directamente la base de datos, crearemos una relación temporal (`orders1`) que será igual a la relación `orders` original unida con las tuplas que se desean insertar.

**1. Localizar a la clienta.** Primero obtenemos el `customerid` de Lena Cacioppo: seleccionamos en `customer` la tupla cuyo `customername` sea el requerido y proyectamos únicamente el atributo `customerid`.

\[
Lena = \pi_{customerid}\Big(\sigma_{customername='Lena\ Cacioppo'}(customer)\Big)
\]

**2. Elegir los productos.** Se eligió un producto de cada subcategoría de Furniture: Bookcases (`FUR-BO-10001798`), Chairs (`FUR-CH-10000454`), Tables (`FUR-TA-10000577`) y Furnishings (`FUR-FU-10001487`). Se seleccionan en `products` mediante una disyunción de condiciones y se proyecta el `productid`, de modo que `Prods` contiene 4 tuplas.

\[
Prods = \pi_{productid}\Big(\sigma_{productid='FUR\text{-}BO\text{-}10001798' \lor productid='FUR\text{-}CH\text{-}10000454' \lor productid='FUR\text{-}TA\text{-}10000577' \lor productid='FUR\text{-}FU\text{-}10001487'}(products)\Big)
\]

**3. Definir la información de la orden.** Los datos que no existen en la base de datos se definen como una relación en línea con una sola tupla. Esta información es común a los cuatro productos, ya que pertenecen a la misma orden, y se asigna una cantidad de 1 por producto.

\[
Info = \{(\text{'CA-2026-900001'},\ 2026\text{-}10\text{-}29,\ 2026\text{-}11\text{-}02,\ \text{'Standard Class'},\ 1)\}
\]

\[
\text{con esquema } (orderid,\ orderdate,\ shipdate,\ shipmode,\ quantity)
\]

**4. Construir las tuplas nuevas.** El producto cartesiano $Lena \times Prods \times Info$ combina 1 cliente, 4 productos y 1 conjunto de datos de la orden, por lo que genera $1 \times 4 \times 1 = 4$ tuplas, una por cada producto comprado. Después se reordenan los atributos con una proyección para que coincidan con el esquema de `orders`, requisito indispensable para poder aplicar la unión.

**5. Insertar mediante la unión.** Finalmente, la relación temporal `orders1` es la unión de `orders` con las tuplas nuevas.

\[
orders1 = orders \cup \pi_{orderid,\ orderdate,\ shipdate,\ shipmode,\ customerid,\ productid,\ quantity}\big(Lena \times Prods \times Info\big)
\]

**6. Consulta final.** La expresión que se ejecuta para obtener el resultado es:

\[
orders1
\]

**Verificación.** La relación `orders1` debe tener 4 tuplas más que `orders`. Las tuplas insertadas se pueden consultar con:

\[
\sigma_{orderid='CA-2026-900001'}(orders1)
\]

## Expresión ejecutable en relax
Lena = π customerid (σ customername = 'Lena Cacioppo' (customer))

Prods = π productid (σ productid = 'FUR-BO-10001798' or productid = 'FUR-CH-10000454' or productid = 'FUR-TA-10000577' or productid = 'FUR-FU-10001487' (products))

Info = {
orderid:string, orderdate:date, shipdate:date, shipmode:string, quantity:number
'CA-2026-900001', 2026-10-29, 2026-11-02, 'Standard Class', 1
}

orders1 = orders union π orderid, orderdate, shipdate, shipmode, customerid, productid, quantity (Lena x Prods x Info)

orders1

### Datos y comprobación

- Tuplas afectadas o insertadas y atributos necesarios: pendiente.
- Estado previo relevante: pendiente.
- Estado posterior esperado y justificación: pendiente.
- Comprobación realizada y limitaciones de la herramienta: pendiente.

El resultado de la consulta para obtener el customerid de Lena Cacioppo se puede ver en `evidencias/mantenimento_Elena_c.csv` y su árbol en `evidencias/mantenimento_Elena_c.jpg`

El resultado de la consulta para obtener los subproductos cuya categoría es Furniture se puede ver en `evidencias/furnitures_c.csv` y su árbol se encuentra en `evidencias/furnitures_c.jpg`

Los productos afectados por los cambios se pueden ver en `evidencia/mantenimiento_c_resultados.csv` y el árbol se puede ver en `evidencias/mantenimento_c_arbol.png`


Los valores nuevos son: 

### Valores nuevos insertados en `orders`

Se agregan 4 tuplas a `orders` (una por producto), todas pertenecientes a la misma orden de la clienta Lena Cacioppo. Los atributos siguen el orden del esquema de `orders`.

| orderid | orderdate | shipdate | shipmode | customerid | productid | quantity |
|---|---|---|---|---|---|---|
| CA-2026-900001 | 2026-10-29 | 2026-11-02 | Standard Class | LC-16885 | FUR-BO-10001798 | 1 |
| CA-2026-900001 | 2026-10-29 | 2026-11-02 | Standard Class | LC-16885 | FUR-CH-10000454 | 1 |
| CA-2026-900001 | 2026-10-29 | 2026-11-02 | Standard Class | LC-16885 | FUR-FU-10001487 | 1 |
| CA-2026-900001 | 2026-10-29 | 2026-11-02 | Standard Class | LC-16885 | FUR-TA-10000577 | 1 |

### Subcategoría de cada producto

| productid | category | subcategory |
|---|---|---|
| FUR-BO-10001798 | Furniture | Bookcases |
| FUR-CH-10000454 | Furniture | Chairs |
| FUR-FU-10001487 | Furniture | Furnishings |
| FUR-TA-10000577 | Furniture | Tables |

### Origen de cada valor

| Atributo | Origen |
|---|---|
| customerid | Se obtiene de `customer` con la relación `Lena` |
| productid | Se obtiene de `products` con la relación `Prods` |
| orderid, orderdate, shipdate, shipmode, quantity | Se definen en la relación en línea `Info` |

> Nota: el `customerid` mostrado (`LC-16885`) es el valor típico del dataset Superstore. En tu base, el valor real es el que devuelve la relación `Lena`; sustitúyelo en la tabla si es distinto.