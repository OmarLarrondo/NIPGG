# Consultas — Ana

Estado: pendiente. Cada consulta se verifica de forma independiente en Relax con el dataset original.

## Q_e — Consulta 2.e

**Objetivo:** Estado, segmento y total de clientes que no han solicitado ninguna orden.

### Interpretación

Los clientes y las ordenes se relacionana mediante el id de los clientes. El estado y segmento es información
que se puede obtener de la tabla customer, por lo tanto, podemos agrupar y contar a los clientes totales menos
los clientes que no se encoentran en la tabla order, lo cual indica que aún no han hecho ninguna orden.
Para obtener el total de los clientes sin ordenes, debemos contar el número de clientes sin ordenes por cada
grupo.

### Expresión en notación de clase

$$
\begin{aligned}
C = \gamma_{State,\ Segment;\ count(CustomerID) \rightarrow total}\Big(
(\pi_{CustomerID}(Customer) - \pi_{CustomerID}(Orders)) \bowtie Customer
\Big)
\end{aligned}
$$

$$
\begin{aligned}
C = \gamma_{count(CustomerID) \rightarrow total}\Big(
\pi_{CustomerID}(Customer) - \pi_{CustomerID}(Orders)
\Big)
\end{aligned}
$$

### Expresión ejecutable en Relax

Consulta del estado, segmento y total de clientes por grupo que no han solicitado alguna orden:
γ state,segment; count(customerid)→total((π customerid (customer)-π customerid(orders)) ⨝ customer)

Consulta del total de clientes que no han hecho alguna orden:
gamma count(CustomerID) -> total (
  pi CustomerID (Customer) - pi CustomerID (Orders)
)

### Resultado

Se obtuvo una tabla con todos los estados, segmentos y el total de clientes en cada uno de estos grupos
que no cuentan con una orden. Al sumar los clientes por grupo sin ordenes, con la segunda consulta, 
obtenemos el total de clientes que no han hecho una orden lo cual es coompatible con el resultado de filas
que se obtiene al hacer el join de la primera consulta.


## Q_g — Consulta 2.g

**Objetivo:** Modo de envío y categoría que más productos ha vendido.

### Interpretación

El producto que más se ha vendido es aquel en el cual productid de Product se repite más veces en las ordenes.
De estas dos tablas, podemos obtener el número de ordenes por cada uno de los ids y obtener el máximo, además
podemos obtener la categoría del producto y el modo de envío de la orden.

### Expresión en notación de clase

$$
\begin{aligned}
T &= \gamma_{ShipMode,\ Category;\ count(ProductID) \rightarrow total}(Orders \bowtie Products) \\
M &= \gamma_{max(total) \rightarrow total}(T) \\
Resultado &= T \bowtie M
\end{aligned}
$$

### Expresión ejecutable en Relax

T = gamma ShipMode, Category; count(ProductID) -> total (Orders natural join Products)
M = gamma max(total) -> total (T)
T natural join M

Pendiente. Guardar también la expresión exacta en `consulta_g.relax` al resolver.

### Resultados

Se obtuvo una tabla con el modo de envío, cetegoría y número de productos ordenados del producto con mayor número de ventas-

- Dataset: `31074567738afef8c497f6ca89335782`.
- Resultado y explicación breve: pendiente.
- Si el resultado está vacío, explicar por qué: pendiente/no aplica.
- Captura del resultado: `evidencias/consulta_g_resultado.png` (pendiente).
- Captura del árbol, si es legible: `evidencias/consulta_g_arbol.png` (pendiente).
