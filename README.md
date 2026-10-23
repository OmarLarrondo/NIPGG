# ÑIPGG - Fundamentos de Bases de Datos (2027-1)

Repositorio del equipo **ÑIPGG** para las tareas, prácticas y el proyecto final
de *Fundamentos de Bases de Datos* (Facultad de Ciencias, UNAM).

## Entrega activa

La entrega activa es la **Práctica 05 - Lenguaje de Definición de Datos (DDL)**:
implementación del esquema de PuellaGame en PostgreSQL a partir del modelo
relacional anterior, restricciones mediante `ALTER TABLE`, documentación de
dominios y restauración de un respaldo con evidencias.

La estructura modular y las instrucciones de trabajo están en
[Practica05/README.md](Practica05/README.md).

| Módulo | Responsable | Área |
|---|---|---|
| 1 | Miguel | Clientes y contactos |
| 2 | Ana | Juegos, máquinas y técnicos |
| 3 | Omar | Premios, canjes y restauración del respaldo |
| 4 | Yahir | Sucursales y operaciones |
| 5 | Diego | Personal y administración |

Cada integrante desarrolla el DDL, la documentación de dominios y las pruebas
de sus tablas. Los README quedan a cargo de Omar; no se reparten tareas de
recopilación, integración o empaquetado como ejercicios de los módulos.

La estructura de Práctica 05 está preparada; su implementación y sus
entregables finales siguen pendientes.

## Entregas anteriores terminadas

Las demás tareas y prácticas existentes están terminadas, según la confirmación
del equipo. Se conservan como antecedentes y material de consulta:

- [Tarea 01](Tarea01/)
- [Tarea 02](Tarea02/)
- [Tarea 03](Tarea03/)
- [Práctica 01](Practica01/)
- [Práctica 02](Practica02/)
- [Práctica 03](Practica03/)
- [Práctica 03, parte 2](Practica03PT2/)
- [Práctica 04](Practica04/)

## Organización del repositorio

```text
ÑIPGG/
├── README.md
├── Practica05/                 # entrega activa: DDL
│   ├── README.md               # alcance, responsables y trabajo paralelo
│   ├── acuerdos/               # contrato del modelo pendiente de completar
│   ├── modulos/                # cinco módulos de SQL, documentación y pruebas
│   ├── reporte/                # fuentes del informe y del README de entrega
│   ├── Diagramas/              # destino de los modelos anteriores
│   ├── SQL/                    # destino del DDL integrado
│   └── Docs/                   # destino del informe final
├── Tarea01/                    # terminada
├── Tarea02/                    # terminada
├── Tarea03/                    # terminada
├── Practica01/                 # terminada
├── Practica02/                 # terminada
├── Practica03/                 # terminada
├── Practica03PT2/              # terminada
└── Practica04/                 # terminada
```

## Convenciones de colaboración

- Cada cambio debe limitarse al módulo asignado y a los acuerdos del equipo.
- Conservar los nombres de tablas y columnas del modelo relacional definitivo.
  Acordar las claves y los tipos compartidos antes de implementar referencias.
- Los commits siguen Conventional Commits, por ejemplo:
  `docs(practica05): documentar reparto modular`.
- Antes de entregar, revisar la ejecución del DDL completo, las restricciones,
  la correspondencia con los diagramas y los PDF compilados.
- No se versionan credenciales, datos personales reales de prueba ni archivos
  generados fuera de los entregables finales. La identificación académica
  requerida se incluye en los documentos de entrega.

## Forma de entrega

Cada entrega conserva su propio paquete final conforme a los lineamientos de
Classroom. Para la Práctica 05 se prevén los cuatro archivos de diagramas,
`SQL/DDL.sql`, `Docs/Práctica05.pdf` y `README_ÑIPGG.pdf`. Los nombres definitivos
y el contenido exacto del ZIP se verificarán antes de publicar la entrega.
