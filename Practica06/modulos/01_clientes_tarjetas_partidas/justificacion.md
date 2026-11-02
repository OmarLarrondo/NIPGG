# Justificación del módulo 01

Responsable: **Omar**. Estado: pendiente de desarrollar.

## Alcance

- `Cliente`
- `correoElectrónico`
- `teléfono`
- `Tarjeta`
- `Partida`

## Pregunta 5: elección por relación

Completar `decisiones.csv` y justificar ambas acciones para cada FK.

### `fk_correo_cliente`: `correoElectrónico` → `Cliente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_telefono_cliente`: `teléfono` → `Cliente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_tarjeta_cliente`: `Tarjeta` → `Cliente`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_tarjeta_cajero`: `Tarjeta` → `Cajero`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_partida_tarjeta`: `Partida` → `Tarjeta`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_partida_maquina`: `Partida` → `Máquina`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

## Verificación

Pendiente: versión de PostgreSQL, procedimiento, resultados esperados y obtenidos, y limitaciones. No registrar pruebas como aprobadas hasta ejecutarlas.
