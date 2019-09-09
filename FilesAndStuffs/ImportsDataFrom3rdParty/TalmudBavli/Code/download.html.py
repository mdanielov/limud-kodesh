
import requests
import os
#massechets
from reference import massechet

#static url specific variables
url_base = "http://hebrewbooks.org/shas.aspx?mesechta="
url_base2 = "&daf="
url_base3="&format=text"

#static output variables
base_dir = "C:\\Matarah\\limud-kodesh\\FilesAndStuffs\\ImportsDataFrom3rdParty\\TalmudBavli\\HTMLFilesFromHebrewBooks\\"

#daf start
daf_start = "2"
amud_start = "1"


for t in massechet:
    print("working on " + t[3])
    massechet_num = t[0]
    massechet_name = t[3]
    daf_end = str(t[1])
    amud_end = str(t[2])
    file_seq = 1
    seq_text = ""

    daf_url = "2"
    daf = daf_start
    amud = amud_start

    while True:
        directory = base_dir + str(massechet_num) + "-" + massechet_name + "\\"
        if not os.path.exists(directory):
            os.makedirs(directory)
        # file_name = directory + massechet_name + "."+ daf + "." + amud + ".txt"
        if file_seq < 100:
            if file_seq < 10:
                seq_text = "00"+str(file_seq)
            else:
                seq_text = "0"+ str(file_seq)
        else:
            seq_text = str(file_seq)

        file_name = directory + seq_text + "-" + massechet_name + "." + daf + "." + amud + ".html"
        file_seq +=1

        url = url_base + str(massechet_num) + url_base2 + daf_url + url_base3;
        # print(url)
        source_code = requests.get(url);
        plain_text = source_code.text;


        with open(file_name, 'w', -1, 'utf-8') as f:
            f.write(plain_text)
            #  f.write(parser.return_string)
            #  parser.close();

        print('working on daf {0} amud {1} out of {2}'.format(daf, amud, daf_end))

        if int(daf) == int(daf_end) and amud == amud_end:
            break
        if amud == "1":
            amud = "2"
            daf_url = daf + "b"
        else:
            daf = str(int(daf) + 1)
            amud = "1"
            daf_url = daf
