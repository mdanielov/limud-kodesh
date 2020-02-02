import configparser
import os
import fnmatch
import textwrap
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))


server_name = config.get("Sql", "Server")

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server_name + ';'
                      'Database=master;'
                      'Trusted_Connection=yes;',
                      autocommit=True)
conn.autocommit = True

cursor = conn.cursor()


def execute_query(query):
    with conn:
        cursor = conn.cursor()
        cursor.execute(query)
    return cursor


def query_string(sql_full_path):
    with open(sql_full_path, 'r', encoding='utf-8') as f:
        lines = f.read()
        # remove any common leading whitespace from every line
        query_string = textwrap.dedent("""{}""".format(lines))

    return query_string


def main():

    # check if db exists on target, if not create
    qry_create_db = "if not exists(select * from sys.databases where name = 'KiMeTzion') create database KiMeTzion collate Hebrew_CI_AS;"
    cursor.execute(qry_create_db)
    cursor.commit()

    # # List Schema directory and execute scripts.
    i = 1
    while i <= 176:
        execute_query(f"USE KiMeTzion;")
        query_string = f"INSERT INTO TBL_TANAKH_PASUK (PASUK_NUM, PASUK_HEBREW_NUM) VALUES ({i},N'{int_to_gematria(i, gershayim=False)}')"
        cursor.execute(query_string)
        print(query_string)
        i += 1



if __name__ == '__main__':
    main()
