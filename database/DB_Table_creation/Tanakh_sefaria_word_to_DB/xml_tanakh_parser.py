import xml.etree.cElementTree as ET
import os
import re
import configparser
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))

current_dir_path = config.get('XML','current_dir')
tanakh_dir_list = os.listdir(current_dir_path)
server = config.get("SQL", "server")
table_names = config.get("SQL", "table_names")
database_name = config.get("SQL", "database_name")
csv_file_name = config.get("CSV", "csv_file_name")

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


def write_csv_file(file_name, textline):
    
    """
    This function will write a new line into csv file in order to Bulk insert into TBL_MASSECHET_WORD table.
    :param file_name: the csv file name
    :param textline: the string that will be appended to the csv file
    """
    with open(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name), "a", encoding='utf-8') as f:
        f.write(f"{textline}\r")  
        


def get_perek_pasuk_id(chapter_num, verse_num, book):
    execute_query(f"USE {database_name};")
    query = f"""SELECT PP.PEREK_PASUK_ID,A.PEREK_NUM, PA.PASUK_NUM, S.SEFER_ENGLISH_NAME FROM TBL_TANAKH_PEREK_PASUK PP 
                JOIN TBL_TANAKH_PASUK PA ON PA.PASUK_ID = PP.PASUK_ID
                JOIN
                (
                SELECT PE.SEFER_PEREK_ID,PE.SEFER_ID,P.PEREK_NUM FROM TBL_TANAKH_SEFER_PEREK PE
                JOIN TBL_TANAKH_PEREK P ON PE.PEREK_ID = P.PEREK_ID
                )AS A
                ON A.SEFER_PEREK_ID = PP.SEFER_PEREK_ID
                JOIN TBL_TANAKH_SEFER S ON S.SEFER_ID = A.SEFER_ID AND A.SEFER_PEREK_ID = PP.SEFER_PEREK_ID
                WHERE PA.PASUK_NUM = '{verse_num}' AND A.PEREK_NUM = '{chapter_num}' AND S.SEFER_ENGLISH_NAME = '{book}' """
    
    result_query = execute_query(query)
    
    perek_pasuk_id = ''

    for row in result_query:
        perek_pasuk_id = row[0]
        

    return perek_pasuk_id        



def get_xml_word_and_attributes(xml):
        
        tree = ET.ElementTree(file=current_dir_path + '\\' + xml)
        
        for elem in tree.findall('Word'):
            
            attributes = elem.attrib
            
            perek_pasuk_id = get_perek_pasuk_id(attributes.get('Chapter'),attributes.get('Verse'),attributes.get('Book'))
            
            word_position = attributes.get('WordSequence') 

            if attributes.get('Ktiv') == 'true':
                isKtiv = 1
            else:
                isKtiv = 0
            if attributes.get('Kri') == 'true':
                isKri = 1
            else:
                isKri = 0  
                  
            words = elem.text
            
            full_word = re.sub('[\[\]\(\)]+','',words)
            
            word = re.sub('[^א-ת־]+','',words)
            
            textline = f"|{perek_pasuk_id}|{word_position}|{isKtiv}|{isKri}|{word}|{full_word}"   
            
            print(textline)
        
            write_csv_file(csv_file_name,textline)    
            
            
for xml in tanakh_dir_list:

    get_xml_word_and_attributes(xml) 



def bulk_insert_to_tbl(csv_file_name, tbl_name):
    execute_query(f"USE {database_name};")
    execute_query(f"SET IDENTITY_INSERT {tbl_name} ON;")
    query = f"BULK INSERT {tbl_name} \
            FROM '{csv_file_name}' \
            WITH \
                (  \
                     FIELDTERMINATOR ='|' \
                    , ROWTERMINATOR ='\r' \
                    ,CODEPAGE = '65001' \
                );"
    execute_query(f"SET IDENTITY_INSERT {tbl_name} OFF;")

    execute_query(query)
    

def main():
    
    for xml in tanakh_dir_list:
    
        get_xml_word_and_attributes(xml)
    
    bulk_insert_to_tbl(csv_file_name, table_names)  

    if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name)):
            os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name))

if __name__ == '__main__':
    main()