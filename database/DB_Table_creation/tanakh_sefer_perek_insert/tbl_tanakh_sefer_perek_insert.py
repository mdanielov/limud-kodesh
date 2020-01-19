import configparser
import os
import re
import pyodbc

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))
database_name = config.get("SQL", "database_name")
server = config.get("SQL", "server")
csv_path = "C:\\Git\\limud-kodesh\\FilesAndStuffs\\ImportsDataFrom3rdParty\\DB_Table_creation\\tanakh_perek_list.csv"

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

def get_csv_content(file_csv):

    file_csv = csv_path
    with open(file_csv,encoding='utf-8') as f:
        lineList = f.readlines()
        for elem in lineList:
            element = elem.replace('\n', '')
            mylist = str(element).split("|")
            print(mylist[])


def main():
    get_csv_content(csv_path)
    return "hello"


if __name__ == '__main__':
    main()
