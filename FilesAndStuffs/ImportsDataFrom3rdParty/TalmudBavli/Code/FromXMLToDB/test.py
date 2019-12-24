import configparser 
import os, fnmatch
import textwrap
import sql_connect
config = configparser.ConfigParser()
config.read('settings.ini')

schema_dir = config.get("Path","schema_dir")
data_dir = config.get("Path","data_dir")
cursor = sql_connect.sql_connect()

ls_schema = os.listdir(schema_dir)
ls_data = os.listdir(data_dir)


def query_string(sql_full_path):
    with open(sql_full_path, 'r',encoding='utf-8') as f:
        lines = f.read()
        # remove any common leading whitespace from every line
        query_string = textwrap.dedent("""{}""".format(lines))
 
    return query_string



def main():
    
    # check if db exists on target, if not create
    qry_create_db = "if not exists(select * from sys.databases where name = '{}') create database {};".format('KiMeTztion','KiMeTztion')
    cursor.execute(qry_create_db)
    cursor.commit() 
    
    i = 0

    while i < len(ls_schema) :
        
        print(f"working on {ls_schema[i]}")
        ls_dir = os.listdir(schema_dir +'\\'+ ls_schema[i])
        
        for file in ls_dir:
            query = query_string(f"{schema_dir}\\{ls_schema[i]}\\{file}")
            print(query)
            cursor.execute(query)
            cursor.commit()
            print(f"{file} script executed successfully !")
        i += 1






if __name__ == '__main__':
    main()