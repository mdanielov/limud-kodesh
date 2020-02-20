cd "C:\Git\limud-kodesh\database\DB_Table_creation\"
python create_insert_all.py
python insert_data_to_tbl_perek_tanakh.py
python insert_data_to_tbl_tanakh_pasuk.py
cd "C:\Git\limud-kodesh\database\DB_Table_creation\tanakh_sefer_perek_insert\"
python tbl_tanakh_sefer_perek_insert.py
cd ..
python insert_data_to_tbl_perek_pasuk.py
cd "C:\Git\limud-kodesh\database\DB_Table_creation\Tanakh_sefaria_word_to_DB\"
python xml_tanakh_parser.py
cd "C:\Git\limud-kodesh\database\DB_Table_creation\Tanakh_sefaria_letters_to_DB\"
python letters_parser.py
pause