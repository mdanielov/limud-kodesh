import re

def parseLine(lines , index , index_max , file_name , daf , amud, marker_mishna1,marker_mishna2, marker_gemara, marker_gemara2, marker_gemara3, chapters, current_chapter, hadran, islast, gema ):
    # some lines are not going to be transferred to the DB
    # but we want them in the XML file anyhow

    isdata = "1"
    if index == index_max - 1 or re.search('הדרן עלך',lines[1]):
        isdata = "0"

    if index == index_max -1 and re.search('הדרן עלך',lines[1]) and islast == 0:
        hadran = 1
        current_chapter +=1

    #set starting text
    line_text = lines[1]

    if index == 0:
        if gema == 0:
            line_text = '<ContChapter name = "' + chapters[0][5] + '"/>' + '<ContMishna/>' + line_text
        else:
            line_text = '<ContChapter name = "' + chapters[0][5] + '"/>' + '<ContGemara/>' + line_text

    if (index == 0 and daf == "2" and amud == "1") or (index == 0 and hadran == 1):
        line_text = '<StartChapter name = "' + chapters[0][5]+'"/><StartMishna/>' + line_text
        hadran = 0
        gema = 0

    if (re.search('הדרן עלך',lines[0]) and islast == 0):
        gema = 0
        if index !=0:
         line_text = '<StartChapter name = "' + chapters[1][5]+'"/><StartMishna/>' + line_text
        if index == 0:
         line_text += '<StartChapter name = "' + chapters[1][5] + '"/><StartMishna/>' + line_text
        current_chapter +=1


    #is this the end of a chapter or massechet?
    if index == index_max or re.search('הדרן עלך',lines[2]):
        gema = 0
        line_text = line_text + '<EndChapter name = "' + chapters[0][5]+'"/>' + "<EndGemara/>"        
    
    if re.search(marker_gemara, lines[1]):
        sub_lines = re.split(marker_gemara, lines[1])
        gema = 1
        if index != 0 and re.search('הדרן עלך',lines[2]):
            line_text = sub_lines[0] + "<EndMishna/><StartGemara/>" + marker_gemara + sub_lines[1] + '<EndChapter name = "' + chapters[0][5]+'"/>' + "<EndGemara/>"
        if index != 0 and re.search('הדרן עלך',lines[2]) == None:
            line_text = sub_lines[0] + "<EndMishna/><StartGemara/>" + marker_gemara + sub_lines[1]
        if index == 0:
            line_text += sub_lines[0] + "<EndMishna/><StartGemara/>" 
    
    if re.search(marker_gemara2, lines[1]):      
        sub_lines = re.split(marker_gemara2, lines[1])
        print(sub_lines)
        gema = 1
        if index != 0 and re.search('הדרן עלך',lines[2]) == None:
            line_text = sub_lines[0] + "<EndMishna/><StartGemara/>" + "(גמ')" + sub_lines[1] 
    
    if re.search(marker_gemara3, lines[1]):      
        sub_lines = re.split(marker_gemara3, lines[1])
        print(sub_lines)
        gema = 1
        if index != 0 and re.search('הדרן עלך',lines[2]) == None:
            line_text = sub_lines[0] + "<EndMishna/><StartGemara/>" + "[גמ'" + sub_lines[1]               
    
    if re.search(marker_mishna1, lines[1]):
        sub_lines = re.split(marker_mishna1,lines[1])
        gema = 0
        if index == 0:
            line_text += sub_lines[0] + "<EndGemara/><StartMishna/>"
        if index != 0:
            line_text = sub_lines[0] + "<EndGemara/><StartMishna/>" + "מתני'" + sub_lines[1]

    if re.search(marker_mishna2, lines[1]):
        sub_lines = re.split(marker_mishna2, lines[1])
        gema = 0
        if index == 0:
            line_text += sub_lines[0] + "<EndGemara/><StartMishna/>"
        if index != 0:
            line_text = sub_lines[0] + "<EndGemara/><StartMishna/>" + "מתני'" + sub_lines[1]

    new_line = '\t\t<row row_number="'+str(index+1)+'" isdata="'+isdata+'">'+line_text+'</row>\n'
    return (new_line,current_chapter, hadran, gema)