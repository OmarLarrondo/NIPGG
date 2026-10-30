# Cardinalidad — Miguel

Se usa semántica de conjuntos. C03 y C04 son juntas externas **naturales**: el atributo compartido `B` determina la coincidencia y aparece una sola vez en el resultado.

R(A,B) = {(1,x), (2,y), (2,z), (3,x), (9,a)}

S(B,C,D) = {(x,0,3), (y,2,1), (y,3,3), (w,3,0), (y,4,2)}

La junta natural interna contiene 5 tuplas: dos para `B=x` y tres para `B=y`. `R(2,z)` y `R(9,a)` no tienen pareja en S; `S(w,3,0)` no tiene pareja en R. `null` representa un atributo faltante.

## C03 — R ⟕ S, junta externa izquierda

R ⟕ S = (R ⋈ S) ∪ {(2,z,null,null), (9,a,null,null)}.

| A | B | C | D |
| ---: | :---: | ---: | ---: |
| 1 | x | 0 | 3 |
| 2 | y | 2 | 1 |
| 2 | y | 3 | 3 |
| 2 | y | 4 | 2 |
| 2 | z | null | null |
| 3 | x | 0 | 3 |
| 9 | a | null | null |

**Cardinalidad: 7 tuplas** (5 coincidencias + 2 tuplas de R sin pareja). `R(2,y)` aparece tres veces porque coincide con tres tuplas diferentes de S; los resultados tienen distintos C o D, así que no son duplicados.

Expresión: [`cardinalidad_c03.relax`](cardinalidad_c03.relax). Evidencias: [árbol](evidencias/cardinalidad_c03_arbol.png) y [resultado](evidencias/cardinalidad_c03_resultado.png).

## C04 — R ⟖ S, junta externa derecha

R ⟖ S = (R ⋈ S) ∪ {(null,w,3,0)}.

| A | B | C | D |
| ---: | :---: | ---: | ---: |
| 1 | x | 0 | 3 |
| 3 | x | 0 | 3 |
| 2 | y | 2 | 1 |
| 2 | y | 3 | 3 |
| null | w | 3 | 0 |
| 2 | y | 4 | 2 |

**Cardinalidad: 6 tuplas** (5 coincidencias + 1 tupla de S sin pareja). Las tuplas `R(2,z)` y `R(9,a)` se excluyen porque la junta derecha conserva las de S. No hay duplicados.

Expresión: [`cardinalidad_c04.relax`](cardinalidad_c04.relax). Evidencias: [árbol](evidencias/cardinalidad_c04_arbol.png) y [resultado](evidencias/cardinalidad_c04_resultado.png).
