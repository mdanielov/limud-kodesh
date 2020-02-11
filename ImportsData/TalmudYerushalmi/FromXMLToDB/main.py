import xml.etree.cElementTree as ET
import os
import configparser
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))

parent_dir_path = config.get('XML', 'parent_dir')
massechet_dir_list = os.listdir(parent_dir_path)
server = config.get("SQL", "server")
table_names = config.get("SQL", "table_names").split(',')
database_name = config.get("SQL", "database_name")
csv_file_name = os.path.join(os.path.abspath(os.path.dirname(__file__))) + "\\" + "temp_csv_insert.csv"

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


def get_massechet_id(massechet_name):
    """
    This function will get the MASSECHET_ID Foreign key from the reference table TBL_MASSECHET according to
    the massechet name.
    :param massechet_name: the actual massechet name
    :return: MASSECHET_ID
    """
    
    execute_query(f"USE {database_name};")
    
    query = f"SELECT MASSECHET_ID FROM TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"

    result_query = execute_query(query)

    for row in result_query:
        massechet_id = row[0]

    return massechet_id

def get_massechet_perek_id(massechet_name):
    """
    This function will get the MASSECHET_PEREK_ID Foreign key from the reference table TBL_YERUSHALMI_MASSECHET_PEREK according to
    the massechet name.
    :param massechet_name: the actual massechet name
    :return: MASSECHET_PEREK_ID
    """
    execute_query(f"USE {database_name};")
    
    query = f"SELECT T1.MASSECHET_PEREK_ID FROM {table_names[0]} T1 JOIN TBL_MASSECHET T2 ON T2.MASSECHET_ID = T1.MASSECHET_ID WHERE T2.MASSECHET_NAME = '{massechet_name}'"
    
    result_query = execute_query(query)
    
    massechet_perek_id = []

    for row in result_query:
        massechet_perek_id.append(row[0])

    return massechet_perek_id
    
    

def get_xml_values(massechet_dir_path, chapter, count_chapter,halacha):
    
    
    tree = ET.ElementTree(file=massechet_dir_path)
    
    for elem in tree.iter():
        
        if elem.tag == 'StartMassechet':
            massechet_name = elem.attrib['name']
        
        if elem.tag == 'StartPerek':
            halacha_num = 1
            chapter.append(elem.attrib['number'])
            count_chapter += 1
            halacha['chapter'+str(count_chapter)] = []
        
        if elem.tag == 'StartHalacha':
            halacha['chapter'+str(count_chapter)].append(halacha_num)
            halacha_num += 1 
            
    return massechet_name, chapter, count_chapter,halacha       

def main():
    
    # i = 1
    # while i < 17:
    #     execute_query(f"USE {database_name};")
    #     query = f"""INSERT INTO {table_names[1]} ([HALACHA_NUM],[HALACHA_NAME]) VALUES ({i},'{int_to_gematria(i,gershayim=False)}')"""
    #     execute_query(query)
    #     i += 1
    
    
    for xml in massechet_dir_list: 
        
        count_chapter = 0
        halacha = {}
        chapter = []
        
        massechet_dir_path = parent_dir_path + "\\" + xml
        result = get_xml_values(massechet_dir_path,chapter,count_chapter,halacha)
        
        massechet_name = result[0]
        chapter = result[1]
        halacha = result[3]
        
    massechet_id = get_massechet_id(massechet_name)
    
    massechet_perek_id = get_massechet_perek_id(massechet_name)
    
    # i = 0
    # while i < len(chapter):
    #     execute_query(f"USE {database_name};")
    #     query = f"""INSERT INTO {table_names[0]} ([MASSECHET_ID],[PEREK_NUM],[PEREK_NAME]) VALUES ({massechet_id},{chapter[i]},'{int_to_gematria(chapter[i],gershayim=False)}')"""
    #     execute_query(query)
    #     i += 1

    # for index,massechet_perek in enumerate(massechet_perek_id):
        
    #     for halacha_number in list(halacha.values())[index]:
            
    #         execute_query(f"USE {database_name};")
    #         query = f"""INSERT INTO {table_names[2]} ([MASSECHET_PEREK_ID],[HALACHA_ID]) VALUES ({massechet_perek},{halacha_number})"""
    #         execute_query(query)
        
        
    
if __name__ == '__main__':
    main()  