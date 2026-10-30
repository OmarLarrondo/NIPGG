## 1. Cardinalidad de las consultas

Las relaciones iniciales son:

$R(A,B)=\{(1,x),(2,y),(2,z),(3,x),(9,a)\}$

$S(B,C,D)=\{(x,0,3),(y,2,1),(y,3,3),(w,3,0),(y,4,2)\}$.

Se usa semántica de conjuntos. En estas juntas condicionales se evalúa exclusivamente el predicado escrito; no se añade $R.B=S.B$. Para distinguir los atributos homónimos, se conservan $R.B$ y $S.B$.

### C07. $\pi B(R)-\pi B(\sigma C \geq 3(S))$

Para encontrar la cardinalidad final de esta consulta, primero analizaremos el resultado de cada parte de ella:

- Comenzamos leyendo la consulta en lenguaje natural: estamos tratando de encontrar los valores en las columnas (proyección) de B en la relación R que NO satisfacen la siguiente condición al ser un "Menos". La condición a no satisfacer son los valores de la columna de B en S cuyos renglones en C sean mayores o iguales a 3.
- Entonces, comenzando por encontrar dichos valores en C mayores o iguales a 3, vemos que lo cumplen tres tuplas: $y=3, w=3$ y $y=4$.
- Así, la proyección de B que cumple la condición es $B=\{w,y\}$.
- Entonces, el resultado completo de $\pi B(R)-\pi B(\sigma C \geq 3(S))$, es $\{x,z,a\}$, recordando que, aunque x aparece dos veces, la proyección no devuelve valores repetidos.

  | A.R | B.R |
  |-----|-----|
  | 1 | x |
  | 2 | z |
  | 3 | x |
  | 9 | a |

**Cardinalidad: 3 tuplas.** No hay tuplas duplicadas en el resultado.

### C09. $\pi D(S) \bowtie R$

Análisis de la consulta:

- En lenguaje natural queremos tomar todos los valores del atributo D en S y combinarlos con cada tupla en R.
- Como la relación R tiene 5 finas y la relación S tiene 4 distintos valores en la columna D (proyección de D en S), el resultado del join obtendrá $4*5$ tuplas en total:

  | D | A | B |
  |---|---|---|
  | 3 | 1 | 'x' |
  | 3 | 2 | 'y' |
  | 3 | 2 | 'z' |
  | 3 | 3 | 'x' |
  | 3 | 9 | 'a' |
  | 1 | 1 | 'x' |
  | 1 | 2 | 'y' |
  | 1 | 2 | 'z' |
  | 1 | 3 | 'x' |
  | 1 | 9 | 'a' |
  | 2 | 1 | 'x' |
  | 2 | 2 | 'y' |
  | 2 | 2 | 'z' |
  | 2 | 3 | 'x' |
  | 2 | 9 | 'a' |
  | 0 | 1 | 'x' |
  | 0 | 2 | 'y' |
  | 0 | 2 | 'z' |
  | 0 | 3 | 'x' |
  | 0 | 9 | 'a' |

**Cardinalidad: 20 tuplas.** No hay tuplas duplicadas en el resultado.