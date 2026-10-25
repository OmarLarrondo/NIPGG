# SQL de entrega

Destino previsto: `DDL.sql`, todavía no generado.

Ensamblar las fuentes de `../modulos/` por fases, con módulos 01 a 05 dentro de cada fase:

1. Todos los `tablas.sql`.
2. Todos los `dominios.sql`.
3. Todos los `claves.sql`.
4. Todos los `referencias.sql`.

El resultado debe contener SQL autónomo y todas las restricciones requeridas mediante `ALTER TABLE`. No incluir `pruebas.sql`. Validar el archivo completo en una base vacía antes de entregarlo. No confundir ejecutar los marcadores actuales, que son solo comentarios, con validar un esquema implementado.
