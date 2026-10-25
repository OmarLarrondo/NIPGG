#!/usr/bin/env python3
"""Compila los dos PDF de avance sin auxiliares en el repositorio."""
from pathlib import Path
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
TARGETS = [('main.tex', ROOT / 'Docs/Practica05_avance.pdf'),
           ('README_ÑIPGG.tex', ROOT / 'README_ÑIPGG_avance.pdf')]

with tempfile.TemporaryDirectory(prefix='p05-latex-') as directory:
    for source, target in TARGETS:
        for _ in range(3):
            result = subprocess.run(['pdflatex', '-interaction=nonstopmode', '-halt-on-error',
                                     '-output-directory=' + directory, source],
                                    cwd=ROOT / 'reporte', capture_output=True, text=True, errors="replace")
            if result.returncode:
                raise SystemExit(result.stdout[-5000:])
        log = (Path(directory) / Path(source).with_suffix('.log')).read_text(errors="replace")
        if 'Overfull' in log:
            raise SystemExit('Hay desbordamientos en ' + source + '; corregir antes de publicar.')
        shutil.copy2(Path(directory) / Path(source).with_suffix('.pdf'), target)
        print(target.relative_to(ROOT))
