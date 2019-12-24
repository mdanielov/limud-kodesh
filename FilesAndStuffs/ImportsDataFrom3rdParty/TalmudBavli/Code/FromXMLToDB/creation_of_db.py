import sql_connect
import configparser 
import os, fnmatch


config = configparser.ConfigParser()
config.read('settings.ini')

schema_dir = config.get("Path","schema_dir")
data_dir = config.get("Path","data_dir")


listOfFiles = os.listdir(schema_dir)
print(listOfFiles)


# creation of database KiMeTztion

def main():
    # check if db exists on target, if not create
    qry_create_db = "if not exists(select * from sys.databases where name = '{}') create database {};".format('KiMeTztion','KiMeTztion')
    with sql_connect.conn:
        cur1 = sql_connect.cursor.execute(qry_create_db)
        cur1.commit() 
   
main() 

# creation of tables

def creation_table(filename):    
    # Open and read the file as a single buffer
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()

    # all SQL commands (split on ';')
    sqlCommands = sqlFile.split(';')

    # Execute every command from the input file
    for command in sqlCommands:
        with sql_connect.conn:
            cur2 = sql_connect.cursor.execute(command)
            cur2.commit()




# insertion of data into reference's tables

def insert_data(filename):    
    # Open and read the file as a single buffer
    fd = open(filename, 'r', encoding="utf8")
    sqlFile = fd.read()
    fd.close()

    # all SQL commands (split on ';')
    sqlCommands = sqlFile.split(';')
    # print(sqlCommands)

    # Execute every command from the input file
    for command in sqlCommands:
        with sql_connect.conn:
            cur2 = sql_connect.cursor.execute(command)
            cur2.commit()


if __name__ == '__main__':
    main()