 # coding=utf-8 
import pprint
import csv_read
import configparser
import get_data

pp = pprint.PrettyPrinter(indent=4)
config = configparser.ConfigParser()
config.read('settings.ini')
file_name = config.get('data','list')

listOfBooks = csv_read.read_csv(file_name)

for book in listOfBooks:
    
    get_data.isEnd = False
    
    attributes = book.__dict__
        
    listNumbers = ['א','ב','ג','ד','ה','ו','ז','ח','ט','י','יא','יב','יג','יד','טו','טז','יז','יח','יט','כ','כא','כב','כג','כד','כה','כו','כז','כח','כט','ל','לא','לב','לג','לד','לה','לו','לז','לח','לט','מ','מא','מב','מג','מד','מה','מו','מז','מח','מט','נ','נא','נב','נג','נד','נה','נו','נז','נח','נט','ס','סא','סב','סג','סד','סה','סו','סז','סח','סט','ע','עא','עב','עג','עד','עה','עו','עז','עח','עט','פ','פא','פב','פג','פד','פה','פו','פז','פח','פט','צ','צא','צב','צג','צד','צה','צו','צז','צח','צט','ק','קא','קב','קג','קד','קה','קו','קז','קח','קט','קי','קיא','קיב','קיג','קיד','קטו','קטז','קיז','קיח','קיט','קכ','קכא','קכב','קכג','קכד','קכה','קכו','קכז','קכח','קכט','קל','קלא','קלב','קלג','קלד','קלה','קלו','קלז','קלח','קלט','קמ','קמא','קמב','קמג','קמד','קמה','קמו','קמז','קמח','קמט','קנ']
        
    for number in listNumbers:
        
        base_url='https://he.wikisource.org/w/api.php?action=query&titles={}_{}/טעמים&prop=cirrusbuilddoc&format=json&origin=*'.format(attributes['hebrew'],number)
        get_data.get_and_print_data(base_url, book)
        if(get_data.isEnd == True):
            break
        