
# Justificación de políticas del módulo 05

**Responsable:** Diego.
**Módulo:** Personal y administración.
**Equipo:** ÑIPGG.
**Práctica:** 06.

## Alcance

El módulo comprende las siguientes siete tablas:

- Genrente
- Cajero
- Administrar
- CorreoElectrónicoGerente
- TeléfonoGerente
- CorreoElectrónicoCajero
- TeléfonoCajero

Se implementan las políticas de las ocho llaves foráneas cuyo origen pertenece a estas tablas.

## Pregunta 5. Elección de políticas y motivos

Las políticas seleccionadas se resumen en la siguiente tabla:

| Llave foránea | ON DELETE | ON UPDATE |
|---|---|---|
| fk_correo_gerente | CASCADE | CASCADE |
| fk_telefono_gerente | CASCADE | CASCADE |
| fk_correo_cajero | CASCADE | CASCADE |
| fk_telefono_cajero | CASCADE | CASCADE |
| fkgerentesucursal | NO ACTION | CASCADE |
| fkcajerosucursal | NO ACTION | CASCADE |
| fkadministrargerente | CASCADE | CASCADE |
| fkadministrarsucursal | CASCADE | CASCADE |

### 1. Contactos de gerentes y cajeros

Llaves foráneas:

- fk_correo_gerente
- fk_telefono_gerente
- fk_correo_cajero
- fk_telefono_cajero

Se eligió ON DELETE CASCADE porque los correos electrónicos y teléfonos dependen directamente del empleado al que pertenecen. Si se elimina un gerente o un cajero, sus datos de contacto dejan de tener utilidad dentro del esquema y también deben eliminarse.

Se eligió ON UPDATE CASCADE para conservar los contactos cuando se realiza una corrección en el CURP del empleado. De esta manera, los cambios en la llave primaria se propagan automáticamente a las tablas que dependen de ella.

Se descartó SET NULL porque CURP es obligatorio y forma parte de la llave primaria compuesta de las tablas de contactos.

También se descartó SET DEFAULT porque no existe un gerente o cajero genérico que deba convertirse en propietario de los contactos de otro empleado.

### 2. Relación de Genrente con SUCURSAL

Llave foránea: fkgerentesucursal.

Se eligió ON DELETE NO ACTION porque no se considera adecuado eliminar una sucursal mientras todavía tenga gerentes asignados. El gerente conserva una relación laboral con la sucursal y no se debe eliminar ni reasignar automáticamente cuando desaparece dicha entidad.

Se eligió ON UPDATE CASCADE porque, si se corrige el identificador de una sucursal, el cambio debe propagarse a los gerentes que pertenecen a ella.

Se descartó CASCADE en DELETE porque podría ocasionar la eliminación de gerentes como consecuencia de borrar una sucursal.

Se descartó SET DEFAULT porque no existe en el esquema una sucursal predeterminada que represente correctamente a los gerentes sin sucursal asignada.

### 3. Relación de Cajero con SUCURSAL

Llave foránea: fkcajerosucursal.

Se eligió ON DELETE NO ACTION porque eliminar una sucursal no debe provocar la eliminación automática de los cajeros que trabajan en ella. Es necesario conservar sus registros laborales y resolver previamente su asignación.

Se eligió ON UPDATE CASCADE para mantener la relación entre los cajeros y su sucursal cuando se modifica el identificador de esta última.

Se descartó CASCADE en DELETE porque podría ocasionar la pérdida de los datos laborales de los cajeros.

Se descartó SET DEFAULT porque el esquema no contempla una sucursal especial para empleados sin asignación. Utilizar otra sucursal existente cambiaría incorrectamente el lugar de trabajo del empleado.

### 4. Relación de Administrar con Genrente

Llave foránea: fkadministrargerente.

Se eligió ON DELETE CASCADE porque la tabla Administrar representa una relación entre gerentes y sucursales. Si se elimina un gerente, su asignación administrativa también debe desaparecer.

Se eligió ON UPDATE CASCADE porque una corrección del CURP del gerente debe reflejarse en la relación Administrar, evitando que la asignación quede asociada con una clave anterior.

Se descartó NO ACTION en DELETE porque obligaría a eliminar manualmente la relación antes de eliminar al gerente, aunque esta no tiene existencia independiente.

Se descartó SET NULL porque CURP es obligatorio y forma parte de la llave primaria de Administrar.

### 5. Relación de Administrar con SUCURSAL

Llave foránea: fkadministrarsucursal.

Se eligió ON DELETE CASCADE porque la relación administrativa depende de la existencia de la sucursal. Si una sucursal se elimina y no existen otras restricciones que impidan la operación, también debe eliminarse la asignación administrativa correspondiente.

Se eligió ON UPDATE CASCADE porque las modificaciones del identificador de la sucursal deben propagarse a la tabla Administrar.

Se descartó SET NULL porque idSucursal forma parte de la llave primaria compuesta y no permite valores nulos.

También se descartó SET DEFAULT porque no existe una sucursal predeterminada y porque el valor asignado podría entrar en conflicto con las restricciones UNIQUE de la tabla Administrar.

## Compatibilidad con el esquema

Las ocho llaves foráneas conservan sus nombres, columnas y tablas referenciadas originales.

No se agregan valores DEFAULT ni registros ficticios al modelo.

Las columnas CURP e idSucursal de Administrar siguen formando parte de su llave primaria compuesta. Asimismo, se conservan las restricciones UNIQUE que impiden que un gerente administre más de una sucursal o que una sucursal tenga más de un gerente asignado dentro de esta relación.

Las columnas CURP de las tablas de contactos continúan siendo obligatorias y pertenecen a sus respectivas llaves primarias compuestas.

## Verificación

Para comprobar el funcionamiento de las políticas de mantenimiento de llaves foráneas, se realizaron pruebas sobre una base de datos de prueba utilizando las tablas correspondientes al módulo 05.

Las pruebas contemplan operaciones de eliminación y actualización de registros referenciados, así como inserciones y modificaciones que intentan establecer referencias a registros inexistentes.

Se verificó que las políticas CASCADE propaguen correctamente los cambios a las tablas dependientes, mientras que las políticas NO ACTION impidan las operaciones que podrían dejar registros con referencias inválidas.

También se verificó que las restricciones de integridad referencial continúen funcionando después de aplicar las modificaciones al DDL.

Finalmente, se comprobó que las operaciones realizadas durante las pruebas no alteren la información original de la base de datos, utilizando una transacción que permite revertir los cambios al finalizar.
