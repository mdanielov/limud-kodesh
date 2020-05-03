import os
import re
import configparser
from bs4 import BeautifulSoup
import codecs


config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))

html_path = config.get('HTML','html_path')
xml_path = config.get('XML','xml_path')


def write_xml(xml_file_name, textline):

    with codecs.open(os.path.join(xml_path, xml_file_name), "a", encoding='utf-8') as f:
        f.write(f"{textline}\r")  

    
def built_xml(html):
    
    xml = html.replace('.htm','.xml')
    
    with open(html_path + '\\' + html, "r",encoding='Windows-1255') as f:
        page = f.read()
        soup = BeautifulSoup(page, 'html.parser')
        title = soup.title.string.split()
        title = re.search(r'(?<=מסכת)[^.]*',soup.title.string)
        title = re.sub('^\s','',title.group())
        start_massechet = '<StartMassechet name="{}"/>'.format(title)
        first_perek = '<StartPerek number="{}"/>'.format(1)
        write_xml(xml,'<root>')
        write_xml(xml,start_massechet)
        write_xml(xml,first_perek)
        
        prakim = soup.find_all('h2')
        
        for index,perek in enumerate(prakim):
            
            halacha_num = 1
            
            inMishna = False
            
            inGuemara = False
            
            inHalacha = False
            
            for tag in soup.find_all("h2")[index].next_siblings:
                
                if tag.name == "h2":
                    
                    end_perek = '<EndPerek number="{}"/>'.format(index+1)
                    start_perek = '<StartPerek number="{}"/>'.format(index+2)
                    write_xml(xml,end_perek)
                    write_xml(xml,start_perek)
                    break
                
                if tag.name != "h2":
                    
                    if tag.name == 'p':
                        
                        def replace(match):
                            match = match.group()
                            return match.replace('<ס"א','(').replace('<בס"א','(').replace('[בס"א','[').replace('>',')').replace('( ','(').replace('[ ','[')
                        
                        content = tag.find(text=True, recursive=False)
                        content = content.replace('\n','').replace('.  ','.').replace('\r','')
                        content = re.sub('\(.*\)','',content)
                        content = re.sub('<ס"א(.*?)>',replace,content)
                        content = re.sub('<בס"א(.*?)>',replace,content)
                        content = re.sub('\[בס"א(.*?)\]',replace,content)
                        content = content.replace('<','[').replace('>',']').replace('  ',' ')
                        content = content.strip()
                        
                        for index2,tag in enumerate(tag.children):
                                                    
                            if tag.name == 'b':
                                
                                if re.search(r"\bמשנה\b",tag.text) and re.search(r":$",content) and inMishna == False and inHalacha == False:
                                    title_start = '<StartHalacha number="{}"/>\n<StartMishna/>'.format(str(halacha_num))
                                    halacha_num +=1
                                    title_end = '<EndMishna/>'
                                    inHalacha = True
                                    write_xml(xml,title_start)
                                    write_xml(xml,content)
                                    write_xml(xml,title_end)
                                    continue
                                
                                if re.search(r"\bמשנה\b",tag.text) and inMishna == False and inHalacha == False:
                                    title_start = '<StartHalacha number="{}"/>\n<StartMishna/>'.format(str(halacha_num))
                                    halacha_num +=1
                                    inHalacha = True
                                    inMishna = True
                                    write_xml(xml,title_start)
                                    write_xml(xml,content)
                                    continue
                                
                                if re.search(r"\bמשנה\b",tag.text) and re.search(r":$",content) and inMishna == False and inHalacha == True:
                                    title_start = '<EndHalacha number="{}"/>\n<StartHalacha number="{}"/>\n<StartMishna/>'.format(str(halacha_num-1),str(halacha_num))
                                    halacha_num +=1
                                    title_end = '<EndMishna/>'
                                    inHalacha = True
                                    write_xml(xml,title_start)
                                    write_xml(xml,content)
                                    write_xml(xml,title_end)
                                    continue
                                
                                if re.search(r"\bמשנה\b",tag.text) and inMishna == False and inHalacha == True:
                                    title_start = '<EndHalacha number="{}"/>\n<StartHalacha number="{}"/>\n<StartMishna/>'.format(str(halacha_num -1),str(halacha_num))
                                    halacha_num +=1
                                    inHalacha = True
                                    inMishna = True
                                    write_xml(xml,title_start)
                                    write_xml(xml,content)
                                    continue
                                
                                if re.search(r"\bמשנה\b",tag.text) and re.search(r":$",content) and inMishna == True:
                                    title_end = '<EndMishna/>'
                                    write_xml(xml,content)
                                    write_xml(xml,title_end)
                                    inMishna = False
                                    continue
                                
                                if re.search(r"\bגמרא\b",tag.text) and re.search(r":$",content) and inGuemara == False:
                                    title_start = '<StartGuemara/>'
                                    title_end = '<EndGuemara/>\n<EndHalacha number="{}"/>'.format(str(halacha_num -1))
                                    inHalacha = False
                                    write_xml(xml,title_start)
                                    write_xml(xml,content)
                                    write_xml(xml,title_end)
                                    continue
                                
                                if re.search(r"\bגמרא\b",tag.text) and inGuemara == False:
                                    title_start = '<StartGuemara/>'
                                    inGuemara = True
                                    write_xml(xml,title_start)
                                    write_xml(xml,content)
                                    continue
                                
                                if re.search(r"\bגמרא\b",tag.text) and re.search(r":$",content) and inGuemara == True:
                                    title_end = '<EndGuemara/>\n<EndHalacha number="{}"/>'.format(str(halacha_num -1))
                                    inHalacha = False
                                    write_xml(xml,content)
                                    write_xml(xml,title_end)
                                    inGuemara = False
                                    continue
                                
                                if re.search(r"\bגמרא\b",tag.text) and inGuemara == True:
                                    write_xml(xml,content)
                                    
        
        if inHalacha == True:
            last_tag = '<EndHalacha number="{}"/>'.format(str(halacha_num -1))
            write_xml(xml,last_tag)
        
                                       
        last_perek = '<EndPerek number="{}"/>'.format(len(prakim))
        end_massechet = '<EndMassechet name="{}"/>'.format(title)
        write_xml(xml,last_perek)
        write_xml(xml,end_massechet)
        write_xml(xml,'</root>')    
              
    
def main():
    
    for html in os.listdir(html_path):
        if html.endswith('.htm'):
            built_xml(html)          
        
if __name__ == '__main__':
    main()
    
    
        





            
            
                          
            
    
