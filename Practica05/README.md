# Práctica 05 · Lenguaje de Definición de Datos (DDL)

Equipo **ÑIPGG** · Fundamentos de Bases de Datos · UNAM · 2027-I.

**Entrega activa. Estado: estructura modular preparada; ejercicios pendientes.**

## Consigna e insumos

- [Práctica05.pdf](Práctica05.pdf): instrucciones originales; no confundir con el informe final `Docs/Práctica05.pdf`.
- [RestaurarBackup.pdf](RestaurarBackup.pdf): material de apoyo para la restauración.
- [ejemplo.backup](ejemplo.backup): respaldo proporcionado, todavía sin restaurar en esta estructura.
- [Práctica 04](../Practica04/README.md): modelo relacional y antecedentes de dominios. Su README señala diferencias entre informe y diagrama; resolverlas antes de implementar.

## Trabajo de la práctica

1. Elaborar un único `SQL/DDL.sql` basado en el modelo relacional anterior, conservando nombres de tablas y columnas. Elegir tipos y definir restricciones de dominio, entidad y referencia mediante `ALTER TABLE`.
2. Elaborar `Docs/Práctica05.pdf` con los dominios de cada columna y las evidencias de restauración.
3. Incluir los modelos E-R y relacional, cada uno en `.png` y `.drawio`.
4. Restaurar el respaldo y comprobar el resultado.

## Responsables confirmados

| Módulo | Responsable | Área | Tablas asignadas |
|---|---|---|---|
| 01 | Miguel | [Clientes y contactos](modulos/01_clientes_contactos/README.md) | `Cliente`, `CorreoCliente`, `TelefonoCliente`, `Tarjeta`, `Partida`, `CorreoEmpleado`, `TelefonoEmpleado` |
| 02 | Ana | [Juegos, máquinas y técnicos](modulos/02_juegos_maquinas_tecnicos/README.md) | `TipoJuego`, `Juego`, `Máquina`, `Mantenimiento`, `Técnico`, `CertificacionTecnico` |
| 03 | Omar | [Premios y canjes](modulos/03_premios_canjes/README.md) | `Premio`, `Canje`, `Disponer` |
| 04 | Yahir | [Sucursales y operaciones](modulos/04_sucursales_operaciones/README.md) | `Sucursal`, `HorarioSucursal`, `Visita`, `Recarga` |
| 05 | Diego | [Personal y administración](modulos/05_personal_administracion/README.md) | `Empleado`, `Gerente`, `Cajero`, `EncargadoDePremios`, `Administrar` |

**Omar también realiza la restauración**, escribe [su sección](reporte/secciones/06_restauracion.tex) y guarda las [evidencias](reporte/evidencias/restauracion/README.md).

Los dos README de la entrega quedan a cargo de Omar. La recopilación de diagramas, integración y empaquetado no se distribuyen como ejercicios adicionales entre los cinco módulos. El README de identificación tiene una [fuente inicial](reporte/README_ÑIPGG.tex) pendiente de completar.

## Estructura de trabajo

```text
Practica05/
├── README.md
├── Práctica05.pdf                 # consigna original
├── RestaurarBackup.pdf            # guía original
├── ejemplo.backup                 # insumo original
├── acuerdos/contrato_modelo.md
├── modulos/                      # cinco módulos con responsables
│   └── <modulo>/
│       ├── README.md
│       ├── tablas.sql
│       ├── dominios.sql
│       ├── claves.sql
│       ├── referencias.sql
│       ├── documentacion.tex
│       └── pruebas.sql
├── reporte/
│   ├── README.md
│   ├── main.tex
│   ├── README_ÑIPGG.tex
│   ├── secciones/06_restauracion.tex
│   └── evidencias/restauracion/
├── Diagramas/README.md
├── SQL/README.md
└── Docs/README.md
```

## Cómo trabajar en paralelo

- Cada integrante edita los seis archivos técnicos de su módulo. Su README identifica el alcance y los archivos concretos.
- Antes de escribir SQL, acordar los identificadores y las claves en [contrato_modelo.md](acuerdos/contrato_modelo.md). No renombrar objetos de forma unilateral.
- Las FK se escriben en el módulo de la tabla origen y se acuerdan con el propietario de la tabla destino.
- La documentación cubre todas las columnas del módulo y debe coincidir con el SQL.
- Probar las restricciones con datos válidos e inválidos. Cada responsable soluciona los defectos encontrados en su área.
- Las tablas de personal están repartidas: contactos con Miguel; Técnico y CertificacionTecnico con Ana; Empleado y los demás subtipos con Diego.

## Integración prevista

El DDL final se ensamblará en cuatro fases: **todos los `tablas.sql` → todos los `dominios.sql` → todos los `claves.sql` → todos los `referencias.sql`**. Dentro de cada fase, usar el orden de módulo 01 a 05. Así las tablas y claves destino existen antes de agregar las FK.

`SQL/DDL.sql` será un archivo autónomo con el SQL ensamblado; no debe depender de rutas locales o módulos externos. Se corrigen las fuentes y luego se regenera. Los `pruebas.sql` se ejecutan por separado y no forman parte del DDL entregable. El ensamblado y su automatización todavía no están implementados.

[reporte/main.tex](reporte/main.tex) incorpora las cinco secciones mediante `\input` y la sección de restauración. Actualmente es una plantilla, no un informe terminado.

## Contenido previsto del ZIP final

```text
Práctica05_ÑIPGG.zip
├── Diagramas/
│   ├── RelacionalÑIPGG.png
│   ├── RelacionalÑIPGG.drawio
│   ├── ERÑIPGG.png
│   └── ERÑIPGG.drawio
├── SQL/DDL.sql
├── Docs/Práctica05.pdf
└── README_ÑIPGG.pdf
```

Los nombres y el contenido se contrastarán con los lineamientos de Classroom antes de entregar. Las carpetas de módulos, fuentes, consigna y respaldo son materiales de trabajo; no se añaden automáticamente al ZIP. Ninguno de los entregables finales se ha generado en esta etapa.
