import xml.etree.ElementTree as ET
import os
import configparser


config = configparser.ConfigParser()
config.read('settings.ini')

base_path_xml_file = config.get('Path','base_path_of_xml_files')

dir_list = os.listdir(base_path_xml_file) 
for item in dir_list:
    dir_list2 = os.listdir(base_path_xml_file+item)
    for item2 in dir_list2:
        print(base_path_xml_file+item+"\\\\"+item2)
    
    
    
tree = ET.parse('C:\\Git\\limud-kodesh\\FilesAndStuffs\\ImportsDataFrom3rdParty\\TalmudBavli\\Code\\shas_XML\\01-berachot\\001-berachot.2.1.xml')
root = tree.getroot()
# print(root[1][0][0][0][0].tag)
# for elem in tree.iter(tag="masechet"):
#     print (elem[0].tag, elem[0].attrib)   
