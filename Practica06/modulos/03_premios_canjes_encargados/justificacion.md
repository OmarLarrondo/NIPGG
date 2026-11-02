# Justificación del módulo 03

Responsable: **Ana**. Estado: pendiente de desarrollar.

## Alcance

- `Premio`
- `Canje`
- `Disponer`
- `Encargado de premios`
- `CorreoElectrónicoEncargado`
- `TeléfonoEncargado`

## Pregunta 5: elección por relación

Completar `decisiones.csv` y justificar ambas acciones para cada FK.

### `fk_correo_encargado`: `CorreoElectrónicoEncargado` → `Encargado de premios`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_telefono_encargado`: `TeléfonoEncargado` → `Encargado de premios`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_canje_sucursal`: `Canje` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_canje_cliente`: `Canje` → `Cliente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_canje_premio`: `Canje` → `Premio`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_canje_encargado`: `Canje` → `Encargado de premios`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_disponer_sucursal`: `Disponer` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_disponer_premio`: `Disponer` → `Premio`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fkencargadopremiossucursal`: `Encargado de premios` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

## Verificación

Pendiente: versión de PostgreSQL, procedimiento, resultados esperados y obtenidos, y limitaciones. No registrar pruebas como aprobadas hasta ejecutarlas.
