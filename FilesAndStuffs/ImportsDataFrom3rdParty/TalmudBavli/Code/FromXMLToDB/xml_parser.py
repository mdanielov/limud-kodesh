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
    query = f"SELECT MASSECHET_ID FROM TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"

    result_query = execute_query(query)

    for row in result_query:
        massechet_id = row[0]

    return massechet_id


def get_perek_id(daf, massechet_id, chapter_num):
    """
    This function will return the Foreign key PEREK_ID from the reference table TBL_MASSECHET_PEREK according to the
    page number, the MASSECHET_ID and the PEREK_NUM.
    :param daf: actual page number
    :param massechet_id: actual MASSECHET_ID Primary key from TBL_MASSECHET
    :param chapter_num: actual chapter num
    :return: PEREK_ID
    """

    if chapter_num == 0:
        chapter_num = 1

    query = f"SELECT PEREK_ID from TBL_MASSECHET_PEREK WHERE DAF_START <= {daf} and DAF_END >= {daf} \
    AND MASSECHET_ID = {massechet_id} AND PEREK_NUM = {chapter_num}"

    result_query = execute_query(query)

    for row in result_query:
        perek_id = row[0]

    return perek_id


def get_daf_amud_id(daf, amud):
    """
    This function will return the Foreign key DAF_AMUD_ID from the TBL_DAF table according to the page number (daf)
    and the side (amud) number
    :param daf: page number
    :param amud: side number
    :return: foreign_key DAF_AMUD_ID
    """

    query = f"SELECT DAF_AMUD_ID FROM TBL_DAF WHERE DAF_NUM = {daf} AND AMUD_NUM = {amud}"

    result_query = execute_query(query)

    for row in result_query:
        daf_amud_id = row[0]

    return daf_amud_id


def replaceMultiple(mainString, toBeReplaces, newString):
    """
    This function will replace multiple character in the same string.
    :param mainString: The original string to work on
    :param toBeReplaces: An array of string that needs to be replaced
    :param newString: The replacement character
    :return: The mainString with the replaced characters
    """

    for elem in toBeReplaces:

        if elem in mainString:
            mainString = mainString.replace(elem, newString)

    return mainString


def parse_row(row_text, row_number, daf, amud, massechet_name, chapter_num, mishna, guemara):
    """
     This function will inspect each row in the xml file, extract words and insert values in the
     TBL_MASSECHET_WORD table.
     :param row_text: The actual text of the row that will be converted into array of string.
     :param row_number: The actual row number
     :param daf: The actual page number
     :param amud: The actual page side number
     :param massechet_name: The actual Massechet name
     :param chapter_num: The actual chapter number
     :param mishna: Boolean, if 1 = the actual text is a mishna, if 0 = the actual text is not a mishna
     :param guemara: Boolean, if 1 = the actual text is a guemara, if 0 = the actual text is not a guemara
     :return: Insert data into TBL_MASSECHET_WORD
    """

    massechet_id = get_massechet_id(massechet_name)

    perek_id = get_perek_id(daf, massechet_id, chapter_num)

    daf_amud_id = get_daf_amud_id(daf, amud)

    text = str(row_text).split()

    w_type = 0

    if mishna == 1:
        w_type = 0

    if guemara == 1:
        w_type = 1

    for elem in text:

        w_deleted = 0
        w_added = 0

        if '(' in elem or ')' in elem:
            w_deleted = 1

        if '[' in elem or ']' in elem:
            w_added = 1

        word_position = text.index(elem) + 1

        elem = replaceMultiple(elem, ["(", ")", ".", "[", "]"], "")
        elem = elem.replace("'", "''")

        query = f"INSERT INTO {table_names[3]} \
           ([MASSECHET_DAF_ID] \
           ,[PEREK_ID] \
           ,[ROW_ID] \
           ,[W_DELETED] \
           ,[W_ADDED] \
           ,[WORD_POSITION] \
           ,[WORD_TYPE] \
           ,[WORD]) \
            VALUES ({daf_amud_id},{perek_id},{row_number},{w_deleted},{w_added},{word_position},{w_type},'{elem}')"

        execute_query(query)


def get_xml_values(massechet_xml_list, daf, amud, chapter, daf_start_chapter, daf_end_chapter, count_chapter, start,
                   end):
    """
    This function go over every xml file present in the actual massechet folder and will extract all the interesting
    values needed for the insertion into TBL_MASSECHET_PEREK, TBL_DAF, TBL_MASSECHET_DAF
    and will insert this data into them.
    :param massechet_xml_list: The list of all the xml file for the current massechet.
    :param daf: The list of all page numbers of the massechet.
    :param amud: The list of all page side numbers of the massechet.
    :param chapter: The list of all chapter numbers of the massechet.
    :param daf_start_chapter: List of dictionaries that contain the starting page number and page side number of each chapter.
    :param daf_end_chapter: List of dictionaries that contain the ending page number and page side number of each chapter.
    :param count_chapter: The actual chapter number.
    :param start: Dictionary that contains the actual starting page number and page side number for the current chapter.
    :param end: Dictionary that contains the actual ending page number and page side number for the current chapter.
    :return: all the previous parameters are returned by the function.
    """

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

    return daf, amud, chapter, daf_start_chapter, daf_end_chapter, amud_start_chapter, amud_end_chapter, count_chapter, massechet_name


def get_xml_row_value(massechet_xml_list, daf, amud):
    """
    This function will go over each xml row and call the function parse_row in order to insert each
    word into TBL_MASSECHET_WORD table.
    :param massechet_xml_list: current massechet parent directoy.
    :param daf: list of all page number of the actual massechet.
    :param amud: list of all page side number of the actual massechet.
    :return: call parse_row function.
    """
    count = 1
    mishna = 0
    guemara = 0

    for xml in massechet_xml_list:

        xml_path = massechet_dir_path + "\\" + xml
        tree = ET.ElementTree(file=xml_path)

        for elem in tree.iter():

            if elem.tag == 'masechet':
                massechet_name = elem.attrib['name']

            if elem.tag == 'daf':
                daf.append(elem.attrib['value'])

            if elem.tag == 'amud':
                amud.append(elem.attrib['value'])

            if elem.tag == 'row':
                row_number = elem.attrib['row_number']
                print(f"daf : {daf[-1]}, row num : {row_number}, massechet name : {massechet_name} Chapter : {count}")
                if elem.attrib['isdata'] == '1':

                    if len(list(
                            elem)) > 0 and elem.text is None:  # check if the tag contains children and the parent tag does not contain text
                        for child in elem:
                            if child.tag == 'StartMishna' or child.tag == 'EndGemara':
                                mishna = 1
                                guemara = 0
                            if child.tag == 'EndMishna' or child.tag == 'StartGemara':
                                mishna = 0
                                guemara = 1
                            if child.tag == "EndChapter":
                                count += 1
                                if child.tail is not None:
                                    parse_row(child.tail, row_number, daf[-1], amud[-1], massechet_name, count, mishna,
                                              guemara)
                            if child.tail is not None:
                                parse_row(child.tail, row_number, daf[-1], amud[-1], massechet_name, count, mishna,
                                          guemara)

                    if len(list(
                            elem)) > 0 and elem.text is not None:  # check if the tag contains children and the parent tag contain text before children
                        parse_row(elem.text, row_number, daf[-1], amud[-1], massechet_name, count, mishna, guemara)
                        for child in elem:
                            if child.tag == 'StartMishna' or child.tag == 'EndGemara':
                                mishna = 1
                                guemara = 0
                            if child.tag == 'EndMishna' or child.tag == 'StartGemara':
                                mishna = 0
                                guemara = 1
                            if child.tag == "EndChapter":
                                count += 1
                                if child.tail is not None:
                                    parse_row(child.tail, row_number, daf[-1], amud[-1], massechet_name, count, mishna,
                                              guemara)
                            if child.tail is not None:
                                parse_row(child.tail, row_number, daf[-1], amud[-1], massechet_name, count, mishna,
                                          guemara)

                    elif len(list(elem)) == 0 and elem.text is not None:
                        parse_row(elem.text, row_number, daf[-1], amud[-1], massechet_name, count, mishna, guemara)


# --------------------------------------------- TBL_DAF TABLE INSERT ---------------------------------------------#

execute_query(f"USE {database_name};")

daf = 2
amud_1 = 1
amud_2 = 2
count = 1

while daf <= 176:
    query_string_1 = f"INSERT INTO {table_names[1]} (DAF_NUM ,DAF_NAME ,AMUD_NUM ,AMUD_NAME) VALUES ({daf},'{int_to_gematria(daf, gershayim=False)}',{amud_1},'{int_to_gematria(amud_1, gershayim=False)}') "
    query_string_2 = f"INSERT INTO {table_names[1]} (DAF_NUM ,DAF_NAME ,AMUD_NUM ,AMUD_NAME) VALUES ({daf},'{int_to_gematria(daf, gershayim=False)}',{amud_2},'{int_to_gematria(amud_2, gershayim=False)}')"
    daf += 1
    count += 1
    execute_query(query_string_1)
    execute_query(query_string_2)

print(f"Insertion in {table_names[1]} done with success !")

# ---------------------------------------------------------------------------------------------------------- #

result = []
daf = []
amud = []
chapter = []
daf_start_chapter = []
daf_end_chapter = []
start = {}
end = {}

for massechet_dir in massechet_dir_list:

    count_chapter = 0
    del daf[:]
    del amud[:]
    del chapter[:]
    del daf_start_chapter[:]
    del daf_end_chapter[:]
    del result[:]
    start.clear()
    end.clear()

    massechet_dir_path = parent_dir_path + "\\" + massechet_dir
    massechet_xml_list = os.listdir(massechet_dir_path)

    # Runnning a loop for each xml file in the massechet directory

    result = get_xml_values(massechet_xml_list, daf, amud, chapter, daf_start_chapter, daf_end_chapter,
                            count_chapter, start, end)

    daf = result[0]
    amud = result[1]
    chapter = result[2]
    daf_start_chapter = result[3]
    daf_end_chapter = result[4]
    amud_start_chapter = result[5]
    amud_end_chapter = result[6]
    count_chapter = result[7]
    massechet_name = result[8]

    # ---------------------------------------------TBL_MASSECHET_PEREK INSERT ---------------------------------------#

    print(f"Inserting {massechet_name} into TBL_MASSECHET_PEREK...")

    ##########################################
    # Get the MASSECHET_ID foreign key value #
    ##########################################

    massechet_id = get_massechet_id(massechet_name)

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

    # ---------------------------- TBL_MASSECHET_DAF INSERT -----------------------#

    # get_massechet_id = f"SELECT MASSECHET_ID FROM TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"
    #
    # cursor.execute(f"USE {database_name};")
    # cursor.execute(get_massechet_id)
    #
    # for row in cursor:
    #     massechet_id = row[0]

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

    # ---------------------------- TBL_MASSECHET_WORD INSERT -----------------------#

    get_xml_row_value()

    get_massechet_daf_id = f"select MASSECHET_DAF_ID from TBL_MASSECHET_DAF WHERE MASSECHET_ID = '{massechet_id}'"

    cursor.execute(f"USE {database_name};")
    cursor.execute(get_massechet_daf_id)

    massechet_daf_id = []

    for row in cursor:
        massechet_daf_id.append(row[0])

    # print(massechet_daf_id)

    for elem in massechet_daf_id:
        get_perek_id = f"SELECT PEREK_ID FROM TBL_MASSECHET_PEREK WHERE MASSECHET_ID = {massechet_id} AND  "

        query = f"INSERT INTO [dbo].[TBL_MASSECHET_WORD]\
           ([MASSECHET_DAF_ID]\
           ,[PEREK_ID]\
           ,[ROW_ID]\
           ,[W_DELETED]\
           ,[W_ADDED]\
           ,[WORD_POSITION]\
           ,[WORD_TYPE]\
           ,[WORD])\
            VALUES ({elem})"
