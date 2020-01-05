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
table_names = config.get("SQL","table_names").split(',')
database_name = config.get("SQL","database_name")

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                      'Database=' + database_name + ';'
                      'Trusted_Connection=yes;',
                      autocommit=True,encoding='utf-8')
# conn.autocommit = True

cursor = conn.cursor()



def get_xml_values(massechet_xml_list,daf,amud,chapter,daf_start_chapter,daf_end_chapter,amud_start_chapter,amud_end_chapter,count_chapter,start,end):
        
    
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

    return daf,amud,chapter,daf_start_chapter,daf_end_chapter,amud_start_chapter,amud_end_chapter,count_chapter,massechet_name

        

#--------------------------------------------- TBL_DAF INSERT ---------------------------------------------#

daf = 2
amud_1 = 1
amud_2 = 2
count = 1

while daf <= 176 :
    if(count % 2) != 0:
        query_string = f"INSERT INTO {table_names[1]} (DAF_NUM ,DAF_NAME ,AMUD_NUM ,AMUD_NAME) VALUES ({daf},'{int_to_gematria(daf, gershayim=False)}',{amud_1},'{int_to_gematria(amud_1, gershayim=False)}')"
        daf += 1
        count += 1
        cursor.execute(query_string)
    elif(count % 2) == 0 :
        query_string = f"INSERT INTO {table_names[1]} (DAF_NUM ,DAF_NAME ,AMUD_NUM ,AMUD_NAME) VALUES ({daf},'{int_to_gematria(daf, gershayim=False)}',{amud_2},'{int_to_gematria(amud_2, gershayim=False)}')"
        daf += 1
        count += 1
        cursor.execute(query_string)

print("--------------------------------------")
print("")
print(f"Insertion in {table_names[1]} done with success !")




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

    result = get_xml_values(massechet_xml_list,daf,amud,chapter,daf_start_chapter,daf_end_chapter,amud_start_chapter,amud_end_chapter,count_chapter,start,end)

    daf = result[0]
    amud = result[1]
    chapter = result[2]
    daf_start_chapter = result[3]
    daf_end_chapter = result[4]
    amud_start_chapter = result[5]
    amud_end_chapter = result[6]
    count_chapter = result[7]
    massechet_name = result[8]

    #---------------------------------------------TBL_MASSECHET_PEREK INSERT ---------------------------------------------#

    print(f"Working on {''.join(reversed(massechet_name))}...")

    ##########################################
    # Get the MASSECHET_ID foreign key value #
    ##########################################

    query = f"SELECT MASSECHET_ID from TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"

    cursor.execute(f"USE {database_name}")
    
    cursor.execute(query)

    for row in cursor:
        massechet_id = row[0]

    
    ##############################################
    # Build SQL query and insert previous values.#
    ##############################################

    i = 0
    while i < len(chapter):
        query_string = f"INSERT INTO {table_names[0]} ([MASSECHET_ID]\
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

        cursor.execute(query_string.strip())
        i += 1


    #---------------------------- TBL_MASSECHET_DAF INSERT -----------------------#

    get_massechet_id = f"SELECT MASSECHET_ID FROM TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"

    cursor.execute(f"USE {database_name};")
    cursor.execute(get_massechet_id)


    for row in cursor:
        massechet_id = row[0]

    daf_start = daf_start_chapter[0]["daf_start"]
    daf_end = daf_end_chapter[-1]["daf_end"]
    get_daf_amud_id = f"SELECT DAF_AMUD_ID FROM [dbo].[TBL_DAF] WHERE DAF_NUM BETWEEN {daf_start} AND {daf_end}"


    cursor.execute(get_daf_amud_id)
    
    rows = cursor.fetchall()

    daf_list = []

    for row in rows:
        num = int(row[0])
        daf_list.append(num)



    for num in daf_list:
        query_string = f"INSERT INTO {table_names[2]} (MASSECHET_ID,DAF_AMUD_ID) VALUES ({massechet_id},{num})"
        cursor.execute(f"USE {database_name}")
        cursor.execute(query_string)

    

    #---------------------------- TBL_MASSECHET_WORD INSERT -----------------------#


    get_massechet_daf_id = f"select MASSECHET_DAF_ID from TBL_MASSECHET_DAF WHERE MASSECHET_ID = '{massechet_id}'"

    cursor.execute(f"USE {database_name};")
    cursor.execute(get_massechet_daf_id)
    
    massechet_daf_id = []
    
    for row in cursor:
        massechet_daf_id.append(row[0])

    print(massechet_daf_id)

    query = f"INSERT INTO [dbo].[TBL_MASSECHET_WORD]\
           ([MASSECHET_DAF_ID]\
           ,[PEREK_ID]\
           ,[ROW_ID]\
           ,[W_DELETED]\
           ,[W_ADDED]\
           ,[WORD_POSITION]\
           ,[WORD_TYPE]\
           ,[WORD])\
     VALUES"

