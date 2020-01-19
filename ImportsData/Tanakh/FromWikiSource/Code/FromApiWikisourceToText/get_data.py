import requests
import json

isEnd = False

def get_and_print_data(url, row):
      book = row
      r = requests.get(url)
      info = r.json()
    #   print('*************************************************************************')
      attributes = book.__dict__
    #   pp.pprint(info['query']['pages'])
      with open('./Tanach-text/{}.txt'.format(attributes['english']),'a',encoding='utf-8') as f :
          for key in info['query']['pages']:
            #   print(key)
              if(key == '-1') :
                  global isEnd
                  isEnd = True
                  break
              else:
                  result = str(info['query']['pages'][key]['cirrusbuilddoc']['text'])
                  # f.write(result+'\r\n')
                  f.close()