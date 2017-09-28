import os
import os.path
import zipfile
import shutil
import re

#read all files in the transformation folder
folder=os.path.dirname(os.path.abspath(__file__))
foldercontent=os.listdir(folder)
for file in foldercontent:
    #finds and renames the epub file
    if re.search('epub', file)!=None:
        epub=file
        epubname=os.path.splitext(epub)[0]
        newepubname=epubname+'.zip'
        os.rename(epub, newepubname)
    #if already renamed, locates the zip folder
    elif re.search('zip', file)!=None:
        zipfolder=file
        epubname=os.path.splitext(zipfolder)[0]
        newepubname=zipfolder
    #finds and renames the doi deposit file
    elif re.search('xml', file)!=None:
        deposit=file
        depositext=os.path.splitext(file)[1]
        newdepositname='doi-deposit'+depositext
        os.rename(deposit, newdepositname)
        
#choose a destination for the files extracted from the zipped folder
intermediatefolder=folder+'/'+epubname+'-original-epub-files'

#extract content from zipped folder
from zipfile import ZipFile
def extract(zipFilename, dm_extraction_dir) :
   zipTest = ZipFile(zipFilename)
   zipTest.extractall(dm_extraction_dir)
extract(newepubname, intermediatefolder)

#copy files selectively from OEBPS to the transformation input folder
from shutil import copytree, ignore_patterns
oebpsfolder=intermediatefolder+'/OEBPS'
inputfolder=folder+'/input'
if os.path.exists(inputfolder)==False:
    shutil.copytree(oebpsfolder, inputfolder, symlinks=False, ignore=ignore_patterns('*.opf', 'back*', '*cover*', 'half*', 'toc*', 'css', 'font'))
else:
    shutil.rmtree(inputfolder)
    shutil.copytree(oebpsfolder, inputfolder, symlinks=False, ignore=ignore_patterns('*.opf', 'back*', '*cover*', 'half*', 'toc*', 'css', 'font'))

#copy images from input folder to XML folder
imagefolder=folder+'/input/image'
XMLfolder=folder+'/XML-edition/image'
if os.path.exists(XMLfolder)==False:
    shutil.copytree(imagefolder, XMLfolder, symlinks=False, ignore=ignore_patterns('*.xhtml'))
else:
    shutil.rmtree(XMLfolder)
    shutil.copytree(imagefolder, XMLfolder, symlinks=False, ignore=ignore_patterns('*.xhtml'))

#copy audio from input folder to XML folder
audiofolder=folder+'/input/audio'
XMLaudiofolder=folder+'/XML-edition/audio'
if os.path.exists(audiofolder)==True:
    if os.path.exists(XMLaudiofolder)==False:
        shutil.copytree(audiofolder, XMLaudiofolder, symlinks=False, ignore=ignore_patterns('*.xhtml'))
    else:
        shutil.rmtree(XMLaudiofolder)
        shutil.copytree(audiofolder, XMLaudiofolder, symlinks=False, ignore=ignore_patterns('*.xhtml'))


#copy videos from input folder to XML folder
videofolder=folder+'/input/video'
XMLvideofolder=folder+'/XML-edition/video'
if os.path.exists(videofolder)==True:
    if os.path.exists(XMLvideofolder)==False:
        shutil.copytree(videofolder, XMLvideofolder, symlinks=False, ignore=ignore_patterns('*.xhtml'))
    else:
        shutil.rmtree(XMLvideofolder)
        shutil.copytree(videofolder, XMLvideofolder, symlinks=False, ignore=ignore_patterns('*.xhtml'))
