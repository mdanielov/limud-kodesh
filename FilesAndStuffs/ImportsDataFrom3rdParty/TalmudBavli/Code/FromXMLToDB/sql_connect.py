import pyodbc 
import configparser
import re

config = configparser.ConfigParser()
config.read('settings.ini')
server_name = config.get('Sql_Identifiers','Server')
Path_creation_of_tables = config.get('Path','creation_of_tables')
conn = pyodbc.connect('Driver={SQL Server};'
                      'Server='+server_name+';'
                      'Database=master;'
                      'Trusted_Connection=yes;',
                      autocommit=True)
cursor = conn.cursor()



    
