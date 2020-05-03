import xml.etree.cElementTree as ET
import os
import re
import configparser
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(
    os.path.dirname(__file__)), 'settings.ini'))

parent_dir_path = config.get('XML', 'parent_dir')
massechet_dir_list = os.listdir(parent_dir_path)
server = config.get("SQL", "server")
table_names = config.get("SQL", "table_names").split(',')
database_name = config.get("SQL", "database_name")
csv_file_name = os.path.join(os.path.abspath(
    os.path.dirname(__file__))) + "\\" + "temp_csv_insert.csv"

if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name)):
    os.remove(os.path.join(os.path.abspath(
        os.path.dirname(__file__)), csv_file_name))

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                                           'Database=' + database_name + ';'
                                                                         'Trusted_Connection=yes;',
                      autocommit=True, encoding='utf-8')


def execute_query(query):
    print(query)
    with conn:
        cursor = conn.cursor()
        cursor.execute(query)
    return cursor


def bulk_insert_to_tbl(csv_file_path, tbl_name):
    execute_query(f"SET IDENTITY_INSERT {table_names[3]} ON;")
    query = f"BULK INSERT {tbl_name} \
            FROM '{csv_file_path}' \
            WITH \
                (  \
                     FIELDTERMINATOR ='|' \
                    , ROWTERMINATOR ='\r' \
                    ,CODEPAGE = '65001' \
                );"
    execute_query(f"SET IDENTITY_INSERT {table_names[3]} OFF;")

    execute_query(query)


def write_csv_file(file_name, textline):
    """
    This function will write a new line into csv file in order to Bulk insert into TBL_MASSECHET_WORD table.
    :param file_name: the csv file name
    :param textline: the string that will be appended to the csv file
    """
    with open(os.path.join(os.path.abspath(os.path.dirname(__file__)), file_name), "a", encoding='utf-8') as f:
        f.write(f"{textline}\r")


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


def get_massechet_id(massechet_name):
    """
    This function will get the MASSECHET_ID Foreign key from the reference table TBL_MASSECHET according to
    the massechet name.
    :param massechet_name: the actual massechet name
    :return: MASSECHET_ID
    """
    
    massechet_id = ''

    execute_query(f"USE {database_name};")

    query = f"SELECT MASSECHET_ID FROM TBL_MASSECHET WHERE MASSECHET_NAME = '{massechet_name}'"

    result_query = execute_query(query)

    for row in result_query:
        massechet_id = row[0]

    return massechet_id


def get_massechet_perek_id(massechet_id, perek_num):
    """
    This function will get the PEREK_ID Foreign key from the reference table TBL__MASSECHET_PEREK according to
    the massechet_id and the perek_num.
    :param massechet_name: the actual massechet name
    :return: MASSECHET_PEREK_ID
    """
    execute_query(f"USE {database_name};")

    query = f"SELECT PEREK_ID from TBL_MASSECHET_PEREK WHERE MASSECHET_ID = {massechet_id} AND PEREK_NUM = {perek_num}"

    result_query = execute_query(query)

    massechet_perek_id = []

    for row in result_query:
        massechet_perek_id.append(row[0])

    return massechet_perek_id


def get_halacha_id(halacha_num):

    query = f"SELECT HALACHA_ID from TBL_YERUSHALMI_HALACHA WHERE HALACHA_NUM = {halacha_num}"
    result_query = execute_query(query)

    for row in result_query:
        halacha_id = row[0]

    return halacha_id


def get_massechet_halacha_id(halacha_num, perek_num, massechet_name):
    """
    This function will get the MASSECHET_HALACHA_ID Foreign key from the reference table TBL_YERUSHALMI_MASSECHET_HALACHA according to
    the massechet name.
    :param massechet_name: the actual massechet name
    :return: MASSECHET_HALACHA_ID
    """
    execute_query(f"USE {database_name};")

    query = f"""SELECT MH.MASSECHET_HALACHA_ID FROM TBL_YERUSHALMI_MASSECHET_HALACHA MH
				JOIN TBL_MASSECHET_PEREK P ON P.PEREK_ID = MH.PEREK_ID
                JOIN TBL_YERUSHALMI_HALACHA H ON H.HALACHA_ID = MH.HALACHA_ID
                JOIN TBL_MASSECHET M ON M.MASSECHET_ID = P.MASSECHET_ID
                WHERE H.HALACHA_NUM = '{halacha_num}' AND P.PEREK_NUM = '{perek_num}' AND M.MASSECHET_NAME = '{massechet_name}'"""
    result_query = execute_query(query)

    massechet_halacha_id = ''

    for row in result_query:
        massechet_halacha_id = row[0]

    return massechet_halacha_id


def get_xml_content_values(massechet_dir_path, halacha, in_mishna, content, massechet_name):
    
    

    in_w_added = 0
    in_w_deleted = 0
    w_added = 0
    w_deleted = 0
    word_type = 0
    count = 1

    for index, word in enumerate(re.split(r'[\.\s]\s*', content)):
        
        last_key = list(halacha.keys())[-1]
        
        massechet_halacha_id = get_massechet_halacha_id(
            halacha[last_key][-1], list(halacha.keys())[-1], massechet_name)

        if in_mishna == 1:
            word_type = 0

        if in_mishna == 0:
            word_type = 1

        if in_w_deleted == 0 or in_w_added == 0:
            w_added = 0
            w_deleted = 0

        if '[' in word and ']' not in word:
            w_added = 1
            in_w_added = 1

        if in_w_added == 1 and '[' not in word and ']' not in word:
            w_added = 1

        if ']' in word and '[' not in word:
            w_added = 1
            in_w_added = 0

        if '(' in word and ')' not in word:
            w_deleted = 1
            in_w_deleted = 1

        if in_w_deleted == 1 and '(' not in word and ')' not in word:
            w_deleted = 1

        if ')' in word and '(' not in word:
            w_deleted = 1
            in_w_deleted = 0

        if '(' in word and ')' in word:
            w_deleted = 1

        if '[' in word and ']' in word:
            w_added = 1

        word = replaceMultiple(
            word, ["(", ")", ".", ":", "[", "]", " "], "")
        
        if word == "":
            continue
        
        textline = f"|{massechet_halacha_id}|{word_type}|{word}|{count}|{w_deleted}|{w_added}"
        
        count += 1

        write_csv_file(csv_file_name, textline)


def get_xml_values(massechet_dir_path, chapter, count_chapter, halacha_per_perek):

    tree = ET.ElementTree(file=massechet_dir_path)

    for elem in tree.iter():

        if elem.tag == 'StartMassechet':
            massechet_name = elem.attrib['name']

        if elem.tag == 'StartPerek':
            halacha_num = 1
            chapter.append(elem.attrib['number'])
            count_chapter += 1
            halacha_per_perek[str(count_chapter)] = []

        if elem.tag == 'StartHalacha':
            halacha_per_perek[str(count_chapter)].append(halacha_num)
            halacha_num += 1

    return massechet_name, chapter, halacha_per_perek


def get_context_values(massechet_dir_path, chapter, count_chapter,halacha):

    in_mishna = 0
    
    tree = ET.ElementTree(file=massechet_dir_path)

    for index,elem in enumerate(tree.iter()):

        if elem.tag == 'StartMassechet':
            massechet_name = elem.attrib['name']

        if elem.tag == 'StartPerek':
            halacha_num = 1
            chapter.append(elem.attrib['number'])
            count_chapter += 1
            halacha[str(count_chapter)] = []

        if elem.tag == 'StartHalacha':
            halacha[str(count_chapter)].append(halacha_num)
            halacha_num += 1

        if elem.tag == 'StartMishna':
            in_mishna = 1
            get_xml_content_values(massechet_dir_path,halacha,in_mishna,elem.tail,massechet_name)

        if elem.tag == 'StartGuemara':
            in_mishna = 0
            get_xml_content_values(massechet_dir_path,halacha,in_mishna,elem.tail,massechet_name)
        

def insert_data_tbl_yerushalmi_halacha():

    i = 1
    while i < 17:
        execute_query(f"USE {database_name};")
        query = f"""INSERT INTO {table_names[1]} ([HALACHA_NUM],[HALACHA_NAME]) VALUES ({i},'{int_to_gematria(i,gershayim=False)}')"""
        execute_query(query)
        i += 1


def insert_data_tbl_yerushalmi_massechet_halacha():

    halacha = {}
    chapter = []

    for xml in massechet_dir_list:

        count_chapter = 0
        halacha.clear()
        del chapter[:]

        massechet_dir_path = parent_dir_path + "\\" + xml
        result = get_xml_values(
            massechet_dir_path, chapter, count_chapter, halacha)

        massechet_name = result[0]
        chapter = result[1]
        halacha = result[2]
        massechet_id = get_massechet_id(massechet_name)

        for perek in halacha:
            perek_id = get_massechet_perek_id(massechet_id, perek)
            for halacha_num in halacha[str(perek)]:

                halacha_id = get_halacha_id(halacha_num)

                query = f"""INSERT INTO {table_names[2]} ([PEREK_ID],[HALACHA_ID]) VALUES ({perek_id[0]},{halacha_id})"""
                execute_query(query)


def main():
    
    insert_data_tbl_yerushalmi_halacha()
    # insert_data_tbl_yerushalmi_massechet_perek()
    insert_data_tbl_yerushalmi_massechet_halacha()

    halacha = {}
    chapter = []

    for massechet_xml_name in massechet_dir_list:
        
        massechet_dir_path = parent_dir_path + "\\" + massechet_xml_name
        count_chapter = 0
        halacha.clear()
        del chapter[:]
        get_context_values(massechet_dir_path, chapter, count_chapter, halacha)

    bulk_insert_to_tbl(csv_file_name, table_names[3])

    if os.path.exists(os.path.join(os.path.abspath(os.path.dirname(__file__)), csv_file_name)):
        os.remove(os.path.join(os.path.abspath(
            os.path.dirname(__file__)), csv_file_name))


if __name__ == '__main__':
    main()
