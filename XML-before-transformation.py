import os
import os.path
import shutil
from zipfile import ZipFile


DIR = os.path.dirname(os.path.abspath(__file__))
INPUT_DIR = DIR+'/input'
IMG_DIR = DIR+'/input/image'
XML_DIR = DIR+'/XML-edition/image'
AUDIO_DIR = DIR+'/input/audio'
XML_AUDIO_DIR = DIR+'/XML-edition/audio'
VIDEO_DIR = DIR+'/input/video'
XML_VIDEO_DIR = DIR+'/XML-edition/video'
IGNORE_XHTML = shutil.ignore_patterns('*.xhtml')
IGNORE_SECONDARY = shutil.ignore_patterns('*.opf', 'back*', '*cover*',
                                          'half*', 'toc*', 'css', 'font')

# read all files in the transformation directory
for file in os.listdir(DIR):
    # finds and renames the epub file
    if file.lower().endswith('.epub'):
        epub = file
        epubname = os.path.splitext(epub)[0]
        newepubname = epubname+'.zip'
        os.rename(epub, newepubname)
    # if already renamed, locates the zip file
    elif file.lower().endswith('.zip'):
        zipfile = file
        epubname = os.path.splitext(zipfile)[0]
        newepubname = zipfile
    # finds and renames the doi deposit file
    elif file.lower().endswith('.xml'):
        deposit = file
        depositext = os.path.splitext(file)[1]
        newdepositname = 'doi-deposit' + depositext
        os.rename(deposit, newdepositname)

# choose a destination for the files extracted from the zip file
TMP_DIR = DIR+'/'+epubname+'-original-epub-files'
OEBPS_DIR = TMP_DIR+'/OEBPS'


def extract(zip_filename, dm_extraction_dir):
    """
    Extract content from zip file
    """
    zip_test = ZipFile(zip_filename)
    zip_test.extractall(dm_extraction_dir)


extract(newepubname, TMP_DIR)

# copy files selectively from OEBPS to the transformation input directory
if not os.path.exists(INPUT_DIR):
    shutil.copytree(OEBPS_DIR, INPUT_DIR, symlinks=False,
                    ignore=IGNORE_SECONDARY)
else:
    shutil.rmtree(INPUT_DIR)
    shutil.copytree(OEBPS_DIR, INPUT_DIR, symlinks=False,
                    ignore=IGNORE_SECONDARY)

# copy images from input directory to XML directory
if not os.path.exists(XML_DIR):
    shutil.copytree(IMG_DIR, XML_DIR, symlinks=False,
                    ignore=IGNORE_XHTML)
else:
    shutil.rmtree(XML_DIR)
    shutil.copytree(IMG_DIR, XML_DIR, symlinks=False,
                    ignore=IGNORE_XHTML)

# copy audio from input to XML directory
if os.path.exists(AUDIO_DIR):
    if not os.path.exists(XML_AUDIO_DIR):
        shutil.copytree(AUDIO_DIR, XML_AUDIO_DIR, symlinks=False,
                        ignore=IGNORE_XHTML)
    else:
        shutil.rmtree(XML_AUDIO_DIR)
        shutil.copytree(AUDIO_DIR, XML_AUDIO_DIR, symlinks=False,
                        ignore=IGNORE_XHTML)


# copy videos from input to XML directory
if os.path.exists(VIDEO_DIR):
    if not os.path.exists(XML_VIDEO_DIR):
        shutil.copytree(VIDEO_DIR, XML_VIDEO_DIR, symlinks=False,
                        ignore=IGNORE_XHTML)
    else:
        shutil.rmtree(XML_VIDEO_DIR)
        shutil.copytree(VIDEO_DIR, XML_VIDEO_DIR, symlinks=False,
                        ignore=IGNORE_XHTML)
