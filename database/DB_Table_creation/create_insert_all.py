import configparser
import os
import fnmatch
import textwrap
import pyodbc
from hebrew_numbers import int_to_gematria

config = configparser.ConfigParser()
config.read('settings.ini')


server_name = config.get("Sql", "Server")
schema_dir = config.get("Path", "schema_dir")
data_dir = config.get("Path", "data_dir")

conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server_name + ';'
                      'Database=master;'
                      'Trusted_Connection=yes;',
                      autocommit=True)
conn.autocommit = True

cursor = conn.cursor()

ls_schema = os.listdir(schema_dir)
ls_data = os.listdir(data_dir)



def query_string(sql_full_path):
    print(sql_full_path)
    with open(sql_full_path, 'r',encoding='utf-8-sig') as f:
        lines = f.read()
        # remove any common leading whitespace from every line
        query_string = textwrap.dedent("""{}""".format(lines))

    return query_string


def main():

    # check if db exists on target, if not create
    qry_create_db = "if not exists(select * from sys.databases where name = 'KiMeTzion') create database KiMeTzion collate Hebrew_CI_AS;"
    cursor.execute(qry_create_db)
    cursor.commit()

    # List Schema directory and execute scripts.
    i = 0
    while i < len(ls_schema):
        # print("ls schema:", ls_schema)
        # print(f"working on {ls_schema[i]}")
        if ls_schema[i] == '02-functions':
            break
        else:
            ls_dir = os.listdir(schema_dir + '\\')
            # print("ls_dir:", ls_dir)

        for file in ls_dir:
            print(f"working on {file}")
            query = query_string(f"{schema_dir}\\{ls_schema[i]}")
            print(query)
            cursor.execute(query)
            # print(f"{file} script executed successfully !")
        i += 1


    # List insert data directory and execute scripts.
    i = 0

    ls_data_folders=[]
    for filename in ls_data:
        if os.path.exists(os.path.join(data_dir,filename)):
            ls_data_folders.append(filename)
    while i < len(ls_data_folders):
        ls_dir = os.listdir(data_dir)
        query = query_string(f"{data_dir}\\{ls_data_folders[i]}")
        cursor.execute(query)
        i += 1


if __name__ == '__main__':
    main()
