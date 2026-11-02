
# Investigación: SET DEFAULT

**Responsable:** Diego.
**Módulo:** Personal y administración.
**Equipo:** ÑIPGG.
**Práctica:** 06.

## Pregunta 2. Sintaxis SQL

En PostgreSQL, la política SET DEFAULT se establece mediante las cláusulas ON DELETE SET DEFAULT y ON UPDATE SET DEFAULT dentro de la definición de una llave foránea.

La sintaxis general es:

```sql
CREATE TABLE tabla_dependiente (
    id INTEGER PRIMARY KEY,
    id_referencia INTEGER DEFAULT 999,

    CONSTRAINT fk_referencia
        FOREIGN KEY (id_referencia)
        REFERENCES tabla_referenciada(id_referencia)
        ON DELETE SET DEFAULT
        ON UPDATE SET DEFAULT
);
```

ON DELETE SET DEFAULT indica que, cuando se elimina un registro de la tabla referenciada, las filas dependientes sustituyen el valor de su llave foránea por el valor DEFAULT de la columna correspondiente.

ON UPDATE SET DEFAULT indica que, cuando se modifica el valor de la llave referenciada, las filas dependientes sustituyen su llave foránea por el valor DEFAULT.

Es importante establecer previamente el valor predeterminado de la columna que funciona como llave foránea.

Asimismo, el valor predeterminado debe satisfacer las restricciones existentes. Cuando no es NULL, debe existir una fila correspondiente en la tabla referenciada. De lo contrario, la operación de eliminación o actualización será rechazada por PostgreSQL.

## Pregunta 3. Objeto y funcionamiento

El objetivo de SET DEFAULT es conservar los registros de las tablas dependientes cuando se elimina o modifica un registro al que hacen referencia, asignándoles un valor predeterminado en lugar de eliminar las filas dependientes o impedir directamente la operación.

Su funcionamiento consiste en modificar automáticamente las llaves foráneas de los registros afectados, sustituyendo sus valores originales por el valor DEFAULT declarado en la columna.

Esta política puede utilizarse en dos situaciones:

- Cuando se elimina un registro de la tabla referenciada, las llaves foráneas que apuntaban a él toman su valor predeterminado.
- Cuando se actualiza una llave primaria referenciada, las llaves foráneas correspondientes también toman su valor predeterminado, en lugar de adoptar el nuevo identificador.

Ejemplo:

```sql
CREATE TABLE sucursal_demo (
    idSucursal INTEGER PRIMARY KEY
);

INSERT INTO sucursal_demo VALUES (100), (200), (999);

CREATE TABLE empleado_demo (
    idEmpleado INTEGER PRIMARY KEY,
    idSucursal INTEGER NOT NULL DEFAULT 999,

    CONSTRAINT fk_empleado_sucursal
        FOREIGN KEY (idSucursal)
        REFERENCES sucursal_demo(idSucursal)
        ON DELETE SET DEFAULT
        ON UPDATE SET DEFAULT
);

INSERT INTO empleado_demo VALUES (1, 100), (2, 200);

-- El empleado 1 pasa a la sucursal predeterminada.
DELETE FROM sucursal_demo
WHERE idSucursal = 100;

-- El empleado 2 también pasa a la sucursal predeterminada.
UPDATE sucursal_demo
SET idSucursal = 201
WHERE idSucursal = 200;

SELECT * FROM empleado_demo;
```

En este ejemplo, la sucursal con identificador 999 representa una sucursal predeterminada. Cuando se elimina la sucursal 100 o se modifica el identificador de la sucursal 200, los empleados relacionados pasan automáticamente a la sucursal 999.

De esta manera, se conserva la información de los empleados sin dejar referencias que incumplan la integridad referencial.

Es importante considerar que la sucursal predeterminada debe existir previamente. Además, no se podrá eliminar mientras existan empleados que continúen haciendo referencia a ella, puesto que el valor DEFAULT seguiría apuntando a una fila inexistente.

## Pregunta 4. Ventajas y desventajas

### Ventajas

- Permite conservar los registros dependientes cuando se elimina o actualiza una llave primaria referenciada.
- Evita la eliminación automática de información de las tablas dependientes.
- Permite reasignar registros a una entidad predeterminada cuando la relación original deja de existir.
- Mantiene la integridad referencial siempre que el valor predeterminado sea válido.
- Evita tener que asignar NULL en columnas que no permiten valores nulos, siempre que se utilice un valor predeterminado válido.

### Desventajas

- Requiere establecer previamente valores predeterminados en las columnas que funcionan como llaves foráneas.
- El registro correspondiente al valor predeterminado debe existir en la tabla referenciada; de lo contrario, la operación falla.
- Puede provocar pérdida de información acerca de la relación original de un registro.
- Puede generar ambigüedad cuando muchos registros terminan asociados a una misma entidad predeterminada.
- No es apropiada para todas las relaciones, especialmente cuando la asignación original representa información que debe conservarse.
- Puede entrar en conflicto con otras restricciones, como NOT NULL, PRIMARY KEY, UNIQUE y CHECK, si el valor predeterminado no cumple sus condiciones.

## Compatibilidad con el esquema

En el esquema de Personal y administración hay ocho llaves foráneas.

Después de verificar sus columnas y restricciones, se determinó que SET DEFAULT no resulta apropiada para las relaciones actuales.

Las columnas CURP de los contactos son obligatorias y forman parte de sus llaves primarias. Por tanto, asignarles un gerente o cajero predeterminado podría alterar el propietario real de la información.

Por otra parte, las columnas idSucursal de Genrente y Cajero son obligatorias, pero el modelo no contempla una sucursal especial que represente la ausencia de asignación.

En Administrar, tanto CURP como idSucursal forman parte de la llave primaria y poseen restricciones UNIQUE individuales. Asignar un valor predeterminado podría ocasionar conflictos de unicidad.

## Fuentes oficiales

PostgreSQL Global Development Group. PostgreSQL 18 Documentation. CREATE TABLE.

https://www.postgresql.org/docs/18/sql-createtable.html

PostgreSQL Global Development Group. PostgreSQL 18 Documentation. Constraints.

https://www.postgresql.org/docs/18/ddl-constraints.html

PostgreSQL Global Development Group. PostgreSQL 18 Documentation. COMMENT.

https://www.postgresql.org/docs/18/sql-comment.html
