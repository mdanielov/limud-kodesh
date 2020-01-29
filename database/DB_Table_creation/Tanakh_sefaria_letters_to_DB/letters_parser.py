import xml.etree.cElementTree as ET
import os
import re
import configparser
import pyodbc
from hebrew_numbers import int_to_gematria


config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))
current_dir_path = config.get('XML', 'current_dir')
tanakh_dir_list = os.listdir(current_dir_path)
server = config.get("SQL", "server")
table_names = config.get("SQL", "table_names").split(',')
database_name = config.get("SQL", "database_name")
csv_file_name_letter = os.path.join(os.path.abspath(os.path.dirname(__file__))) + "\\" + config.get('CSV','csv_file_name_letter')
csv_file_name_nikkud = os.path.join(os.path.abspath(os.path.dirname(__file__))) + "\\" + config.get('CSV','csv_file_name_nikkud')
csv_file_name_taam = os.path.join(os.path.abspath(os.path.dirname(__file__))) + "\\" + config.get('CSV','csv_file_name_taam')


if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_letter)):
    os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_letter))

if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_nikkud)):
    os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_nikkud))
    
if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_letter)):
    os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_nikkud))
    
    
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                                           'Database=' + database_name + ';'
                                                                         'Trusted_Connection=yes;',
                      autocommit=True, encoding='utf-8')
 
def execute_query(query):
    with conn:
        cursor = conn.cursor()
        cursor.execute(query)
    return cursor


execute_query(f"USE {database_name};")

def write_csv_file(file_name, textline):
    
    """
    This function will write a new line into csv file in order to Bulk insert into TBL_MASSECHET_WORD table.
    :param file_name: the csv file name
    :param textline: the string that will be appended to the csv file
    """
    with open(file_name, "a", encoding='utf-8') as f:
        f.write(f"{textline}\r")


def get_word_id(book,chapter,verse,wordSequence):
    
    query = f"""SELECT TW.WORD_ID FROM TBL_TANAKH_WORD TW
                JOIN TBL_TANAKH_PEREK_PASUK PP ON PP.PEREK_PASUK_ID = TW.PEREK_PASUK_ID
                JOIN TBL_TANAKH_PASUK PA ON PA.PASUK_ID = PP.PASUK_ID
                JOIN TBL_TANAKH_SEFER_PEREK SP ON SP.SEFER_PEREK_ID = PP.SEFER_PEREK_ID
                JOIN TBL_TANAKH_PEREK PE ON PE.PEREK_ID = SP.PEREK_ID
                JOIN TBL_TANAKH_SEFER S ON S.SEFER_ID = SP.SEFER_ID
                WHERE PA.PASUK_NUM = '{verse}' AND PE.PEREK_NUM = '{chapter}' AND  TW.WORD_POSITION = '{wordSequence}' AND S.SEFER_ENGLISH_NAME = '{book}'"""        
    
    result_query = execute_query(query)
    
    for row in result_query:
           get_word_id = row[0]
    
    return get_word_id

def get_ref_letter_id(letter):
    
    query = f"SELECT LETTER_ID FROM TBL_REF_LETTER WHERE LETTER = '{letter}'"

    result_query = execute_query(query)
    
    get_ref_letter_id = ''
    
    for row in result_query:
       get_ref_letter_id = row[0]
    
    return get_ref_letter_id

def get_ref_nikkud_id(nikkud):
    
    query = f"SELECT NIKKUD_ID FROM TBL_REF_NIKKUD WHERE UNICODE_VALUE = '{nikkud}'"
    print(query)
    
    result_query = execute_query(query)
    
    get_ref_nikkud_id = []
    
    for row in result_query:
        get_ref_nikkud_id.append(row[0]) 
    
    return get_ref_nikkud_id

def get_ref_taam_id(taam):
    
    query = f"SELECT TAAM_ID FROM TBL_REF_TAAM WHERE UNICODE_VALUE= '{taam}'"
    
    result_query = execute_query(query)
    
    get_ref_taam_id = []
    
    for row in result_query:
        get_ref_taam_id.append(row[0])
        
    return get_ref_taam_id  


def get_letter_nikkud_taam(xml):
    
    tree = ET.ElementTree(file=current_dir_path + '\\' + xml)
    
    letter_id = 1
    
    for elem in tree.findall('Word'):
        
        word_id = get_word_id(elem.attrib.get('Book'),elem.attrib.get('Chapter'),elem.attrib.get('Verse'),elem.attrib.get('WordSequence'))

        count = 1
        
        text = list(elem.text)
        
        for index,item in enumerate(text):
           
            print(text[index])
           
            if re.match('[א-ת]',item):
                ref_letter_id = get_ref_letter_id(item)
                letter_position_in_word = count 
                textline1 = f"|{word_id}|{ref_letter_id}|{letter_position_in_word}" 
                write_csv_file(csv_file_name_letter,textline1)
                count +=1       
                continue
                
            items = str(item.encode('unicode_escape')).upper()
            items2 = re.sub("(B'\\\\)|('$)",'',items)
            items3 = items2.replace('\\','').replace('U','U+')
            
            if get_ref_nikkud_id(items3) != []:
                nikkud_id = get_ref_nikkud_id(items3)
                print(nikkud_id)
                if index > 0 and nikkud_id == [8,14]:
                    if text[index-1] == 'ו':
                        nikkud_id = 8
                    else:
                        nikkud_id = 14
                textline2 = f"|{letter_id}|{nikkud_id}" 
                write_csv_file(csv_file_name_nikkud,textline2)

            else:
                taam_id = get_ref_taam_id(items3)
                textline3 = f"|{letter_id}|{taam_id}"
                write_csv_file(csv_file_name_taam,textline3)
                 
                 
        letter_id += 1
            
           
            
get_letter_nikkud_taam('test.xml')            
        
    
     

