import pyodbc 
import configparser

config = configparser.ConfigParser()
config.read('settings.ini')
server_name = config.get('Sql_Identifiers','Server')



def sql_connect():
    conn = pyodbc.connect('Driver={SQL Server};'
                      'Server='+ server_name + ';'
                      'Database=master;'
                      'Trusted_Connection=yes;',
                      autocommit=True)
    return conn.cursor()



    
