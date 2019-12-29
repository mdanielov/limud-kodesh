import xml.etree.cElementTree as ET
import os
import configparser


config = configparser.ConfigParser()
config.read('settings.ini')

parent_dir_path = config.get('XML','parent_dir')
massechet_dir_list = os.listdir(parent_dir_path) 


for massechet_dir in massechet_dir_list:
    
    daf = []
    amud = []
    chapter = []
    daf_start_chapter = []
    daf_end_chapter = []
    amud_start_chapter = []
    amud_end_chapter = []
    count_chapter = 0
    start = {}

    massechet_dir_path = parent_dir_path + "\\" + massechet_dir
    massechet_xml_list = os.listdir(massechet_dir_path)
    
    for xml in massechet_xml_list:
        
        xml_path = massechet_dir_path + "\\" + xml
        tree = ET.ElementTree(file=xml_path)
        
        for elem in tree.iter():
            if elem.tag == 'daf':
                daf.append(elem.attrib['value'])
            if elem.tag == 'amud':
                amud.append(elem.attrib['value'])
            if elem.tag == 'StartChapter':
                count_chapter += 1
                chapter.append(count_chapter)
                start["chapter"] = chapter[-1]
                start["daf_start"] = daf[-1]
                daf_start_chapter.append(start.copy())
            if elem.tag == 'EndChapter':
                
    # print(len(daf))
    # print(len(amud))
    # print(chapter)
    # print(daf_start_chapter)