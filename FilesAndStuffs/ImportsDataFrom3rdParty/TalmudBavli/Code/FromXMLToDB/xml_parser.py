import xml.etree.cElementTree as ET
import os
import configparser
import pyodbc

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)),'settings.ini'))

parent_dir_path = config.get('XML','parent_dir')
massechet_dir_list = os.listdir(parent_dir_path) 
server = config.get("SQL","server")
table_name = config.get("SQL","table_name")
database_name = config.get("SQL","database_name")

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                      'Database=' + database_name + ';'
                      'Trusted_Connection=yes;',
                      autocommit=True)
# conn.autocommit = True

cursor = conn.cursor()


# Running loop on each Massechet Directory in the parent directory

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


    ##########################################
    # Get the MASSECHET_ID foreign key value #
    ##########################################

    query = f"SELECT MASSECHET_ID from MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"
    
    cursor.execute(f"USE {database_name}")
    cursor.execute(query)

    massechet_id = int

    for row in cursor:
        massechet_id = row[0]

    ##############################################
    # Build SQL query and insert previous values.#
    ##############################################

    i = 0
    while i < len(chapter):
        query_string = f"INSERT INTO {table_name} ([MASSECHET_ID]\
           ,[PEREK_NUM]\
           ,[PEREK_NAME]\
           ,[DAF_START]\
           ,[AMUD_START]\
           ,[DAF_END]\
           ,[AMUD_END])\
        VALUES ({massechet_id},\
            {chapter[i]},\
            '{daf_start_chapter[i]['name']}',\
            {daf_start_chapter[i]['daf_start']},\
            {daf_start_chapter[i]['amud_start']},\
            {daf_end_chapter[i]['daf_end']},\
            {daf_end_chapter[i]['amud_end']})"

        if massechet_name == 'תמורה':
            print(query_string)
        
        cursor.execute(query_string.strip())
        # print(f"{massechet_name} inserted with success !")
        i += 1




    # print(daf)
    # print(amud)
    # print(chapter)
    # print("------------------ start ----------------")
    # print(daf_start_chapter)
    # print("------------------------ end -------------")
    # print(daf_end_chapter)