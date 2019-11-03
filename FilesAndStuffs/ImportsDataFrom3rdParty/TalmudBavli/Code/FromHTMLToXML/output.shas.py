
import ParseMy
import os
import codecs
import re
from reference import massechet
import TranformToXML
import datetime
import paths
import reference

base_input_dir = paths.output_base_input_dir
base_output_dir = paths.output_base_output_dir
dir_separator = paths.output_dir_separator
prakim = reference.prakim
marker_mishna1 = reference.marker_mishna1
marker_mishna2 = reference.marker_mishna2
marker_gemara = reference.marker_gemara
current_chapter = 0
hadran = 0 #special indicator for hadran that falls to the last line of a page
gema = 0 #special indicator for check if i am in gemara or mishna

def write_file(content, file_name):
    fd = codecs.open(file_name, 'w', 'UTF-8')
    fd.write(content)
    fd.close()

def remove_blank(line_list):
        new_list = []
        # remove blank lines
        for index, line in enumerate(line_list):
            line = line.strip()
            line = re.sub(r"^('|\")", "", line)
            line = re.sub(r"('|\")$", "", line)
            line = line.strip()
            if len(line) > 0:
                new_list.append(line)

        return new_list

def xml_header(heb_name,mas_no,daf_no,amud_no):
    xml_header_text = '\n'.join([
        '<?xml version="1.0" encoding="utf-8" ?>',
        '<root>',
        '  <meta>',
        '   <version>Vilna</version>',
        '   <bookPublishing>Oz Vehadar</bookPublishing>',
        '   <resourceType>webCrawler</resourceType>',
        '   <refUri>http://...</refUri>',
        '   <handlingBy>Mordechai Danielov</handlingBy>',
        '   <dateCreated>'+str(datetime.datetime.now())+'</dateCreated>',
        '   <lastModified>'+str(datetime.datetime.now())+'</lastModified>',
        ' </meta>',
        ' <masechet name="'+heb_name+'" serial="'+mas_no+'">',
        '<daf value="'+daf_no+'">',
        '\t<amud value="'+amud_no+'">'
    ])+'\n'
    return xml_header_text

def xml_footer():
    return '</amud>\n' \
           '</daf>\n' \
           '</masechet>\n' \
           '</root>'


for t in massechet:
    print("working on " + t[3])
    massechet_num = t[0]
    massechet_name = t[3]
    daf_end = str(t[1])
    amud_end = str(t[2])
    massechet_name_he = t[4]
    current_chapter = 0

    #get chapters
    i = 1

    for ch in prakim:
        if ch[0] == massechet_name:
            if i == 1:
                chapters = ((i, ch[1], ch[2], ch[3], ch[4], ch[5],),)
                i += 1
            else:
                chapters +=  ((i ,ch[1], ch[2], ch[3], ch[4], ch[5]),)
                i += 1

    #set working directories for this massechet
    input_directory = base_input_dir + str(massechet_num) + "-" + massechet_name + dir_separator
    output_directory = base_output_dir + str(massechet_num) + "-" + massechet_name + dir_separator

    #check if source directory exists
    if not os.path.exists(input_directory):
        raise ValueError('input directory not found')

    #if destination directory doesn't exist, create it
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    #itereate through files for this massechet
    for i in os.listdir(input_directory):
        #basic page info
        daf_no = i.split(".")[1]
        amud_no = i.split(".")[2]

        #read the source file
        file_to_open = input_directory+i
        f = codecs.open(file_to_open,'r','UTF-8')
        filetext = str(f.readlines())
        f.close()

        #parse out the shastext section
        parser = ParseMy.MyHTMLParser('shastext2')
        parser.feed(filetext)


        #save it to a destination file
        # ****************************************
        # --- : file extension and output file name
        j = i.replace('.html','.xml')
        file_to_write = output_directory + j

        # -- : open file for writing and create header
        line_list = parser.return_string.split(',')
        fd = codecs.open(file_to_write, 'w', 'UTF-8')
        fd.write(xml_header(massechet_name_he,massechet_num,daf_no,amud_no))

        # -- : remove blank lines from input
        new_list = remove_blank(line_list)

        # -- : parse text and add XML markers for Mishna and Gemara
        output_text = ""
        for index,line in enumerate(new_list):
            lines = []
            # parsing logic may need to know one line before and after current (if available)
            if index == 0:
                # file start
                lines =["",line,new_list[index+1]]
            elif index <= len(new_list) -2:
                # middle of the file
                lines =[new_list[index-1],line,new_list[index+1]]
            elif index == len(new_list) -1:
                # last line
                lines =[new_list[index-1],line,""]
            print(current_chapter, len(chapters))
            print(daf_no,amud_no,hadran, index, str(len(new_list)))
            if len(chapters)-1 > current_chapter:
                chap_param = (chapters[current_chapter],chapters[current_chapter+1])
            else:
                chap_param = (chapters[current_chapter],chapters[current_chapter])

            if daf_no == daf_end and amud_no == amud_end:
                islast = 1
            else:
                islast = 0
            results = TranformToXML.parseLine(lines, index, len(new_list), i , daf_no , amud_no, marker_mishna1, marker_mishna2, marker_gemara, chap_param, current_chapter, hadran, islast, gema)
            if index != len(new_list) - 1 or (index == len(new_list) - 1 and len(lines[1].split()) > 1):
              output_text += results[0]
            current_chapter = results[1]
            hadran = results[2]
            gema = results[3]



        fd.write(output_text)
        fd.write(xml_footer())
        fd.close()


