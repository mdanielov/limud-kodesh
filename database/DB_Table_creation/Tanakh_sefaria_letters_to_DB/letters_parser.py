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
csv_file_name = os.path.join(os.path.abspath(os.path.dirname(__file__))) + "\\" + config.get('CSV','csv_file_name')

if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name)):
    os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name))
    
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


def get_word_id(word,book,chapter,verse,wordSequence):
    
    query = f"""SELECT TW.WORD_ID FROM TBL_TANAKH_WORD TW
            JOIN TBL_TANAKH_PEREK_PASUK PP ON PP.PEREK_PASUK_ID = TW.PEREK_PASUK_ID
            JOIN TBL_TANAKH_PASUK TP ON TP.PASUK_ID = PP.PASUK_ID
            JOIN TBL_TANAKH_PEREK TPE ON TPE.PEREK_ID = PP.SEFER_PEREK_ID
            JOIN TBL_TANAKH_SEFER_PEREK TSP ON TSP.SEFER_PEREK_ID = PP.SEFER_PEREK_ID
            JOIN TBL_TANAKH_SEFER TS ON TS.SEFER_ID = TSP.SEFER_ID
            WHERE TW.WORD = '{word}' AND TW.WORD_POSITION = '{wordSequence}' AND TP.PASUK_NUM ='{verse}' AND TPE.PEREK_NUM ='{chapter}' AND TS.SEFER_HEBREW_NAME = '{book}'"""        


def get_ref_letter_id(letter):
    
    query = f"SELECT LETTER_ID FROM TBL_REF_LETTER WHERE LETTER = '{letter}'"

    #result_query = execute_query(query)
    #
    #for row in result_query:
    #    get_ref_letter_id = row[0]
    #
    #return get_ref_letter_id

def get_ref_nikkud_id(nikkud):
    
    query = f"SELECT NIKKUD_ID FROM TBL_REF_NIKKUD WHERE NIKKUD = '{nikkud}'"
    
    for row in result_query:
        get_ref_nikkud_id = row[0]
        
    return get_ref_nikkud_id

def get_ref_taam_id(taam):
    
    query = f"SELECT TAAM_ID FROM TBL_REF_TAAM WHERE TAAM= '{taam}'"
    
    for row in result_query:
        get_ref_taam_id = row[0]
        
    return get_ref_taam_id  


def get_letter_nikkud_taam(xml):
    
    tree = ET.ElementTree(file=current_dir_path + '\\' + xml)
    
    letter_id = 1
    
    for elem in tree.findall('Word'):
        
        word_id = get_word_id(elem.text,elem.attrib.get('Book'),elem.attrib.get('Chapter'),elem.attrib.get('Verse'),elem.attrib.get('WordSequence'))

        count = 1
        
        for index,item in enumerate(elem.text):
            
            if re.match('[א-ת]',item):
                ref_letter_id = get_ref_letter_id(item)
                letter_position_in_word = count 
                textline1 = f"|{word_id}|{ref_letter_id}|{letter_position_in_word}"    
                count +=1       
                continue
                
            items = str(item.encode('unicode_escape')).upper()
            items2 = re.sub("(B'\\\\)|('$)",'',items)
            items3 = items2.replace('\\','').replace('U','U+')
            
            if get_ref_nikkud_id(items3) != '':
                
                nikkud_id = get_ref_nikkud_id(items3)
                
                textline2 = f"|{letter_id}|{nikkud_id}" 
            
            else:
                
                taam_id = get_letter_nikkud_taam(items3)
                
                textline3 = f"|{letter_id}|{taam_id}"   
            
        letter_id += 1
            
           
            
get_letter_nikkud_taam('test.xml')            
        
    
     

