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

Pendiente: atributos de salida, filtros, unidad de conteo y supuestos que apliquen.

### Expresión en notación de clase

Pendiente.

### Expresión ejecutable en Relax

Pendiente. Guardar también la expresión exacta en `consulta_g.relax` al resolver.

### Verificación y evidencias

- Dataset: `31074567738afef8c497f6ca89335782`.
- Resultado y explicación breve: pendiente.
- Si el resultado está vacío, explicar por qué: pendiente/no aplica.
- Captura del resultado: `evidencias/consulta_g_resultado.png` (pendiente).
- Captura del árbol, si es legible: `evidencias/consulta_g_arbol.png` (pendiente).
