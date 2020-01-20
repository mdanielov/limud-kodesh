import xml.etree.cElementTree as ET
import os



parent_dir = "C:\\Git\\limud-kodesh\\ImportsData\\Tanakh\\FromSefaria\\XMLFilesProcessed"


xml_list = os.listdir(parent_dir)

chapter_num = []
pasuk_num = []

for xml_file in xml_list:

    book_name = None
    del chapter_num[:]
    del pasuk_num[:]

    xml_path = parent_dir + "\\" + xml_file

    tree = ET.ElementTree(file=xml_path)

    for elem in tree.iter():
        if elem.tag == 'Word' and book_name is None:
            book_name = elem.attrib['Book']
            # if elem.attrib == 'Book' and book_name is None:
            #     print(elem.attrib['Book'])
            #     book_name = elem.attrib['Book']

    print(book_name)