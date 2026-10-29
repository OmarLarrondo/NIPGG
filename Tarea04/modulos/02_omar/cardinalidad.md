# Cardinalidad — Omar Larrondo

Se usa semántica de conjuntos. Las juntas son theta: se evalúa únicamente la condición escrita; no se agrega la igualdad entre R.B y S.B. Se conservan ambas columnas B, calificadas por su relación.

## C02 — R ⋈_{D > A} S

Equivale a σ_{D > A}(R × S). El producto tiene 5 × 5 = 25 tuplas.

| A | R.B | S.B | C | D |
| --- | --- | --- | --- | --- |
| 1 | x | x | 0 | 3 |
| 1 | x | y | 3 | 3 |
| 1 | x | y | 4 | 2 |
| 2 | y | x | 0 | 3 |
| 2 | y | y | 3 | 3 |
| 2 | z | x | 0 | 3 |
| 2 | z | y | 3 | 3 |

**Cardinalidad: 7.** No hay duplicados en el resultado.

## C05 — R ⋈_{A = D} S

Equivale a σ_{A = D}(R × S). El producto tiene 5 × 5 = 25 tuplas.

| A | R.B | S.B | C | D |
| --- | --- | --- | --- | --- |
| 1 | x | y | 2 | 1 |
| 2 | y | y | 4 | 2 |
| 2 | z | y | 4 | 2 |
| 3 | x | x | 0 | 3 |
| 3 | x | y | 3 | 3 |

**Cardinalidad: 5.** No hay duplicados en el resultado.

En C02, las filas de R con A=1,2,2,3,9 encuentran respectivamente 3,2,2,0,0 coincidencias: 7 en total. En C05 encuentran 1,1,1,2,0 coincidencias: 5 en total. Las dos filas con A=2 tienen distinto B y se conservan.

Las expresiones `cardinalidad_c02.relax` y `cardinalidad_c05.relax` se ejecutaron en Relax y confirmaron 7 y 5 tuplas. Se utilizan alias r y s para que Relax mantenga calificadas las dos columnas B.
