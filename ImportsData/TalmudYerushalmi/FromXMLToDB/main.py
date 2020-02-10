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


def get_xml_values(massechet_dir_path, halacha, chapter, count_chapter):
    
    print(massechet_dir_path)
    tree = ET.ElementTree(file=massechet_dir_path)
    
    
    for elem in tree.iter():
        print(elem.text)


def main():
    
    halacha = []
    chapter = []
    count_chapter = 0
    
    for xml in massechet_dir_list: 
        
        massechet_dir_path = parent_dir_path + "\\" + xml
        result = get_xml_values(massechet_dir_path,halacha,chapter,count_chapter)


if __name__ == '__main__':
    main()  