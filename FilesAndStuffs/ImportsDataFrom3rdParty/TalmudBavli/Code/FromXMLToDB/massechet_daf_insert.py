import xml.etree.cElementTree as ET
import os
import configparser
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)),'settings.ini'))

parent_dir_path = config.get('XML','parent_dir')
massechet_dir_list = os.listdir(parent_dir_path) 
server = config.get("SQL","server")
# table_names = config.get("SQL","table_names").split(',')
database_name = config.get("SQL","database_name")

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                      'Database=' + database_name + ';'
                      'Trusted_Connection=yes;',
                      autocommit=True,encoding='utf-8')
# conn.autocommit = True

cursor = conn.cursor()



for massechet_dir in massechet_dir_list:
    daf = []
    amud = []
    chapter = []
    daf_start_chapter = []
    daf_end_chapter = []
    amud_start_chapter = []
    amud_end_chapter = []
    count_chapter = 0
    start = {}
    end = {}

    # # for BAVLI_DAF_WORD
    # row = []
    # row_number = []


    massechet_dir_path = parent_dir_path + "\\" + massechet_dir
    massechet_xml_list = os.listdir(massechet_dir_path)
    
    # Runnning a loop for each xml file in the massechet directory

    for xml in massechet_xml_list:
        
        xml_path = massechet_dir_path + "\\" + xml
        tree = ET.ElementTree(file=xml_path)

        # Find and save all the interesting values using ET

        for elem in tree.iter():
            
            if elem.tag == 'masechet':
                massechet_name = elem.attrib['name']

            if elem.tag == 'daf':
                daf.append(elem.attrib['value'])
            
            if elem.tag == 'amud':
                amud.append(elem.attrib['value'])
            
            if elem.tag == 'StartChapter':
                count_chapter += 1
                chapter.append(count_chapter)
                start["chapter"] = chapter[-1]
                start["daf_start"] = daf[-1]
                start["amud_start"] = amud[-1]
                start["name"] = elem.attrib['name']
                daf_start_chapter.append(start.copy())

            if elem.tag == 'EndChapter':
                end["chapter"] = chapter[-1]
                end["daf_end"] = daf[-1]
                end["amud_end"] = amud[-1]
                end["name"] = elem.attrib["name"]
                daf_end_chapter.append(end.copy())

    get_massechet_id = f"SELECT MASSECHET_ID FROM TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"

    cursor.execute(f"USE {database_name};")
    cursor.execute(get_massechet_id)


    for row in cursor:
        massechet_id = row[0]

    daf_start = daf_start_chapter[0]["daf_start"]
    daf_end = daf_end_chapter[-1]["daf_end"]
    get_daf_amud_id = f"SELECT DAF_AMUD_ID FROM [dbo].[TBL_DAF] WHERE DAF_NUM BETWEEN {daf_start} AND {daf_end}"

    print(get_daf_amud_id)

    cursor.execute(get_daf_amud_id)
    
    rows = cursor.fetchall()

    daf_list = []

    for row in rows:
        num = int(row[0])
        print(num)
        daf_list.append(num)

    print(daf_list)


    for num in daf_list:
        query_string = f"INSERT INTO {table_names[2]} (MASSECHET_ID,DAF_AMUD_ID) VALUES ({massechet_id},{num})"
        cursor.execute(f"USE {database_name}")
        cursor.execute(query_string)
    
    # print(massechet_name)
    # print(daf_start_chapter[0]["daf_start"],daf_end_chapter[-1]["daf_end"])
