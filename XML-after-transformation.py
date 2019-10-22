import os
import os.path
import shutil
import re
import xml.etree.ElementTree as ET

XMLfolder=os.path.join(os.path.dirname(os.path.abspath(__file__)),
                       'XML-edition')
ET.register_namespace('', 'http://www.tei-c.org/ns/1.0')

filelist=os.listdir(XMLfolder)
for f in filelist:
  file=os.path.join(XMLfolder, f)
  if os.path.isfile(file):
    tree = ET.parse(file)
    root = tree.getroot()
    #fix internal reference system in entire-book.xml
    if re.search('entire-book', file)!=None:
      reflist = root.findall('.//{http://www.tei-c.org/ns/1.0}ref')
      for ref in reflist:
        dest=ref.get('target')
        if re.search('.xml', dest)!=None:
          newdest=re.sub(r'(.+?\.xml)',r'entire-book.xml', dest)
        else:
          newdest=dest
        ref.set('target', newdest)
    #fix image relative URLs in entire-book.xml
      teilist = root.findall('.//{http://www.tei-c.org/ns/1.0}TEI')
      for tei in teilist:
        base=tei.get('{http://www.w3.org/XML/1998/namespace}base')
        if re.search(r'XML-edition\/', base)!=None:
          newbase=re.sub(r'XML-edition\/',r'', base)
        else:
          newbase=base
        tei.set('{http://www.w3.org/XML/1998/namespace}base', newbase)
    #delete empty items across all files
    lists = root.findall('.//{http://www.tei-c.org/ns/1.0}list')
    for entry in lists:
      items = root.findall('.//{http://www.tei-c.org/ns/1.0}item')
      for item in items:
        if item.text == None:
          entry.remove(item)
    #delete empty divs across all files
    for parent in root.findall('.//{http://www.tei-c.org/ns/1.0}div/..'):
      for element in parent.findall('{http://www.tei-c.org/ns/1.0}div'):
        if list(element)== []:
          parent.remove(element)
    #delete tabs in footnotes
    notes = root.findall('.//{http://www.tei-c.org/ns/1.0}note//')
    for note in notes:
      fnote = note.text
      if fnote != None:
        if re.search('\t', fnote)!=None:
          nfnote = fnote.replace('\t','')
          note.text = nfnote
          
    tree.write(file)


