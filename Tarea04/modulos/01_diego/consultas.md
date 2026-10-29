# Consultas — Diego

## Q_c — Consulta 2.c

**Objetivo:** Nombres de clientes de South que solicitaron Bookcases, Chairs, Appliances o Copiers, en el primer o tercer trimestre de 2015, con envío Standard Class.

### Interpretación

Se relacionan las tablas Customer, Orders y Products mediante sus atributos correspondientes.

Se seleccionan los clientes cuya región sea South, cuyos productos pertenezcan a alguna de las cuatro subcategorías indicadas, cuya orden se haya realizado durante el primer o tercer trimestre de 2015 y cuyo modo de envío sea Standard Class.

Finalmente, se proyecta únicamente el nombre del cliente. Como el resultado es una relación, los nombres repetidos se eliminan.

Para los trimestres se consideran los siguientes intervalos:

Primer trimestre: desde el 1 de enero de 2015 hasta antes del 1 de abril de 2015.

Tercer trimestre: desde el 1 de julio de 2015 hasta antes del 1 de octubre de 2015.

### Expresión en notación de clase

$$
\begin{aligned}
C = \pi_{customername}\Big(
\sigma_{\text{region='South' } \land \text{ shipmode='Standard Class' } \land 
(\text{subcategory='Bookcases' } \lor \text{ subcategory='Chairs' } \lor \text{ subcategory='Appliances' } \lor \text{ subcategory='Copiers'}) \land 
((\text{orderdate} \geq date('2015-01-01') \land \text{orderdate} < date('2015-04-01')) \lor (\text{orderdate} \geq date('2015-07-01') \land \text{orderdate} < date('2015-10-01')))}
(customer \bowtie orders \bowtie products)
\Big)
\end{aligned}
$$



### Expresión ejecutable en Relax

π customername ( σ region = 'South' ∧ shipmode = 'Standard Class' ∧ (subcategory = 'Bookcases' ∨ subcategory = 'Chairs' ∨ subcategory = 'Appliances' ∨ subcategory = 'Copiers') ∧ ((orderdate >= date('2015-01-01') ∧ orderdate < date('2015-04-01')) ∨ (orderdate >= date('2015-07-01') ∧ orderdate < date('2015-10-01'))) (customer ⋈ orders ⋈ products) )

### Resultado

Se obtuvo 10 nombres de clientes que cumpliero con la consulta, Resultado completo en `datos/consulta_c_resultado.csv`; capturas en `evidencias/consulta_c_resultado.png` y `evidencias/consulta_c_arbol.png`.



## Q_j — Consulta 2.j

**Objetivo:** Información del cliente que más órdenes haya efectuado y número de órdenes realizadas.

### Interpretación
Primero se obtiene una relación con los identificadores de cliente y orden, eliminando los renglones repetidos para que cada orden se cuente una sola vez por cliente.

Después se agrupan las órdenes por cliente y se calcula el número de órdenes realizadas por cada uno.

Finalmente, se obtiene el máximo número de órdenes y se seleccionan los clientes que alcanzaron ese máximo. Se relaciona el resultado con Customer para recuperar toda la información del cliente.

Si existe un empate, se mostrarán todos los clientes que hayan realizado el máximo número de órdenes.

### Expresión en notación de clase

$$ O = \pi_{customerid,Orderid}(orders) $$

$$ N = \gamma_{customerID;\ \text{count}(orderid)\rightarrow \text{numorders}}(O) $$

$$ M = \gamma_{text{max}(\text{numorders})\rightarrow \text{maxorders}}(N) $$

$$ T = \sigma_{\text{numorders}=\text{maxorders}}(N \times M) $$

$$ J = \pi_{customer.*,\text{numorders}}(customer \bowtie T) $$

### Expresión ejecutable en Relax
La consulta se construye en los siguientes pasos:

O = π customerid, orderid (orders)

N = γ customerid; count(orderid) → numorders (O)

M = γ max(numorders) → maxorders (N)

T = σ numorders = maxorders (N ⨯ M)

J = π customer.*, numorders (customer ⨝ T)

J

### Resultado

No hubo ningun empate por lo que solo se obtuvo un solo cliente con la cantidad mayor de órdenes, Resultado completo en `datos/consulta_j_resultado.csv`; capturas en `evidencias/consulta_j_resultado.png` y `evidencias/consulta_j_arbol.png.`
