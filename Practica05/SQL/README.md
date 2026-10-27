# SQL de entrega

`DDL.sql` es autónomo y crea las 30 tablas en una base vacía de PostgreSQL 18. Se ensambla a partir de los módulos por fases: tablas, dominios, claves y referencias.

```bash
psql -X -v ON_ERROR_STOP=1 -1 -d BASE_VACIA -f DDL.sql
psql -X -v ON_ERROR_STOP=1 -d BASE_VACIA -f pruebas_integracion.sql
```

La segunda instrucción ejecuta pruebas sobre las tablas reales, con datos sintéticos revertidos al terminar; **363 rechazos esperados**. Solo `DDL.sql` se incluye en el ZIP.
