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





    

  



# def create_query_string(sql_full_path):
#     with open(sql_full_path, 'r') as f_in:
#         lines = f_in.read()
#         # remove any common leading whitespace from every line
#         query_string = textwrap.dedent("""{}""".format(lines))
#     print(query_string)
#     return query_string



