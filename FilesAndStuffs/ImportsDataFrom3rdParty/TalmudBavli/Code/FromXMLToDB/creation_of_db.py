import sql_connect
import configparser 

config = configparser.ConfigParser()
config.read('settings.ini')

# Path of table files

toshba_table = config.get('Path','toshba_table')
talmud_type_table = config.get('Path','talmud_type_table')
seder_table = config.get('Path','seder_table')
talmud_seder_table = config.get('Path','talmud_seder_table')
massechet_table = config.get('Path','massechet_table')
talmud_massechet_table = config.get('Path','talmud_massechet_table')
massechet_perek_table = config.get('Path','massechet_perek_table')

# Path of data insertion files

toshba_data = config.get('Path','toshba_data')
talmud_type_data = config.get('Path','talmud_type_data')
seder_data = config.get('Path','seder_data')
talmud_seder_data = config.get('Path','talmud_seder_data')
massechet_data = config.get('Path','massechet_data')
talmud_massechet_data = config.get('Path','talmud_massechet_data')

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


creation_table(toshba_table)
creation_table(talmud_type_table)
creation_table(seder_table)
creation_table(talmud_seder_table)
creation_table(massechet_table)
creation_table(talmud_massechet_table)
creation_table(massechet_perek_table)


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


insert_data(toshba_data)
insert_data(talmud_type_data)
insert_data(seder_data)
insert_data(talmud_seder_data)
insert_data(massechet_data)
insert_data(talmud_massechet_data)












