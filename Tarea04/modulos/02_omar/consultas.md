# Consultas — Omar Larrondo

Dataset original: `31074567738afef8c497f6ca89335782`, archivo `datos/BDVentas.txt`. Contiene 793 tuplas en customer, 5999 en orders y 1862 en products. Los identificadores reales están en minúsculas. El archivo contiene 6000 renglones de orders, pero uno está repetido exactamente: bajo semántica de conjuntos quedan 5999 tuplas.

## Q_a — Clientes de New York o Washington, segmento Consumer, tercer trimestre de 2016

Interpreto New York y Washington como estados (`state`). El trimestre se aplica a `orderdate`: desde 2016-07-01 inclusive hasta 2016-10-01 exclusive. La cantidad es `quantity` de cada renglón de pedido; se ordena de menor a mayor. Conservo todos los atributos del cliente y los de la orden para identificar la cantidad de cada renglón. Un cliente puede aparecer varias veces.

**Álgebra:**

J = customer ⋈ orders (junta natural por customerid).

F = σ_{(state='New York' ∨ state='Washington') ∧ segment='Consumer' ∧ orderdate≥2016-07-01 ∧ orderdate<2016-10-01}(J).

Resultado = τ_{quantity ASC}(F).

τ es la extensión de ordenación; el álgebra relacional clásica no define un orden entre tuplas.

**Expresión ejecutada:**

```text
tau quantity asc (sigma (state = 'New York' or state = 'Washington') and segment = 'Consumer' and orderdate >= date('2016-07-01') and orderdate < date('2016-10-01') (customer join orders))
```

**Resultado:** 34 renglones de 15 órdenes distintas, correspondientes a 13 clientes. No es vacío. Resultado completo en `datos/consulta_a_resultado.csv`; capturas en `evidencias/consulta_a_resultado.png` y `evidencias/consulta_a_arbol.png`.

## Q_i — Estado con menor número de órdenes

Cuento órdenes distintas por `(state, orderid)`, no renglones ni unidades. El estado corresponde al domicilio registrado del cliente, que es la ubicación disponible en el esquema. Considero los estados presentes en customer; todos tienen órdenes en este dataset. “Entregado” se interpreta con `shipdate` registrado, pues no hay un atributo de confirmación de entrega. Todas las órdenes del conjunto tienen shipdate. No es posible probar su entrega física con este esquema. Conservo todos los empates.

**Álgebra:**

E = π_{state, orderid}(customer ⋈ orders).

N = γ_{state; COUNT(orderid) → total_ordenes}(E).

M = γ_{MIN(total_ordenes) → minimo}(N).

Resultado = π_{state,total_ordenes}(σ_{total_ordenes=minimo}(N × M)).

**Expresión ejecutada:**

```text
PorEstado = gamma state; count(orderid) -> total_ordenes (pi state, orderid (customer join orders))
Minimo = gamma min(total_ordenes) -> minimo (PorEstado)
pi state, total_ordenes (sigma total_ordenes = minimo (PorEstado cross join Minimo))
```

**Resultado:**

| state | total_ordenes |
| --- | --- |
| District of Columbia | 2 |

Hay 41 estados/ubicaciones con órdenes. El siguiente mínimo es Arkansas con 5; no hay empate en el mínimo. District of Columbia es el nombre de la ubicación en el atributo state, aunque geográficamente sea un distrito federal. Capturas en `evidencias/consulta_i_resultado.png` y `evidencias/consulta_i_arbol.png`.
