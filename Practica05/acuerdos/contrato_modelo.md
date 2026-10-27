# Contrato técnico del modelo · Práctica 05

Estado: implementación final integrada y validada. La fuente de estructura es `Diagramas/RelacionalÑIPGG.drawio`, conservada junto a su PNG histórico.

PostgreSQL 18: 30 tablas, 146 columnas obligatorias, 30 PK, 38 FK, seis UNIQUE y 134 CHECK.

Se conservan nombres, acentos y mayúsculas mediante comillas dobles, incluidos los rótulos `Genrente` y `TeléfonoTécnivo`. El personal usa `Nombre`, `ApellidoMaterno` y `ApellidoPaterno` con mayúscula inicial. No se añade una tabla Empleado ajena al diagrama. Técnico incluye `áreaEspecialidad`; la tabla de tipos es `tipoDeJuego` y la de certificaciones es `Certificaciones`. Mantenimiento tiene PK `(idMaquina, idMantenimiento)`.

Disponer y Administrar muestran solo marcas FK: se toman sus parejas como PK. Administrar añade UNIQUE por CURP e idSucursal para reflejar la relación uno a uno. Se conserva UNIQUE de Tarjeta.idCliente. Las acciones referenciales son NO ACTION, explícitas o predeterminadas. Todas las restricciones se agregan con ALTER TABLE y no hay valores predeterminados.

Las restricciones no automatizan operaciones de saldo, descuento de puntos o existencias, ni especialización total o disjunta entre puestos. Estas reglas entre tablas no se atribuyen a los CHECK locales.

## Inventario comprobado del catálogo

### Administrar

Columnas: `CURP char(18) NOT NULL`, `idSucursal int NOT NULL`.

- `fkadministrargerente`: `FOREIGN KEY ("CURP") REFERENCES "Genrente"("CURP")`.
- `fkadministrarsucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pkadministrar`: `PRIMARY KEY ("CURP", "idSucursal")`.
- `uqadministrargerente`: `UNIQUE ("CURP")`.
- `uqadministrarsucursal`: `UNIQUE ("idSucursal")`.

### Cajero

Columnas: `CURP char(18) NOT NULL`, `idSucursal int NOT NULL`, `Nombre varchar(100) NOT NULL`, `ApellidoMaterno varchar(100) NOT NULL`, `ApellidoPaterno varchar(100) NOT NULL`, `RFC char(13) NOT NULL`, `fechaContratación date NOT NULL`, `salario numeric(10,2) NOT NULL`, `fechaNacimiento date NOT NULL`, `horarioTrabajo time NOT NULL`.

- `fkcajerosucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pkcajero`: `PRIMARY KEY ("CURP")`.
- `uqcajerorfc`: `UNIQUE ("RFC")`.

### Canje

Columnas: `idCanje int NOT NULL`, `idSucursal int NOT NULL`, `idCliente int NOT NULL`, `idPremio int NOT NULL`, `CURP char(18) NOT NULL`, `hora Time NOT NULL`, `puntosUtilizados int NOT NULL`, `cantidadPremios int NOT NULL`, `fecha Date NOT NULL`.

- `fk_canje_cliente`: `FOREIGN KEY ("idCliente") REFERENCES "Cliente"("idCliente")`.
- `fk_canje_encargado`: `FOREIGN KEY ("CURP") REFERENCES "Encargado de premios"("CURP")`.
- `fk_canje_premio`: `FOREIGN KEY ("idPremio") REFERENCES "Premio"("idPremio")`.
- `fk_canje_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pk_canje`: `PRIMARY KEY ("idCanje")`.

### Certificaciones

Columnas: `CURP char(18) NOT NULL`, `Certificaciones varchar(80) NOT NULL`.

- `fk_certificacion_tecnico`: `FOREIGN KEY ("CURP") REFERENCES "Técnico"("CURP")`.
- `pk_certificacion_tecnico`: `PRIMARY KEY ("CURP", "Certificaciones")`.

### Cliente

Columnas: `idCliente int NOT NULL`, `fechaNacimiento date NOT NULL`, `nombre varchar(50) NOT NULL`, `apellidoMaterno varchar(50) NOT NULL`, `apellidoPaterno varchar(50) NOT NULL`, `sexo varchar(50) NOT NULL`.

- `pk_cliente`: `PRIMARY KEY ("idCliente")`.

### CorreoElectrónicoCajero

Columnas: `CURP char(18) NOT NULL`, `correoCajero varchar(50) NOT NULL`.

- `fk_correo_cajero`: `FOREIGN KEY ("CURP") REFERENCES "Cajero"("CURP")`.
- `pk_correo_cajero`: `PRIMARY KEY ("CURP", "correoCajero")`.

### CorreoElectrónicoEncargado

Columnas: `CURP char(18) NOT NULL`, `correoEncargado varchar(50) NOT NULL`.

- `fk_correo_encargado`: `FOREIGN KEY ("CURP") REFERENCES "Encargado de premios"("CURP")`.
- `pk_correo_encargado`: `PRIMARY KEY ("CURP", "correoEncargado")`.

### CorreoElectrónicoGerente

Columnas: `CURP char(18) NOT NULL`, `correoGerente varchar(50) NOT NULL`.

- `fk_correo_gerente`: `FOREIGN KEY ("CURP") REFERENCES "Genrente"("CURP")`.
- `pk_correo_gerente`: `PRIMARY KEY ("CURP", "correoGerente")`.

### CorreoElectrónicoTécnico

Columnas: `CURP char(18) NOT NULL`, `correoTécnico varchar(50) NOT NULL`.

- `fk_correo_tecnico`: `FOREIGN KEY ("CURP") REFERENCES "Técnico"("CURP")`.
- `pk_correo_tecnico`: `PRIMARY KEY ("CURP", "correoTécnico")`.

### Disponer

Columnas: `idSucursal int NOT NULL`, `idPremio int NOT NULL`, `cantidadDisponible int NOT NULL`.

- `fk_disponer_premio`: `FOREIGN KEY ("idPremio") REFERENCES "Premio"("idPremio")`.
- `fk_disponer_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pk_disponer`: `PRIMARY KEY ("idSucursal", "idPremio")`.

### Encargado de premios

Columnas: `CURP char(18) NOT NULL`, `idSucursal int NOT NULL`, `Nombre varchar(100) NOT NULL`, `ApellidoMaterno varchar(100) NOT NULL`, `ApellidoPaterno varchar(100) NOT NULL`, `RFC char(13) NOT NULL`, `fechaContratación date NOT NULL`, `salario numeric(10,2) NOT NULL`, `fechaNacimiento date NOT NULL`, `horarioTrabajo time NOT NULL`.

- `fkencargadopremiossucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pkencargadodepremios`: `PRIMARY KEY ("CURP")`.
- `uqencargadodepremiosrfc`: `UNIQUE ("RFC")`.

### Genrente

Columnas: `CURP char(18) NOT NULL`, `idSucursal int NOT NULL`, `Nombre varchar(100) NOT NULL`, `ApellidoMaterno varchar(100) NOT NULL`, `ApellidoPaterno varchar(100) NOT NULL`, `RFC char(13) NOT NULL`, `fechaContratación date NOT NULL`, `salario numeric(10,2) NOT NULL`, `fechaNacimiento date NOT NULL`, `cédulaProfesional varchar(8) NOT NULL`.

- `fkgerentesucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pkgerente`: `PRIMARY KEY ("CURP")`.
- `uqgerenterfc`: `UNIQUE ("RFC")`.

### HORARIO_SUCURSAL

Columnas: `idSucursal int NOT NULL`, `horario varchar(50) NOT NULL`.

- `fk_horario_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pk_horario_sucursal`: `PRIMARY KEY ("idSucursal", horario)`.

### Juego

Columnas: `idJuego int NOT NULL`, `costo int NOT NULL`, `nombre varchar(50) NOT NULL`, `idTipo int NOT NULL`.

- `fk_juego_tipo`: `FOREIGN KEY ("idTipo") REFERENCES "tipoDeJuego"("idTipo")`.
- `pk_juego`: `PRIMARY KEY ("idJuego")`.

### Mantenimiento

Columnas: `idMaquina int NOT NULL`, `idMantenimiento int NOT NULL`, `fecha date NOT NULL`, `descripcionProblema text NOT NULL`, `tipoMantenimiento varchar(50) NOT NULL`, `CURP char(18) NOT NULL`.

- `fk_mantenimiento_maquina`: `FOREIGN KEY ("idMaquina") REFERENCES "Máquina"("idMaquina")`.
- `fk_mantenimiento_tecnico`: `FOREIGN KEY ("CURP") REFERENCES "Técnico"("CURP")`.
- `pk_mantenimiento`: `PRIMARY KEY ("idMaquina", "idMantenimiento")`.

### Máquina

Columnas: `idMaquina int NOT NULL`, `estado varchar(50) NOT NULL`, `idJuego int NOT NULL`, `idSucursal int NOT NULL`.

- `fk_maquina_juego`: `FOREIGN KEY ("idJuego") REFERENCES "Juego"("idJuego")`.
- `fk_maquina_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pk_maquina`: `PRIMARY KEY ("idMaquina")`.

### Partida

Columnas: `idCliente int NOT NULL`, `numeroTarjeta int NOT NULL`, `idMaquina int NOT NULL`, `idPartida int NOT NULL`, `fecha date NOT NULL`, `puntosGanados int NOT NULL`, `hora timetz NOT NULL`, `puntajeObtenido int NOT NULL`.

- `fk_partida_maquina`: `FOREIGN KEY ("idMaquina") REFERENCES "Máquina"("idMaquina")`.
- `fk_partida_tarjeta`: `FOREIGN KEY ("idCliente", "numeroTarjeta") REFERENCES "Tarjeta"("idCliente", "numeroTarjeta")`.
- `pk_partida`: `PRIMARY KEY ("idCliente", "numeroTarjeta", "idMaquina", "idPartida")`.

### Premio

Columnas: `idPremio int NOT NULL`, `valorAproximado int NOT NULL`, `puntosNecesarios int NOT NULL`, `nombre varchar(50) NOT NULL`, `categoría varchar(50) NOT NULL`, `rangoEdad varchar(50) NOT NULL`.

- `pk_premio`: `PRIMARY KEY ("idPremio")`.

### RECARGA

Columnas: `idCliente int NOT NULL`, `numeroTarjeta int NOT NULL`, `idSucursal int NOT NULL`, `idRecarga int NOT NULL`, `CURP char(18) NOT NULL`, `monto int NOT NULL`, `fecha date NOT NULL`, `hora timetz NOT NULL`, `métodoAbono varchar(50) NOT NULL`.

- `fk_recarga_cajero`: `FOREIGN KEY ("CURP") REFERENCES "Cajero"("CURP")`.
- `fk_recarga_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `fk_recarga_tarjeta`: `FOREIGN KEY ("idCliente", "numeroTarjeta") REFERENCES "Tarjeta"("idCliente", "numeroTarjeta")`.
- `pk_recarga`: `PRIMARY KEY ("idCliente", "numeroTarjeta", "idSucursal", "idRecarga", "CURP")`.

### SUCURSAL

Columnas: `idSucursal int NOT NULL`, `nombre varchar(50) NOT NULL`, `teléfono char(10) NOT NULL`, `calle varchar(100) NOT NULL`, `númeroExterior int NOT NULL`, `númeroInterior int NOT NULL`, `colonia varchar(50) NOT NULL`, `estado varchar(50) NOT NULL`.

- `pk_sucursal`: `PRIMARY KEY ("idSucursal")`.

### Tarjeta

Columnas: `idCliente int NOT NULL`, `numeroTarjeta int NOT NULL`, `CURP char(18) NOT NULL`, `costoAdquisición int NOT NULL`, `fechaCompra date NOT NULL`, `saldo int NOT NULL`, `estado varchar(50) NOT NULL`, `puntosAcumulados int NOT NULL`.

- `fk_tarjeta_cajero`: `FOREIGN KEY ("CURP") REFERENCES "Cajero"("CURP")`.
- `fk_tarjeta_cliente`: `FOREIGN KEY ("idCliente") REFERENCES "Cliente"("idCliente")`.
- `pk_tarjeta`: `PRIMARY KEY ("idCliente", "numeroTarjeta")`.
- `uq_tarjeta_cliente`: `UNIQUE ("idCliente")`.

### TeléfonoCajero

Columnas: `CURP char(18) NOT NULL`, `telefonoCajero char(10) NOT NULL`.

- `fk_telefono_cajero`: `FOREIGN KEY ("CURP") REFERENCES "Cajero"("CURP")`.
- `pk_telefono_cajero`: `PRIMARY KEY ("CURP", "telefonoCajero")`.

### TeléfonoEncargado

Columnas: `CURP char(18) NOT NULL`, `telefonoEncargado char(10) NOT NULL`.

- `fk_telefono_encargado`: `FOREIGN KEY ("CURP") REFERENCES "Encargado de premios"("CURP")`.
- `pk_telefono_encargado`: `PRIMARY KEY ("CURP", "telefonoEncargado")`.

### TeléfonoGerente

Columnas: `CURP char(18) NOT NULL`, `telefonoGerente char(10) NOT NULL`.

- `fk_telefono_gerente`: `FOREIGN KEY ("CURP") REFERENCES "Genrente"("CURP")`.
- `pk_telefono_gerente`: `PRIMARY KEY ("CURP", "telefonoGerente")`.

### TeléfonoTécnivo

Columnas: `CURP char(18) NOT NULL`, `telefonoTécnico char(10) NOT NULL`.

- `fk_telefono_tecnico`: `FOREIGN KEY ("CURP") REFERENCES "Técnico"("CURP")`.
- `pk_telefono_tecnico`: `PRIMARY KEY ("CURP", "telefonoTécnico")`.

### Técnico

Columnas: `CURP char(18) NOT NULL`, `idSucursal int NOT NULL`, `Nombre varchar(100) NOT NULL`, `ApellidoMaterno varchar(100) NOT NULL`, `ApellidoPaterno varchar(100) NOT NULL`, `RFC char(13) NOT NULL`, `fechaContratación date NOT NULL`, `salario numeric(10,2) NOT NULL`, `fechaNacimiento date NOT NULL`, `áreaEspecialidad varchar(100) NOT NULL`.

- `fk_tecnico_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `pk_tecnico`: `PRIMARY KEY ("CURP")`.

### VISITA

Columnas: `idCliente int NOT NULL`, `numeroTarjeta int NOT NULL`, `idSucursal int NOT NULL`, `idVisita int NOT NULL`, `fecha date NOT NULL`.

- `fk_visita_sucursal`: `FOREIGN KEY ("idSucursal") REFERENCES "SUCURSAL"("idSucursal")`.
- `fk_visita_tarjeta`: `FOREIGN KEY ("idCliente", "numeroTarjeta") REFERENCES "Tarjeta"("idCliente", "numeroTarjeta")`.
- `pk_visita`: `PRIMARY KEY ("idCliente", "numeroTarjeta", "idSucursal", "idVisita")`.

### correoElectrónico

Columnas: `idCliente int NOT NULL`, `correoElectrónico varchar(100) NOT NULL`.

- `fk_correo_cliente`: `FOREIGN KEY ("idCliente") REFERENCES "Cliente"("idCliente")`.
- `pk_correo_cliente`: `PRIMARY KEY ("idCliente", "correoElectrónico")`.

### teléfono

Columnas: `idCliente int NOT NULL`, `teléfono char(10) NOT NULL`.

- `fk_telefono_cliente`: `FOREIGN KEY ("idCliente") REFERENCES "Cliente"("idCliente")`.
- `pk_telefono_cliente`: `PRIMARY KEY ("idCliente", "teléfono")`.

### tipoDeJuego

Columnas: `idTipo int NOT NULL`, `reglaPuntuacion text NOT NULL`, `condicion text NOT NULL`, `nombre varchar(50) NOT NULL`.

- `pk_tipo_juego`: `PRIMARY KEY ("idTipo")`.
