# SQL integrado

`DDL_disponible.sql` integra los módulos 01, 03, 04 y 05: 24 tablas.
Ejecutarlo con `psql -X -v ON_ERROR_STOP=1` en una base vacía de pruebas.
Las tres FK que dependen del módulo 02 están en `referencias_pendientes.sql`;
no ejecutarlas hasta disponer de las tablas y claves reales de Ana.

Regenerar con `python3 herramientas/ensamblar_ddl.py --disponible` desde
Práctica05. El modo final, sin ese indicador, se detiene si faltan módulos.
Editar siempre las fuentes; el orden es tablas, dominios, claves y referencias.
El DDL se ejecuta dentro de una transacción. Las pruebas van por separado.
