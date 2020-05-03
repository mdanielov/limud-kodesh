** Add_yerushalmi_chapters.py settings.ini sample :

[SQL]
server=DESKTOP-P91JIG3\SQLEXPRESS
database_name=KiMeTzion
[Path]
C:\Git\limud-kodesh\database\DB_Table_creation\YERUSHALMI_XML_PEREK

** create_insert_all.py settings.ini sample :

[Sql]
server=DESKTOP-P91JIG3\SQLEXPRESS
[Path]
schema_dir=C:\Git\limud-kodesh\database\ki_metzion\schema
data_dir=C:\Git\limud-kodesh\database\ki_metzion\data


**insert_data_to_tbl_perek_pasuk.py settings.ini sample:

[Sql]
Server=DESKTOP-P91JIG3\SQLEXPRESS
database_name = KiMeTzion
[Path]
schema_dir=C:\Git\limud-kodesh\database\ki_metzion\schema
data_dir=C:\Git\limud-kodesh\database\ki_metzion\data
parent_dir = C:\Git\limud-kodesh\ImportsData\Tanakh\FromSefaria\XMLFilesProcessed


** insert_data_to_tbl_perek_tanakh.py settings.ini sample :

[Sql]
server=DESKTOP-P91JIG3\SQLEXPRESS


** insert_data_to_tbl_tanakh_pasuk.py settings.ini sample :

[Sql]
server=DESKTOP-P91JIG3\SQLEXPRESS


** Tanakh_sefaria_letters_to_DB settings.ini sample:

[XML]
current_dir=C:\Git\limud-kodesh\ImportsData\Tanakh\FromSefaria\XMLFilesProcessed
[SQL]
server=LAPTOP-G7A1FT2J
table_names=TBL_LETTER, TBL_NIKKUD_LETTER, TBL_TAAM_LETTER
database_name=KiMeTzion
[CSV]
csv_file_name_letter=TBL_TANAKH_LETTERS_Data_insert.csv
csv_file_name_nikkud=TBL_TANAKH_NIKKUD_Data_insert.csv
csv_file_name_taam=TBL_TANAKH_TAAM_Data_insert.csv



** Tanakh_sefaria_word_to_DB settings.ini sample :

[XML]
current_dir=C:\Git\limud-kodesh\ImportsData\Tanakh\FromSefaria\XMLFilesProcessed
[SQL]
server=LAPTOP-G7A1FT2J
table_names=TBL_TANAKH_WORD
database_name=KiMeTzion
[CSV]
csv_file_name=C:\Git\limud-kodesh\database\DB_Table_creation\Tanakh_sefaria_word_to_DB\TBL_TANAKH_WORD_Data_insert.csv


** Tanakh_sefaria_letters_to_db settings.ini sample :

[XML]
current_dir=C:\Git\limud-kodesh\ImportsData\Tanakh\FromSefaria\XMLFilesProcessed
[SQL]
server=LAPTOP-G7A1FT2J
table_names=TBL_LETTER, TBL_NIKKUD_LETTER, TBL_TAAM_LETTER
database_name=KiMeTzion
[CSV]
csv_file_name_letter=TBL_TANAKH_LETTERS_Data_insert.csv
csv_file_name_nikkud=TBL_TANAKH_NIKKUD_Data_insert.csv
csv_file_name_taam=TBL_TANAKH_TAAM_Data_insert.csv

** tanakh_sefer_perek_insert settings.ini sample :

[SQL]
database_name = KiMeTzion
server = LAPTOP-G7A1FT2J



