# myparser module

from html.parser import HTMLParser
from html.entities import name2codepoint


class MyHTMLParser(HTMLParser):
  def __init__(self, divtype):
    HTMLParser.__init__(self)
    self.recording = False
    self.data = []
    self.return_string = ""
    self.significant_tag_name = 'div'

  def handle_starttag(self, tag, attributes):
    if tag == self.significant_tag_name:
        for name, value in attributes:
            if name == 'class' and value == 'shastext2':
                self.recording = True
    elif tag == 'fieldset' and self.recording == True:
                self.recording = False


  def handle_endtag(self, tag):
    if tag == 'div' and self.recording and str(self.data)=="\\r\\n":
      self.recording = False


  def handle_data(self, data):
    if self.recording:
        if str(data) != '\\r\\n':
            data_string = str(data).replace('\\r\\n','').replace('\\r','').replace('\\','').replace(' כ] ',' ').replace(' כא] ',' ').replace(' כב] ',' ').replace(' כג] ',' ').replace(' כד] ',' ').replace(' כה] ',' ').replace(' כו] ',' ').replace(' כז] ',' ').replace(' כח] ',' ').replace(' כט] ',' ').replace(' י] ',' ').replace(' ט] ',' ').replace(' ח] ',' ').replace(' ז] ',' ').replace(' ו] ',' ').replace(' ה] ',' ').replace(' ד] ',' ').replace(' ג] ',' ').replace(' ב] ',' ').replace(' א] ', ' ').replace(' (ו) ',' ').replace(' (ג) ',' ').replace(' (ז) ',' ').replace(' (ל) ',' ').replace(' (א) ',' ').replace(' יא] ',' ').replace(' יב] ',' ').replace(' יג] ',' ').replace(' יד] ',' ').replace(' טו] ',' ').replace(' טז] ',' ').replace(' יז] ',' ').replace(' יח] ',' ').replace(' יט] ',' ').replace(' לז] ',' ').replace(' לח] ',' ').replace(' לט] ',' ').replace(' לד] ',' ').replace(' לג] ',' ').replace(' לב] ',' ').replace(' לא] ',' ').replace(' ל] ',' ').replace('[ע]','').replace('[נ]','').replace('[ל]','').replace('[כ]','').replace('[יט]','').replace('[יח]','').replace('[יז]','').replace('[טז]','').replace('[טו]','').replace('[י]','').replace('[ט]',' ').replace('[ח]',' ').replace('[ז]',' ').replace('[ו]',' ').replace('[ה]','').replace('[ד]','').replace('[ג]','').replace('[ב]','').replace('[א]','').replace('*', '').rstrip()
            self.return_string += data_string

