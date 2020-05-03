import xml.etree.cElementTree as ET
import os
import configparser
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings2.ini'))

server = config.get("SQL", "server")
database_name = config.get("SQL", "database_name")
xml_dir_path = config.get("Path","xml_dir_path")

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


def main():

    xml_list = os.listdir(xml_dir_path)

    for xml in xml_list:

        try:
            chapter
            perek_name_array
        except NameError:
            chapter = None
            perek_name_array = None
        if chapter is not None :
            del chapter[:]
        if perek_name_array is not None:
            del perek_name_array[:]

        count_chapter = 0
        chapter = []
        perek_name_array = []



        xml_path = xml_dir_path + "\\" + xml

        tree = ET.ElementTree(file=xml_path)

        # Find and save all the interesting values using ET

        for elem in tree.iter():

            if elem.tag == 'StartMassechet':
                massechet_name = elem.attrib['name']
            if elem.tag == 'StartPerek':
                mishna_num = 0
                chapter.append(elem.attrib['number'])
                count_chapter += 1
            if elem.tag == 'StartMishna':
                mishna_num += 1
            if elem.tag == 'StartMishna' and mishna_num == 1:
                perek_name_list = elem.tail.replace('\n','').split(" ")[0:2]
                perek_name = ' '.join(perek_name_list)
                perek_name_array.append(perek_name)

        massechet_id = get_massechet_id(massechet_name)

        i = 0

        while i < len(chapter):
            query = f"INSERT INTO TBL_MASSECHET_PEREK (MASSECHET_ID,PEREK_NUM,PEREK_NAME) VALUES ( {massechet_id},{chapter[i]},'{perek_name_array[i]}')"
            execute_query(query)
            i += 1

        print(massechet_name + " inserted with success !")

if __name__ == '__main__':
    main()