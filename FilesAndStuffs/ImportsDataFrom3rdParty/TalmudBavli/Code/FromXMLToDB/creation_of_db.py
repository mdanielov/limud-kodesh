import sql_connect 



def main():
    # check if db exists on target, if not create
    qry_create_db = "if not exists(select * from sys.databases where name = '{}') create database {};".format('KiMeTztion','KiMeTztion')
    with sql_connect.conn:
        cur1 = sql_connect.cursor.execute(qry_create_db)
        cur1.commit() 
   
main() 

    
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

creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\TOSHBA.sql')
creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\TALMUD_TYPE.sql')
creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\SEDER.sql')
creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\TALMUD_SEDER.sql')
creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\MASSECHET.sql')
creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\TALMUD_MASSECHET.sql')
creation_table('C:\\Git\\limud-kodesh\\ki_metzion\\schema\\TABLES\\MASSECHET_PEREK.sql')

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

insert_data('C:\\Git\\limud-kodesh\\ki_metzion\\data\\toshba.sql')
insert_data('C:\\Git\\limud-kodesh\\ki_metzion\\data\\talmud_type.sql')
insert_data('C:\\Git\\limud-kodesh\\ki_metzion\\data\\seder.sql')
insert_data('C:\\Git\\limud-kodesh\\ki_metzion\\data\\talmud_seder.sql')
insert_data('C:\\Git\\limud-kodesh\\ki_metzion\\data\\massechet.sql')
insert_data('C:\\Git\\limud-kodesh\\ki_metzion\\data\\talmud_massechet.sql')









