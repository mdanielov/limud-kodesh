import xml.etree.cElementTree as ET
import os
import configparser
import pyodbc

config = configparser.ConfigParser()
config.read(os.path.join(os.path.abspath(os.path.dirname(__file__)), 'settings.ini'))
database_name = config.get("Sql", "database_name")
server = config.get("Sql", "Server")


conn = pyodbc.connect('Driver={SQL Server};'
                      'Server=' + server + ';'
                                           'Database=' + database_name + ';'
                                                                         'Trusted_Connection=yes;',
                      autocommit=True, encoding='utf-8')

cursor = conn.cursor()

def execute_query(query):
    with conn:
        cursor = conn.cursor()
        cursor.execute(query)
    return cursor



def main():
    
    execute_query(f"USE KiMeTzion;")
    query_string = f""" 
DECLARE @Sefer_Name NVARCHAR(50),
        @Perek_Num INT,
		@Pasuk_Num INT,
		@Word_Position INT

SET @Sefer_Name = 'Zekharyah'
SET @Perek_Num = '5'
SET @Pasuk_Num = '7'
SET @Word_Position = '6'


SELECT FULL_WORD,LETTER,LETTER_POSITION_IN_WORD,LETTER_NAME,L.LETTER_ID,RL.UNICODE_VALUE FROM
(
SELECT W.FULL_WORD,W.WORD_ID,PE.PEREK_NUM FROM TBL_TANAKH_WORD W
JOIN TBL_TANAKH_PEREK_PASUK PP ON  PP.PEREK_PASUK_ID = W.PEREK_PASUK_ID 
JOIN TBL_TANAKH_PASUK P ON P.PASUK_ID = PP.PASUK_ID 
JOIN TBL_TANAKH_SEFER_PEREK SP ON SP.SEFER_PEREK_ID = PP.SEFER_PEREK_ID
JOIN TBL_TANAKH_PEREK PE ON PE.PEREK_ID = SP.PEREK_ID
JOIN TBL_TANAKH_SEFER S ON S.SEFER_ID = SP.SEFER_ID
WHERE S.SEFER_ENGLISH_NAME = @Sefer_Name and PE.PEREK_NUM = @Perek_Num AND P.PASUK_NUM = @Pasuk_Num AND W.WORD_POSITION = @Word_Position
) A
JOIN TBL_LETTER L ON A.WORD_ID = L.WORD_ID
JOIN TBL_REF_LETTER RL ON RL.LETTER_ID = L.REF_LETTER_ID
ORDER BY L.LETTER_ID 
"""
    result_query = execute_query(query_string)
    
    get_letter = []
    
    for row in result_query:
        get_letter.append(row)  

    print(get_letter)
    
    return get_letter

if __name__ == '__main__':
    main()