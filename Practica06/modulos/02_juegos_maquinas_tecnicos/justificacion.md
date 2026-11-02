# Justificación del módulo 02

Responsable: **Miguel**. Estado: pendiente de desarrollar.

## Alcance

- `tipoDeJuego`
- `Juego`
- `Máquina`
- `Mantenimiento`
- `Técnico`
- `Certificaciones`
- `CorreoElectrónicoTécnico`
- `TeléfonoTécnivo`

## Pregunta 5: elección por relación

Completar `decisiones.csv` y justificar ambas acciones para cada FK.

### `fk_correo_tecnico`: `CorreoElectrónicoTécnico` → `Técnico`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_telefono_tecnico`: `TeléfonoTécnivo` → `Técnico`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_mantenimiento_maquina`: `Mantenimiento` → `Máquina`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_mantenimiento_tecnico`: `Mantenimiento` → `Técnico`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_maquina_juego`: `Máquina` → `Juego`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_maquina_sucursal`: `Máquina` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_juego_tipo`: `Juego` → `tipoDeJuego`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_tecnico_sucursal`: `Técnico` → `SUCURSAL`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

### `fk_certificacion_tecnico`: `Certificaciones` → `Técnico`

- ON DELETE: pendiente.
- ON UPDATE: pendiente.
- Motivo de negocio y alternativas descartadas: pendiente.
- Compatibilidad con claves, NOT NULL y DEFAULT: pendiente.
- Efectos sobre otros módulos y conservación del historial: pendiente.

## Verificación

Pendiente: versión de PostgreSQL, procedimiento, resultados esperados y obtenidos, y limitaciones. No registrar pruebas como aprobadas hasta ejecutarlas.
