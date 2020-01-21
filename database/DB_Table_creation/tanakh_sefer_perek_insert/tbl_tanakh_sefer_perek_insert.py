import configparser
import os
import re
import pyodbc

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(
    os.path.dirname(__file__)), 'settings.ini'))
database_name = config.get("SQL", "database_name")
server = config.get("SQL", "server")
csv_path = "C:\\Work\\Git\\limud-kodesh\\database\\DB_Table_creation\\tanakh_sefer_perek_insert\\tanakh_perek_list.csv"

sefer_id_list = []


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


execute_query(f"USE KiMeTzion;")

# Append all Sefer id's to sefer_id_list []

sql_select_Query = "select * from TBL_TANAKH_SEFER"
cursor.execute(sql_select_Query)
records = cursor.fetchall()
i=0
for row in records:
    sefer_id_list.append(row[0])
    i += 1
print("sefer_id_list: ", sefer_id_list)


def get_csv_content(file_csv):

    file_csv = csv_path
    with open(file_csv, encoding='utf-8') as f:
        lineList = f.readlines()
        i=0
        k=0
        for elem in lineList:
            element = elem.replace('\n', '')
            mylist = str(element).split("|")
            print(mylist[1])

            # Append all prakim in that sefer to a list
            sql_select_Query = f"select PEREK_ID from TBL_TANAKH_PEREK where PEREK_NUM BETWEEN 1 AND {mylist[1]}"
            cursor.execute(sql_select_Query)
            records = cursor.fetchall()
            i=0
            perek_id_list = []
            for row in records:
                perek_id_list.append(row[0])
                i += 1
            # print("perek_id_list: ", perek_id_list)
            i=0
            

            # Loop through every perek in the sefer
            while i < int(mylist[1]):
                # print("i: ", i, " k: ", k)
                # print(perek_id_list[i], sefer_id_list[k])            
                query_string = f"INSERT INTO TBL_TANAKH_SEFER_PEREK (PEREK_ID, SEFER_ID) VALUES ({perek_id_list[i]}, {sefer_id_list[k]})"
                cursor.execute(query_string)
                i += 1
            perek_id_list = []
            k += 1



def main():
    get_csv_content(csv_path)
    return "hello"


if __name__ == '__main__':
    main()
