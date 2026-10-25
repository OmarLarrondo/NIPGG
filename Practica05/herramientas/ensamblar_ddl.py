#!/usr/bin/env python3
"""Ensambla fuentes en cuatro fases; el modo final exige todos los módulos."""
from pathlib import Path
import argparse
import re

ROOT = Path(__file__).resolve().parents[1]
PHASES = ('tablas', 'dominios', 'claves', 'referencias')


def assemble(partial=False):
    modules = sorted(m for m in (ROOT / 'modulos').iterdir() if m.is_dir())
    missing = [m for m in modules if not re.search(r'CREATE\s+TABLE', re.sub(r'--[^\n]*', '', (m / 'tablas.sql').read_text()), re.I)]
    if missing and not partial:
        raise SystemExit('DDL final bloqueado: faltan ' + ', '.join(m.name for m in missing)
                         + '. Usa --disponible para generar un avance explícito.')
    active = [m for m in modules if m not in missing]
    # Obtener destinos existentes de las mismas fuentes, sin sustituir tablas ausentes.
    table_pattern = r'CREATE\s+TABLE\s+"([^"]+)"'
    existing = {t for m in active for t in re.findall(table_pattern, re.sub(r'--[^\n]*', '', (m / 'tablas.sql').read_text()), re.I)}
    chunks = ['-- GENERADO por herramientas/ensamblar_ddl.py. Editar las fuentes.\n'
              '-- AVANCE: faltan módulos/referencias; no es DDL de entrega.\n' if missing else
              '-- GENERADO por herramientas/ensamblar_ddl.py. Editar las fuentes.\n']
    chunks.append('BEGIN;\n')
    deferred = []
    for phase in PHASES:
        for module in active:
            source = module / (phase + '.sql')
            sql = source.read_text()
            if phase == 'referencias':
                # Separar cada ADD CONSTRAINT sin perder las FK existentes del mismo ALTER.
                statements = re.sub(r'--[^\n]*', '', sql).split(';')
                kept = []
                for stmt in statements:
                    if not stmt.strip():
                        continue
                    match = re.fullmatch(r'\s*ALTER\s+TABLE\s+("[^"]+")\s+(.*)', stmt, re.I | re.S)
                    if not match:
                        raise ValueError('Formato de FK no admitido: ' + str(source))
                    table, constraints = match.groups()
                    for constraint in re.split(r',\s*(?=ADD\s+CONSTRAINT)', constraints, flags=re.I):
                        targets = re.findall(r'REFERENCES\s+"([^"]+)"', constraint, re.I)
                        rendered = f'ALTER TABLE {table}\n{constraint.strip()};\n'
                        if any(t not in existing for t in targets):
                            if not partial:
                                raise ValueError('Destino ausente: ' + ', '.join(targets))
                            deferred.append('-- Fuente: ' + str(source.relative_to(ROOT)) + '\n' + rendered)
                        else:
                            kept.append(rendered)
                sql = '\n'.join(kept)
            chunks.append('\n-- Fuente: ' + str(source.relative_to(ROOT)) + '\n' + sql.rstrip() + '\n')
    chunks.append('\nCOMMIT;\n')
    name = 'DDL_disponible.sql' if missing or deferred else 'DDL.sql'
    if deferred and not missing:
        chunks.insert(0, '-- AVANCE: referencias pendientes; no es DDL de entrega.\n')
    (ROOT / 'SQL' / name).write_text(''.join(chunks))
    pending = ROOT / 'SQL' / 'referencias_pendientes.sql'
    pending.write_text('-- NO ejecutar hasta integrar el módulo 02 y sus claves.\n' + '\n'.join(deferred))
    print(f'{name}: {len(existing)} tablas, {len(deferred)} FK pendientes; módulos ausentes: '
          + (', '.join(m.name for m in missing) or 'ninguno'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--disponible', action='store_true', help='Generar avance sin inventar módulos ausentes')
    assemble(parser.parse_args().disponible)
