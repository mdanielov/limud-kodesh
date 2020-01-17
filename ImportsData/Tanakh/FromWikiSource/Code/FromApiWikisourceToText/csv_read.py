import csv

class Books:
    def __init__(self, english,hebrew):
        self.english = english
        self.hebrew = hebrew
    
    def __str__(self):
        return str(self.__class__) + ": " + str(self.__dict__)    

def read_csv(file_name):
    with open(file_name, encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter='|')
        data_list = []

        for index, row in enumerate(csv_reader) :
            data = Books(row[0],row[1])
            data_list.append(data)
        return data_list