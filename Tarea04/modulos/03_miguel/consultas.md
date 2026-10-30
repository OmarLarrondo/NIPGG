# Consultas — Miguel

Se usa el dataset original `31074567738afef8c497f6ca89335782`, guardado en [`datos/BDVentas.txt`](datos/BDVentas.txt). Contiene 793 tuplas en `customer`, 5999 en `orders` y 1862 en `products`. El archivo de origen incluye 6000 renglones de `orders`, pero uno está repetido exactamente y Relax aplica semántica de conjuntos. Los atributos reales están en minúsculas.

## Q_b — Productos de Technology entre $400 y $850 que no se solicitaron

El filtro de precio es estricto: `price > 400` y `price < 850`. Se considera solicitado un producto cuyo `productid` figure al menos una vez en `orders`. Se conservan los cuatro atributos de `products`.

**Álgebra:**

T = σ_{category='Technology' ∧ price>400 ∧ price<850}(products)

P = π_{productid}(orders)

Resultado = π_{productid→id,category→categoria,subcategory→tipo,price→precio}(T − (T ⋈ P))

La diferencia resta los candidatos cuyo identificador aparece en una orden; la junta natural mantiene el esquema de T. La proyección final acorta los encabezados para que las cuatro columnas se vean completas en Relax.

**Expresión ejecutada:** [`consulta_b.relax`](consulta_b.relax).

```text
Candidatos = sigma category = 'Technology' and price > 400 and price < 850 (products)
Solicitados = pi productid (orders)
pi productid -> id, category -> categoria, subcategory -> tipo, price -> precio (Candidatos - (Candidatos join Solicitados))
```

**Resultado:** 2 productos. Relax encuentra 28 candidatos en el intervalo y 26 solicitados.

| id | categoria | tipo | precio |
| --- | --- | --- | ---: |
| TEC-PH-10004080 | Technology | Phones | 487.98 |
| TEC-MA-10004086 | Technology | Machines | 659.98 |

No es vacío. Resultado completo: [`datos/consulta_b_resultado.csv`](datos/consulta_b_resultado.csv). [Captura del resultado con las cuatro columnas](evidencias/consulta_b_resultado.png).

## Q_f — Clientes con órdenes de al menos 6 productos en 2016 o 2017

Interpreto «al menos 6 productos» **por orden** como seis `productid` distintos, no seis unidades de `quantity`. Primero proyecto `(orderid, productid)` para contar cada producto una sola vez. El periodo se aplica a `orderdate`, desde 2016-01-01 inclusive hasta 2018-01-01 exclusive. Cada cliente se cuenta una vez por región y estado aunque tenga varias órdenes elegibles. La ubicación viene de `customer`.

**Álgebra:**

P = σ_{orderdate≥2016-01-01 ∧ orderdate<2018-01-01}(orders)

D = π_{orderid,productid}(P)

N = γ_{orderid; COUNT(productid)→total_productos}(D)

O = π_{orderid}(σ_{total_productos≥6}(N))

C = π_{region,state,customerid}(customer ⋈ orders ⋈ O)

Resultado = τ_{region ASC,state ASC}(γ_{region,state; COUNT(customerid)→total_clientes}(C))

La proyección C elimina repeticiones del mismo cliente antes de agrupar. τ indica ordenación, extensión del álgebra relacional clásica.

**Expresión ejecutada:** [`consulta_f.relax`](consulta_f.relax).

```text
Periodo = sigma orderdate >= date('2016-01-01') and orderdate < date('2018-01-01') (orders)
ProductosPorOrden = pi orderid, productid (Periodo)
Conteo = gamma orderid; count(productid) -> total_productos (ProductosPorOrden)
OrdenesElegibles = pi orderid (sigma total_productos >= 6 (Conteo))
ClientesElegibles = pi region, state, customerid (customer join orders join OrdenesElegibles)
tau region asc, state asc (gamma region, state; count(customerid) -> total_clientes (ClientesElegibles))
```

**Resultado:** 49 órdenes elegibles, 46 clientes distintos y 20 grupos; no es vacío.

| region | state | total_clientes |
| --- | --- | ---: |
| Central | Illinois | 2 |
| Central | Indiana | 1 |
| Central | Iowa | 1 |
| Central | Michigan | 1 |
| Central | Texas | 2 |
| Central | Wisconsin | 1 |
| East | Massachusetts | 1 |
| East | New Hampshire | 2 |
| East | New York | 9 |
| East | Ohio | 1 |
| East | Pennsylvania | 4 |
| South | Florida | 1 |
| South | Georgia | 2 |
| South | Kentucky | 1 |
| South | North Carolina | 1 |
| South | Tennessee | 1 |
| West | Arizona | 3 |
| West | California | 9 |
| West | Colorado | 1 |
| West | Washington | 2 |

Resultado completo: [`datos/consulta_f_resultado.csv`](datos/consulta_f_resultado.csv). Capturas con encabezados y las 20 filas: [página 1](evidencias/consulta_f_resultado_p1.png) y [página 2](evidencias/consulta_f_resultado_p2.png).
