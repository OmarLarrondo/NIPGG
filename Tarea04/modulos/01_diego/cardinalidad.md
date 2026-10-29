# Cardinalidad — Diego

Se usa semántica de conjuntos. Las proyecciones eliminan las tuplas duplicadas. En la Join externo completo, las tuplas que no encuentran coincidencia se conservan y los atributos faltantes se rellenan con `NULL`.

## C08 — π_A(R) ∩ ρ_{A ← D}(π_D(S))

Primero se proyecta el atributo A de R:

$$ \pi_A(R) = \{1, 2, 3, 9\} $$

Aunque R contiene dos tuplas con A=2, la proyección elimina el duplicado.

Después se proyecta D de S:

$$ \pi_D(S) = \{3, 1, 0, 2\} $$

El valor 3 aparece dos veces en S, pero se conserva una sola vez por la semántica de conjuntos.

Se renombra el atributo D a A:

$$ \rho_{A \leftarrow D}(\pi_D(S)) = \{3, 1, 0, 2\} $$

Finalmente, se calcula la intersección de las dos relaciones:

$$ \{1, 2, 3, 9\} \cap \{3, 1, 0, 2\} = \{1, 2, 3\} $$


| A |
| --- |
| 1 |
| 2 |
| 3 |

**Cardinalidad: 3.** Los valores comunes a las dos relaciones son 1, 2 y 3. El valor 9 no pertenece a la segunda relación, mientras que el 0 no pertenece a la primera.

## C10 — γ_{A; count(B) → t}(R ⟗ S)

La Join externo completo conserva todas las tuplas de R y S. Como ambas relaciones comparten el atributo B, se utiliza ese atributo para determinar las coincidencias, combinando sus valores en una sola columna B.

Las coincidencias son las siguientes:

- La tupla (1, x) de R coincide con (x, 0, 3) de S.
- La tupla (2, y) de R coincide con las tres tuplas de S cuyo valor de B es y.
- La tupla (3, x) de R coincide con (x, 0, 3) de S.

También se conservan las tuplas de R que no tienen coincidencia: (2, z) y (9, α). Finalmente, se conserva la tupla (w, 3, 0) de S, que no tiene coincidencia en R.

### Resultado del Join externo completo

| A | B | C | D |
| --- | --- | --- | --- |
| 1 | x | 0 | 3 |
| 2 | y | 2 | 1 |
| 2 | y | 3 | 3 |
| 2 | y | 4 | 2 |
| 3 | x | 0 | 3 |
| 2 | z | NULL | NULL |
| 9 | α | NULL | NULL |
| NULL | w | 3 | 0 |

**Cardinalidad de la Join externo: 8.** Se obtienen cinco tuplas por coincidencias y tres tuplas sin coincidencia que se conservan mediante la Join externo completo.

### Agrupación y conteo

Se agrupa el resultado por A y se cuenta el número de valores de B de cada grupo. Como B tiene un valor en las ocho tuplas, cada una contribuye al conteo de su grupo.

| A | t = count(B) |
| --- | --- |
| 1 | 1 |
| 2 | 4 |
| 3 | 1 |
| 9 | 1 |
| NULL | 1 |

**Cardinalidad: 5.** Se obtiene una tupla por cada grupo distinto de A. Los grupos son 1, 2, 3, 9 y NULL.

El grupo A=2 contiene cuatro tuplas: tres provenientes de las coincidencias de B=y y una correspondiente a la tupla sin coincidencia (2, z). El grupo A=NULL corresponde a la tupla de S con B=w, que no encontró coincidencia en R.

Para comprobar que las tablas resultantes fueran correctas, se usaron las expreciones de `cardinalida_c08.relax` y `cardinalida_c10.relax` se ejecutaron en Relax y se obtubo los resultado se la imagenes en evidencias: `evidencias/cardinalida_c08_arbol.png`, `evidencias/cardinalidad_c08_resultado.png`, `evidencias/cardinalidad_c10_arbolJoinExterno.png`, `evidencias/cardinalidad_c10_resultadoJoinExterno.png`, `evidencias/cardinalidad_c10_arbol.png`, `evidencias/caridinalidad_c10_resultado.png`.
