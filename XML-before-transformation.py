import os
import os.path
import shutil
from zipfile import ZipFile


IGNORE_XHTML = shutil.ignore_patterns('*.xhtml')
IGNORE_SECONDARY = shutil.ignore_patterns('*.opf', 'back*', '*cover*',
                                          'half*', 'toc*', 'css', 'font')

# read all files in the transformation folder
folder = os.path.dirname(os.path.abspath(__file__))
foldercontent = os.listdir(folder)
for file in foldercontent:
    # finds and renames the epub file
    if file.lower().endswith('.epub'):
        epub = file
        epubname = os.path.splitext(epub)[0]
        newepubname = epubname+'.zip'
        os.rename(epub, newepubname)
    # if already renamed, locates the zip folder
    elif file.lower().endswith('.zip'):
        zipfolder = file
        epubname = os.path.splitext(zipfolder)[0]
        newepubname = zipfolder
    # finds and renames the doi deposit file
    elif file.lower().endswith('.xml'):
        deposit = file
        depositext = os.path.splitext(file)[1]
        newdepositname = 'doi-deposit' + depositext
        os.rename(deposit, newdepositname)

# choose a destination for the files extracted from the zipped folder
intermediatefolder = folder+'/'+epubname+'-original-epub-files'


# extract content from zipped folder
def extract(zipFilename, dm_extraction_dir):
    zipTest = ZipFile(zipFilename)
    zipTest.extractall(dm_extraction_dir)


extract(newepubname, intermediatefolder)

# copy files selectively from OEBPS to the transformation input folder
oebpsfolder = intermediatefolder+'/OEBPS'
inputfolder = folder+'/input'
if not os.path.exists(inputfolder):
    shutil.copytree(oebpsfolder, inputfolder, symlinks=False,
                    ignore=IGNORE_SECONDARY)
else:
    shutil.rmtree(inputfolder)
    shutil.copytree(oebpsfolder, inputfolder, symlinks=False,
                    ignore=IGNORE_SECONDARY)

# copy images from input folder to XML folIGNORE_XHTMLder
imagefolder = folder+'/input/image'
XMLfolder = folder+'/XML-edition/image'
if not os.path.exists(XMLfolder):
    shutil.copytree(imagefolder, XMLfolder, symlinks=False,
                    ignore=IGNORE_XHTML)
else:
    shutil.rmtree(XMLfolder)
    shutil.copytree(imagefolder, XMLfolder, symlinks=False,
                    ignore=IGNORE_XHTML)

# copy audio from input folder to XML folder
audiofolder = folder+'/input/audio'
XMLaudiofolder = folder+'/XML-edition/audio'
if os.path.exists(audiofolder):
    if not os.path.exists(XMLaudiofolder):
        shutil.copytree(audiofolder, XMLaudiofolder, symlinks=False,
                        ignore=IGNORE_XHTML)
    else:
        shutil.rmtree(XMLaudiofolder)
        shutil.copytree(audiofolder, XMLaudiofolder, symlinks=False,
                        ignore=IGNORE_XHTML)


# copy videos from input folder to XML folder
videofolder = folder+'/input/video'
XMLvideofolder = folder+'/XML-edition/video'
if os.path.exists(videofolder):
    if not os.path.exists(XMLvideofolder):
        shutil.copytree(videofolder, XMLvideofolder, symlinks=False,
                        ignore=IGNORE_XHTML)
    else:
        shutil.rmtree(XMLvideofolder)
        shutil.copytree(videofolder, XMLvideofolder, symlinks=False,
                        ignore=IGNORE_XHTML)
