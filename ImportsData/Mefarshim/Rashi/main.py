import os
import re
import configparser
from bs4 import BeautifulSoup
import codecs
import ParseMy

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))

html_path = config.get('HTML','html_path')
xml_path = config.get('XML','xml_path')


def write_xml(xml_file_name, file, textline):
    
    with codecs.open(os.path.join(xml_file_name,file), "a", encoding='utf-8') as f:
        f.write(f"{textline}\r")


def remove_blank(line_list):
    new_list = []
    line_list = re.sub(r"[\r\n]+", " ", line_list)
    line_list = line_list.replace(".",'')
    line_list = re.sub(r"\"","&quot;",line_list)
    line_list = line_list.strip()
    if len(line_list) > 0:
        new_list.append(line_list)
        return new_list[0]


def built_xml_header(massechet_daf_path,html_file,folder):
    
    with open(massechet_daf_path, "r",encoding='utf-8') as f:

        daf = f.read()
        soup = BeautifulSoup(daf, 'html.parser')

        massechet_name = soup.find_all("title")[0]
        
        if massechet_name.parent.name == 'head':
            
            massechet_name = re.search('(?<= מסכת).*(?= דף)',str(massechet_name)).group()
            daf_amud = re.sub('^(.*?)\.','',html_file)
            daf_amud = daf_amud.replace('.html','').split('.')
            html_file = html_file.replace('.html','.xml') 
            write_xml(xml_path + '\\' + folder,html_file,"<root>\n<massechet name="+massechet_name+">\n\t<daf value="+daf_amud[0]+">\n\t\t<amud value="+daf_amud[1]+">")

def built_xml_content(massechet_daf_path,folder,html_file):
    
    with open(massechet_daf_path, "r",encoding='utf-8') as f:

        html_file = html_file.replace('.html','.xml')
        soup = BeautifulSoup(f, 'html.parser')
        
        shastext3 = soup.find("div", {"class": "shastext3"})
        
        shastitle7 = ''
        content = ''
        
        for index,tags in enumerate(shastext3):
            
            if tags.name == 'span':
                
                if tags['class'][0] == 'shastitle7':
                    shastitle7 = tags.text
                    continue
                
                if tags['class'][0] == 'five':
                    if shastitle7 != '':
                        text = remove_blank(shastitle7+' '+tags.text).replace('  ',' ')
                        textline = f'<StartDibourHamatril name ="{text}"/>'
                        write_xml(xml_path + '\\' + folder,html_file,textline)
                        shastitle7 = ''
                    else:
                        text = remove_blank(tags.text)
                        textline = f'<StartDibourHamatril name ="{text}"/>'
                        write_xml(xml_path + '\\' + folder,html_file,textline)
                                        
                if tags['class'][0] == 'mareimakom':
                    content += ' ' + tags.text
                    continue
                
            if tags.name == None:
                #print(tags,end)
                text = remove_blank(tags)
                #print(text)
                if text != None and re.search(':',text):
                    text = text.replace(": הכי גרסי'",':')
                    no_word = re.search(r':[\s]*([א-ת-&quot;-\]]+)',text)     
                    if no_word != None:
                        text = re.sub(':[\s]*([א-ת-&quot;-\]]+)','',text)      
                        text = re.sub('$',':',text)      
                    content += ' '+ text
                    content = content.replace('  ',' ').replace(' :',':')
                    write_xml(xml_path + '\\' + folder,html_file,content)
                    write_xml(xml_path + '\\' + folder,html_file,'<EndDibourHamatril/>')
                    content = ''
                    continue
                if text != None:
                    content += ' ' + text
                    
def built_xml_footer(massechet_daf_path,folder,html_file):

        html_file = html_file.replace('.html','.xml')
        footer = '</amud>\n</daf>\n</masechet>\n</root>'
        write_xml(xml_path + '\\' + folder,html_file,footer)


def main ():
    
    for folder in os.listdir(html_path):
        
        if not os.path.exists(xml_path+ '\\' + folder):
            os.makedirs(xml_path + '\\' + folder)

        for html_file in os.listdir(f"{html_path}\\{folder}"):
            massechet_daf_path = f"{html_path}\\{folder}\\{html_file}"
            built_xml_header(massechet_daf_path,html_file,folder)
            built_xml_content(massechet_daf_path,folder,html_file)
            built_xml_footer(massechet_daf_path,folder,html_file)

          
if __name__ == '__main__':
    main()
