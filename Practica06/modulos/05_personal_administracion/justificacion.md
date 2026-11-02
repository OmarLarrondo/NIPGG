# Justificación del módulo 05

Responsable: **Diego**. Estado: pendiente de desarrollar.

## Alcance

- `Genrente`
- `Cajero`
- `Administrar`
- `CorreoElectrónicoGerente`
- `TeléfonoGerente`
- `CorreoElectrónicoCajero`
- `TeléfonoCajero`

## Pregunta 5: elección por relación

Completar `decisiones.csv` y justificar ambas acciones para cada FK.

### `fk_correo_gerente`: `CorreoElectrónicoGerente` → `Genrente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_telefono_gerente`: `TeléfonoGerente` → `Genrente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_correo_cajero`: `CorreoElectrónicoCajero` → `Cajero`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_telefono_cajero`: `TeléfonoCajero` → `Cajero`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fkgerentesucursal`: `Genrente` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fkcajerosucursal`: `Cajero` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fkadministrargerente`: `Administrar` → `Genrente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fkadministrarsucursal`: `Administrar` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

## Verificación

Pendiente: versión de PostgreSQL, procedimiento, resultados esperados y obtenidos, y limitaciones. No registrar pruebas como aprobadas hasta ejecutarlas.
