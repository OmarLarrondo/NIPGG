#!/usr/bin/env python3
"""Genera el PDF único de práctica 06 desde las aportaciones del informe.
Requiere reportlab. Ejecutar con python3 reporte/generar_informe.py.
"""
from pathlib import Path
import re
from xml.sax.saxutils import escape
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak, Table, TableStyle, Preformatted, KeepTogether
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import A4
ROOT=Path(__file__).resolve().parents[1]
MODULO=ROOT/'modulos/01_clientes_tarjetas_partidas'
OUT=ROOT/'Docs/Práctica06.pdf'
fontdir=next(p for p in [Path('/usr/share/fonts/truetype/dejavu'),Path('/usr/share/fonts/dejavu-sans-fonts')] if p.exists())
for n,f in [('DejaVu','DejaVuSans.ttf'),('DejaVu-Bold','DejaVuSans-Bold.ttf'),('DejaVu-Oblique','DejaVuSans-Oblique.ttf'),('DejaVuMono','DejaVuSansMono.ttf')]:
 fontpath=fontdir/f
 if not fontpath.exists():
  fontpath=Path('/usr/share/fonts/liberation-mono-fonts/LiberationMono-Regular.ttf')
 pdfmetrics.registerFont(TTFont(n,str(fontpath)))
pdfmetrics.registerFontFamily('DejaVu',normal='DejaVu',bold='DejaVu-Bold',italic='DejaVu-Oblique')
ink=colors.HexColor('#163047');teal=colors.HexColor('#007f86')
styles=getSampleStyleSheet()
styles.add(ParagraphStyle(name='Texto',fontName='DejaVu',fontSize=9,leading=12.5,spaceAfter=6,textColor=ink))
styles.add(ParagraphStyle(name='H1a',parent=styles['Texto'],fontName='DejaVu-Bold',fontSize=18,leading=23,spaceBefore=6,spaceAfter=16))
styles.add(ParagraphStyle(name='H2a',parent=styles['Texto'],fontName='DejaVu-Bold',fontSize=12,leading=16,spaceBefore=12,spaceAfter=8,keepWithNext=True,textColor=teal))
styles.add(ParagraphStyle(name='H3a',parent=styles['Texto'],fontName='DejaVu-Bold',fontSize=10.3,leading=15,spaceBefore=10,spaceAfter=6,keepWithNext=True))
styles.add(ParagraphStyle(name='Codigo',fontName='DejaVuMono',fontSize=7.2,leading=9,backColor=colors.HexColor('#f0f5f7'),borderPadding=8,spaceBefore=6,spaceAfter=10))
styles.add(ParagraphStyle(name='Celda',parent=styles['Texto'],fontSize=7.5,leading=11,spaceAfter=0))
styles.add(ParagraphStyle(name='Portada',parent=styles['Texto'],fontSize=26,leading=34,fontName='DejaVu-Bold'))
styles.add(ParagraphStyle(name='Sub',parent=styles['Texto'],fontSize=16,leading=23,textColor=teal))
def inline(t):
 t=escape(t)
 t=re.sub(r'\*\*(.*?)\*\*',r'<b>\1</b>',t)
 t=re.sub(r'`(.*?)`',r'<font name="DejaVuMono">\1</font>',t)
 t=re.sub(r'(https://[^\s<]+)',r'<link href="\1" color="#007f86">\1</link>',t)
 return t
story=[]
def para(t,st='Texto'):return Paragraph(inline(t),styles[st])
# Portada común del equipo; datos contrastados con las prácticas 04 y 05.
styles.add(ParagraphStyle(name='Institucion',parent=styles['Texto'],fontName='DejaVu-Bold',fontSize=11,leading=17))
styles.add(ParagraphStyle(name='Etiqueta',parent=styles['Texto'],fontName='DejaVu-Bold',fontSize=9,leading=14,textColor=teal,spaceAfter=9))
styles.add(ParagraphStyle(name='Nombre',parent=styles['Texto'],fontSize=9.5,leading=15,spaceAfter=0))
styles.add(ParagraphStyle(name='Cuenta',parent=styles['Nombre'],alignment=2))
styles.add(ParagraphStyle(name='CabeceraTabla',parent=styles['Nombre'],fontName='DejaVu-Bold',fontSize=8.3,textColor=colors.white))
styles.add(ParagraphStyle(name='CabeceraCuenta',parent=styles['CabeceraTabla'],alignment=2))
story += [Spacer(1,24),para('UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO','Institucion'),
          para('Facultad de Ciencias · Semestre 2027-I'),Spacer(1,35),
          para('FUNDAMENTOS DE BASES DE DATOS','Etiqueta'),
          para('Práctica 06','Portada'),
          para('Mantenimiento de llaves foráneas','Sub'),
          Spacer(1,12),para('Clientes, tarjetas y partidas'),Spacer(1,32),
          para('Equipo ÑIPGG','H2a')]
team=[('Omar Alejandro Juárez Larrondo','322245244'),
      ('Yahir León Bautista','322176542'),
      ('Diego Hernández Gómez','321069942'),
      ('Miguel Ángel Jiménez Ramírez','119000887'),
      ('Ana Lilia Carballido Camacateco','315314601')]
data=[[para('NOMBRE COMPLETO','CabeceraTabla'),para('NÚMERO DE CUENTA','CabeceraCuenta')]]
data += [[para(name,'Nombre'),para(account,'Cuenta')] for name,account in team]
cover_table=Table(data,colWidths=[337,162.2756],hAlign='LEFT')
cover_table.setStyle(TableStyle([
 ('BACKGROUND',(0,0),(-1,0),ink),('VALIGN',(0,0),(-1,-1),'MIDDLE'),
 ('LEFTPADDING',(0,0),(-1,-1),12),('RIGHTPADDING',(0,0),(-1,-1),12),
 ('TOPPADDING',(0,0),(-1,-1),11),('BOTTOMPADDING',(0,0),(-1,-1),11),
 ('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.HexColor('#f0f5f7'),colors.white]),
 ('LINEBELOW',(0,-1),(-1,-1),0.8,teal)]))
story += [cover_table,Spacer(1,28),para('Profesor: Gerardo Avilés Rosas'),
          para('2 de noviembre de 2026'),PageBreak()]

def md(text,skip_intro=True):
 lines=text.splitlines();i=0;buf=[]
 def flush():
  if buf:story.append(para(' '.join(buf)));buf.clear()
 while i<len(lines):
  line=lines[i]
  if line.startswith('# '):
   flush();story.append(para(line[2:],'H1a'));i+=1
   if skip_intro:
    while i<len(lines) and not lines[i].startswith('## '):i+=1
   continue
  if line.startswith('```'):
   flush();i+=1;code=[]
   while i<len(lines) and not lines[i].startswith('```'):
    code.append(lines[i]);i+=1
   # Lines are intentionally wrapped at SQL boundaries for readable print width.
   wrapped=[]
   for l in code:
    while len(l)>89:
     at=l.rfind(' ',0,89)
     if at<20:at=89
     wrapped.append(l[:at]);l='    '+l[at:].lstrip()
    wrapped.append(l)
   block=[Preformatted('\n'.join(wrapped),styles['Codigo'])]
   if code and code[0]=='BEGIN;' and len(story)>=2:
    block=story[-2:]+block;del story[-2:]
   story.append(KeepTogether(block));i+=1;continue
  if line.startswith('|'):
   flush();data=[]
   while i<len(lines) and lines[i].startswith('|'):
    cells=[x.strip() for x in lines[i].strip('|').split('|')]
    if not all(re.fullmatch('[: -]+',x) for x in cells):data.append([para(x,'Celda') for x in cells])
    i+=1
   table=Table(data,colWidths=[240,120,120],repeatRows=1,hAlign='LEFT')
   table.setStyle(TableStyle([('BACKGROUND',(0,0),(-1,0),colors.HexColor('#dceef0')),('VALIGN',(0,0),(-1,-1),'TOP'),('BOTTOMPADDING',(0,0),(-1,-1),7),('TOPPADDING',(0,0),(-1,-1),7),('LINEBELOW',(0,0),(-1,0),1,teal),('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#f4f7f9')])]))
   story.append(table);story.append(Spacer(1,10));continue
  if line.startswith('### '):flush();story.append(para(line[4:],'H3a'))
  elif line.startswith('## '):flush();story.append(para(line[3:],'H2a'))
  elif not line.strip():flush()
  elif re.match(r'^\d+\. ',line):flush();buf.append(line.strip())
  elif line.startswith('- '):
   flush();item=line[2:];i+=1
   while i<len(lines) and lines[i].startswith('  '):item+=' '+lines[i].strip();i+=1
   story.append(para('• '+item));continue
  else:buf.append(line.strip())
  i+=1
 flush()
research=(MODULO/'investigacion.md').read_text()
# El informe expone el contenido académico sin referencias a la organización de trabajo.
research=research.replace('La decisión completa por\nrelación se presenta en la justificación.','La decisión por relación se presenta en la segunda parte.')
research, sources = research.split('## Fuentes oficiales', 1)
md(research)
story.append(PageBreak())
just=(MODULO/'justificacion.md').read_text().split('## Reproducción y evidencia')[0]
just=just.replace('No modifico módulos ajenos.','')
just=just.replace('Yahir\npuede elegir UPDATE CASCADE en sus relaciones si el equipo desea permitir esa\ncorrección a través de todo el historial. La elección debe quedar acordada\nantes de integrar; este módulo no modifica esas FK.','Para permitir esa corrección a través de todo el historial, se debe acordar\nON UPDATE CASCADE en las relaciones de VISITA y RECARGA. Esta validación\nconserva las políticas originales de esas dos tablas.')
just, verification = just.split('## Verificación ejecutada', 1)
md(just)
story.append(PageBreak())
md('# Resultados y referencias\n\n## Verificación ejecutada'+verification+'\n## Fuentes oficiales'+sources, skip_intro=False)
class NumberedCanvas(canvas.Canvas):
 def __init__(self,*args,**kwargs):super().__init__(*args,**kwargs);self.saved=[]
 def showPage(self):self.saved.append(dict(self.__dict__));self._startPage()
 def save(self):
  total=len(self.saved)
  for state in self.saved:
   self.__dict__.update(state)
   self.setStrokeColor(teal);self.line(48, A4[1]-36,A4[0]-48,A4[1]-36)
   if self._pageNumber>1:
    self.setFillColor(ink);self.setFont('DejaVu',6.5)
    self.drawString(48,A4[1]-29,'FUNDAMENTOS DE BASES DE DATOS')
    self.drawRightString(A4[0]-48,A4[1]-29,'MANTENIMIENTO DE LLAVES FORÁNEAS')
   self.setFont('DejaVu',7);self.setFillColor(ink)
   self.drawString(48,24,'Equipo ÑIPGG · Práctica 06')
   self.drawRightString(A4[0]-48,24,f'{self._pageNumber} / {total}')
   super().showPage()
  super().save()
OUT.parent.mkdir(parents=True,exist_ok=True)
doc=SimpleDocTemplate(str(OUT),pagesize=A4,rightMargin=48,leftMargin=48,topMargin=52,bottomMargin=48,title='Práctica 06 - Mantenimiento de llaves foráneas - ÑIPGG',author='Equipo ÑIPGG')
doc.build(story,canvasmaker=NumberedCanvas)
print(OUT)
