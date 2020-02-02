import xml.etree.cElementTree as ET
import os
import configparser
import pyodbc

config = configparser.ConfigParser()
config.read('settings.ini')
database_name = config.get("Sql", "database_name")
server = config.get("Sql", "Server")

parent_dir = config.get("Path", "parent_dir")


conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                                           'Database=' + database_name + ';'
                                                                         'Trusted_Connection=yes;',
                      autocommit=True, encoding='utf-8')

cursor = conn.cursor()


def execute_query(query):
    with conn:
        cursor = conn.cursor()
        cursor.execute(query)
    return cursor



# print(xml_list)

def main():
    
    xml_list = os.listdir(parent_dir)

    # loop through every book 
    for xml_file in xml_list:
        book_name_list = None
        chapter_num_list = []
        pasuk_num_list = []
        pasuk_sum_list = []
        print(xml_file)
        book_name = None
        xml_path = parent_dir + "\\" + xml_file
        tree = ET.ElementTree(file=xml_path)
        # loop through every row (word)
        i=0
        for elem in tree.iter():
            if elem.tag == 'Word' and book_name is None:
                book_name = elem.attrib['Book']
                book_name_list = book_name       
            if elem.tag == 'Word':
                chapter_num = int(elem.attrib['Chapter'])
                pasuk_num = int(elem.attrib['Verse'])       
                if i == 0:
                    chapter_num_list.append(chapter_num)
                if chapter_num != chapter_num_list[-1]:
                    chapter_num_list.append(chapter_num)        
                if i == 0:
                    pasuk_num_list.append(pasuk_num)
                i += 1
                if pasuk_num != pasuk_num_list[-1]:
                    if pasuk_num < pasuk_num_list[-1]:
                        pasuk_sum_list.append(pasuk_num_list[-1])       
                    pasuk_num_list.append(pasuk_num)
        pasuk_sum_list.append(pasuk_num_list[-1])   
        execute_query(f"USE KiMeTzion;")    
        sql_select_Query = f"SELECT SEFER_ID ,SEFER_ENGLISH_NAME FROM TBL_TANAKH_SEFER where SEFER_ENGLISH_NAME = '{book_name_list}'"
        cursor.execute(sql_select_Query)
        records = cursor.fetchall()     

        for row in records:
            sefer_id = row[0]
            
        print("sefer_id: ", sefer_id)
        execute_query(f"USE KiMeTzion;")
        sql_select_Query = f"SELECT SEFER_PEREK_ID, PEREK_ID from TBL_TANAKH_SEFER_PEREK where SEFER_ID = '{sefer_id}'"
        cursor.execute(sql_select_Query)
        records = cursor.fetchall()     
        sefer_perek_id_list = []
        for row in records:
            sefer_perek_id = row[0]
            sefer_perek_id_list.append(sefer_perek_id)
        for sefer_perek_id, pasuk_sum in zip(sefer_perek_id_list, pasuk_sum_list):
            # print("sefer_perek_id_list: ", sefer_perek_id_list)
            # print("pasuk_sum_list: ", pasuk_sum_list)
            # receiving the sum of psukim for each perek
            execute_query(f"USE KiMeTzion;")
            sql_select_Query = f"SELECT PASUK_ID FROM TBL_TANAKH_PASUK WHERE PASUK_ID BETWEEN 1 and '{pasuk_sum}'"
            cursor.execute(sql_select_Query)
            records = cursor.fetchall()     
            for row in records:
                execute_query(f"USE KiMeTzion;")
                query_string = f"INSERT INTO TBL_TANAKH_PEREK_PASUK (SEFER_PEREK_ID, PASUK_ID) VALUES ({sefer_perek_id}, {row[0]})"
                cursor.execute(query_string)
                print(query_string)
        # book_name_list = []
        # chapter_num_list = []   
        # pasuk_sum_list = []
        # pasuk_num_list = []


if __name__ == '__main__':
    main()
