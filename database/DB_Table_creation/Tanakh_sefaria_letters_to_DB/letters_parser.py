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

def write_csv_file(file_name, textline):
    
    """
    This function will write a new line into csv file in order to Bulk insert into TBL_MASSECHET_WORD table.
    :param file_name: the csv file name
    :param textline: the string that will be appended to the csv file
    """
    with open(file_name, "a", encoding='utf-8') as f:
        f.write(f"{textline}\r")


def bulk_insert_to_tbl(csv_file_path, tbl_name):
    execute_query(f"USE {database_name};")
    execute_query(f"SET IDENTITY_INSERT {tbl_name} ON;")
    query = f"BULK INSERT {tbl_name} \
            FROM '{csv_file_path}' \
            WITH \
                (  \
                     FIELDTERMINATOR ='|' \
                    , ROWTERMINATOR ='\r' \
                    ,CODEPAGE = '65001' \
                );"
    execute_query(f"SET IDENTITY_INSERT {tbl_name} OFF;")

    execute_query(query)




def get_word_id(book,chapter,verse,wordSequence):
    execute_query(f"USE {database_name};")
    query = f"""SELECT TW.WORD_ID FROM TBL_TANAKH_WORD TW
                JOIN TBL_TANAKH_PEREK_PASUK PP ON PP.PEREK_PASUK_ID = TW.PEREK_PASUK_ID
                JOIN TBL_TANAKH_PASUK PA ON PA.PASUK_ID = PP.PASUK_ID
                JOIN TBL_TANAKH_SEFER_PEREK SP ON SP.SEFER_PEREK_ID = PP.SEFER_PEREK_ID
                JOIN TBL_TANAKH_PEREK PE ON PE.PEREK_ID = SP.PEREK_ID
                JOIN TBL_TANAKH_SEFER S ON S.SEFER_ID = SP.SEFER_ID
                WHERE PA.PASUK_NUM = '{verse}' AND PE.PEREK_NUM = '{chapter}' AND  TW.WORD_POSITION = '{wordSequence}' AND S.SEFER_ENGLISH_NAME = '{book}'"""        
    
    result_query = execute_query(query)
    
    get_word_id = ''
    
    for row in result_query:
           get_word_id = row[0]
    
    return get_word_id

def get_ref_letter_id(letter):
    execute_query(f"USE {database_name};")
    query = f"SELECT LETTER_ID FROM TBL_REF_LETTER WHERE UNICODE_VALUE = '{letter}'"

    result_query = execute_query(query)
    
    get_ref_letter_id = ''
    
    for row in result_query:
       get_ref_letter_id = row[0]
    
    return get_ref_letter_id

def get_ref_nikkud_id(nikkud):
    execute_query(f"USE {database_name};")
    query = f"SELECT NIKKUD_ID FROM TBL_REF_NIKKUD WHERE UNICODE_VALUE = '{nikkud}'"
        
    result_query = execute_query(query)
    
    get_ref_nikkud_id = []
    
    for row in result_query:
        get_ref_nikkud_id.append(row[0])  

    return get_ref_nikkud_id

def get_ref_taam_id(taam):
    execute_query(f"USE {database_name};")
    query = f"SELECT TAAM_ID FROM TBL_REF_TAAM WHERE UNICODE_VALUE= '{taam}'"
    
    result_query = execute_query(query)
    
    get_ref_taam_id = []
    
    for row in result_query:
        get_ref_taam_id.append(row[0])
  
    return get_ref_taam_id  


def get_letter_nikkud_taam():
    
    letter_id = 0
    
    for xml in os.listdir(current_dir_path):
        
        tree = ET.ElementTree(file=current_dir_path + '\\' + xml)

        # Loop over each xml tag 'Word'

        for elem in tree.findall('Word'):

            word_id = get_word_id(elem.attrib.get('Book'),elem.attrib.get('Chapter'),elem.attrib.get('Verse'),elem.attrib.get('WordSequence'))

            if elem.attrib.get('Kri') == 'true':
                continue
            
            if elem.attrib.get('Ktiv') == 'true':
                elem.text = re.sub('\[|\]','',elem.text)            

            if re.match('[\(\)]',elem.text):
                elem.text = re.sub('[\(\)]','',elem.text) 

            count = 1

            text = list(elem.text)

            shuruk = False

            cholam = False

            mapiq = False
            
            is_tere_kadmin = False

            print(elem.attrib.get('Book'),elem.attrib.get('Chapter'),elem.attrib.get('Verse'),elem.attrib.get('WordSequence'),elem.text)

            # Loop over each letter, taam and nikkud of word

            for index,item in enumerate(text): 
                
                if re.match('[א-ת-׆]',item):

                    # check if there is a shuruk or cholam after the letter Vav

                    if re.match('[ו]',item) and index < len(text)-1:

                        # check if the next item is a shuruk or cholam with the unicode format

                        next_item = str(text[index+1].encode('unicode_escape')).upper()
                        next_item2 = re.sub("(B'\\\\)|('$)",'',next_item)
                        next_item3 = next_item2.replace('\\','').replace('U','U+')

                        if next_item3 == 'U+05BC':
                            shuruk = True
                            continue
                        
                        if next_item3 == 'U+05B9':
                            cholam = True
                            continue
                        
                    # check for the next item if it's preceded by 'ה' for the mapiq

                    if re.match('[ה]',item):
                        mapiq = True   

                    unicode_letter = str(item.encode('unicode_escape')).upper()
                    unicode_letter2 = re.sub("(B'\\\\)|('$)",'',unicode_letter)
                    unicode_letter3 = unicode_letter2.replace('\\','').replace('U','U+')

                    ref_letter_id = get_ref_letter_id(unicode_letter3)
                    letter_position_in_word = count 
                    letter_id += 1
                    textline1 = f"|{word_id}|{ref_letter_id}|{letter_position_in_word}" 
                    write_csv_file(csv_file_name_letter,textline1)
                    count +=1       

                # get the unicode format of each taam or nikkud

                items = str(item.encode('unicode_escape')).upper()
                items2 = re.sub("(B'\\\\)|('$)",'',items)
                items3 = items2.replace('\\','').replace('U','U+')


                if get_ref_nikkud_id(items3) != [] or cholam == True:
                    if shuruk == True:
                        nikkud_id = 8
                        shuruk = False
                        textline2 = f"|{letter_id}|{nikkud_id}" 
                        write_csv_file(csv_file_name_nikkud,textline2)
                        continue
                    if cholam == True:
                        nikkud_id = 7 
                        cholam = False
                        textline2 = f"|{letter_id}|{nikkud_id}" 
                        write_csv_file(csv_file_name_nikkud,textline2)  
                        continue 
                    if mapiq == True:
                        nikkud_id = 15
                        mapiq = False
                        textline2 = f"|{letter_id}|{nikkud_id}" 
                        write_csv_file(csv_file_name_nikkud,textline2)
                        continue
                    else:
                        nikkud_id = get_ref_nikkud_id(items3)[0]          
                        textline2 = f"|{letter_id}|{nikkud_id}" 
                        write_csv_file(csv_file_name_nikkud,textline2)
                        continue
                    
                if get_ref_taam_id(items3) != []:
                    taam_id = get_ref_taam_id(items3)[0]
                    
                    last_item = str((text[-1]).encode('unicode_escape')).upper()
                    last_item2 = re.sub("(B'\\\\)|('$)",'',last_item)
                    last_item3 = last_item2.replace('\\','').replace('U','U+')
                    
                    # check if the last item is a pashta or not to define if it's a tere kadmin
                    
                    if taam_id == 10 and last_item3 == 'U+0599' and index < len(text)-1:
                        is_tere_kadmin = True
                        continue 
                    if is_tere_kadmin == True:
                        is_tere_kadmin = False
                        taam_id = 11               
                    textline3 = f"|{letter_id}|{taam_id}"
                    write_csv_file(csv_file_name_taam,textline3)
                    continue
            
               
            
        
        
def main():
    
    get_letter_nikkud_taam()            
        
    bulk_insert_to_tbl(csv_file_name_letter, table_names[0])
    bulk_insert_to_tbl(csv_file_name_nikkud, table_names[1])
    bulk_insert_to_tbl(csv_file_name_taam, table_names[2])


    if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_letter)):
        os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_letter))

    if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_nikkud)):
        os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_nikkud))

    if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_taam)):
        os.remove(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name_taam))

if __name__ == '__main__':
    main()