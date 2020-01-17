from html.parser import HTMLParser
from html.entities import name2codepoint

class Parser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.recording = False

    def handle_starttag(self, tag, attrs):
        if tag == 'div':
            self.recording = True

    def handle_endtag(self, tag):
        if tag == 'div':
            self.recording = False

    def handle_data(self, data):
        if self.recording:
            return data



    