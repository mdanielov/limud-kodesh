import os
import re
import parse
from bs4 import BeautifulSoup


# list_of_files = os.listdir("./YerushalmiHTML")

# for file in list_of_files:



with open("YerushalmiHTML\\Makot.htm","r") as f:
        with open("YerushalmiXML\\Makot.xml","w+") as x:
            
            x.write('<Start Massechet name="Orla">\n')
            
            
            file_text = str(f.readlines())
            soup = BeautifulSoup(file_text,'html.parser')
            
            
            first_perek = soup.find('h2')
            all_p = first_perek.find_next_siblings('p')
            all_b = soup.find_all('b')
            
            inMishna = False
            inGuemara = False
            list_of_perek = []
            index_of_end_mishna = []
            number_of_perek = 1
            number_of_halacha = 1
            after_mishna = False
            
            for index,p in enumerate(all_p):
                                                        
                    if re.search('משנה</b>',str(p)):

                        if re.search('הלכה א משנה',str(p)) and inMishna == False and len(list_of_perek) == 0:
                            x.write('\t<StartPerek number={}>'.format(number_of_perek)+'\n\t\t<StartHalacha number ={}>'.format(number_of_halacha)+'\n\t\t<StartMishna>'+'\n'+'\t\t\t'+p.text+'\n'+'\t\t'+'<EndMishna>')
                            list_of_perek.append(index)
                            index_of_end_mishna.append(index)
                            number_of_perek += 1
                            continue   
                        if re.search('הלכה א משנה',str(p)) and re.search(':',str(p)) != None and inMishna == False and len(list_of_perek) > 0: 
                            number_of_halacha = 1 
                            x.write('\t\t<EndGuemara>'+'\n'+'\t\t<End Halacha>\t\t\n'+'\t'+'<EndPerek number={}>'.format(number_of_perek-1)+'\n'+'\t<StartPerek number={}>'.format(number_of_perek)+'\n\t\t'+'<StartMishna>\n\t\t\t'+p.text+'\n\t\t<EndMishna>\n') 
                            list_of_perek.append(index)  
                            number_of_perek += 1
                            continue
                        if re.search('הלכה א משנה',str(p)) and re.search(':',str(p)) == None and len(list_of_perek) > 0:  
                            x.write('\t\t<EndGuemara>'+'\n'+'\t\t<End Halacha>\t\t\n'+'\t'+'<EndPerek number={}>'.format(number_of_perek-1)+'\n'+'\t<StartPerek number={}>'.format(number_of_perek)+'\n\t\t'+'<StartMishna>\n') 
                            list_of_perek.append(index)  
                            number_of_perek += 1
                            inMishna = True
                            continue
                        if re.search(':',str(p)) == None:
                            number_of_halacha +=1
                            x.write('\n\t\t<Start Halacha>\t\t\n'+'\n\t\t<StartMishna>'+'\n'+'\t\t\t'+p.text+'\n')
                            inMishna = True
                            continue
                        if re.search(':',str(p)) != None and inMishna == False:
                            number_of_halacha += 1
                            x.write('\n\t\t<Start Halacha>\t\t\n'+'\n\t\t<StartMishna>'+'\n'+'\t\t\t'+p.text+'\n'+'\t\t'+'<EndMishna>\t\t')
                            after_mishna = True 
                            index_of_end_mishna.append(index)
                            continue
                        if re.search(':',str(p)) != None and inMishna == True:
                            x.write('\t\t\t'+p.text+'\n'+'\t\t'+'<EndMishna>\t\t') 
                            inMishna = False
                            after_mishna = True
                            index_of_end_mishna.append(index)
                            inGuemara = False
                            continue
                            
                    if re.search('גמרא</b>',str(p)):
                        
                        if index -1 == index_of_end_mishna[-1]:
                            x.write('\n\t\t'+'<StartGuemara>'+'\n') 
                            inGuemara = True   
                        if re.search(':</p>',str(p)) == None:
                            x.write('\t\t\t'+p.text+'\n')
                            after_mishna = False
                            continue
                        if re.search(':</p>',str(p)) != None:
                            x.write('\t\t\t'+p.text+'\n'+'\t\t<EndGuemara>\t\t'+'\n\t\t<End Halacha>\t\t') 
                            inGuemara = False
                            continue     
                    
            if inGuemara == True:
                x.write('\t\t<EndGuemara>\t\t'+'\n\t\t<End Halacha>\t\t'+'\n\t<EndPerek number={}>'.format(number_of_perek-1)+'\n'+'<End Massechet name="Orla">\n')

            if inGuemara == False:
                x.write('\n\t\t<End Halacha>\t\t'+'\n\t<EndPerek number={}>'.format(number_of_perek-1)+'\n'+'<End Massechet name="Orla">\n')


                    
            
            
            
            
            
                          
            
    
