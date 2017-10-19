# XML-last

This repository contains a set of tools to convert an epub created with Adobe InDesign into a series of XML files that follow the TEI simplePrint customisation. For the conversion to work the InDesign documents need be formatted following a specific set of instructions (see the repo's [wiki](https://github.com/OpenBookPublishers/XML-last/wiki)).

## Files and directories in this repository
* __documents and templates__: this folder contains an InDesign template. It also includes sample input files for book-, chapter- and object-level metadata
* __schemas__: this folder contains the tei_simplePrint schema (also available at http://www.tei-c.org/Guidelines/Customization/index.xml) and the OBP customisation
* __LICENSE__
* __README.md__: this file
* __Transform-to-XML-book.xsl__: this script creates a unique book-long XML TEI file by combining the documents already converted
* __Transform-to-XML-section.xsl__: this is the main conversion tool that transforms each XHTML file forming the input epub into a XML TEI file
* __XML-after-transformation.py__: this python script should be run after conversion to fix some small mistakes in the XML
* __XML-before-transformation.py__: this python script must be run before conversion to correctly set-up the input and output folders

## Running the conversion
1. copy your input files to the project folder:
	* the epub of the book you want to convert (see [Preparing the epub for conversion](https://github.com/OpenBookPublishers/XML-last/wiki/Preparing-the-epub-for-conversion))
	* the file containing book- and optionally chapter-level metadata (see [documents and templates/book-chapter-metadata-TEMPLATE.xml](https://github.com/OpenBookPublishers/XML-last/blob/master/documents%20and%20templates/book-chapter-metadata-TEMPLATE.xml) and [Book and chapter metadata](https://github.com/OpenBookPublishers/XML-last/wiki/Book-and-chapter-metadata))
	* (optional) the file containing object-level metadata (see [documents and templates/Object-metadata-TEMPLATE.csv](https://github.com/OpenBookPublishers/XML-last/blob/master/documents%20and%20templates/Object-metadata-TEMPLATE.csv) and [Object metadata](https://github.com/OpenBookPublishers/XML-last/wiki/Object-metadata)) 
2. Run 'XML-before-transformation.py' (you will need Python 3.6.2 or newer). This will:
	* un-package the epub
	* selectively copy the content of the epub to a newly created 'input' folder
	* re-name the book metadata file
	* create the output folder 'XML-edition'
	* transfer images, audio and video files (if any) from the epub to the 'XML-edition' folder
3. Run 'Transform-to-XML-section.xsl'  to transform each input XHTML file into a XML TEI file. The output files will be saved to the 'XML-edition' folder. To run this transformation (XSLT 2.0) a processor such as SaxonHE will be needed (https://sourceforge.net/projects/saxon/files/Saxon-HE/9.8/ -- note that the open source edition of Saxon does not allow the validation of the result documents). Saxon can be run (1) from within a product that provides a graphical user interface (such as oXygen, https://www.oxygenxml.com/), (2) from the command line or (3) from within a Java or .NET application.
	* (1) select 'Transform-to-XML-section.xsl' as both the input and the XSL source of the transformation; the output field can be left blank
	* (2) type java `-jar _dir_/saxon9he.jar -s:_dir_/XML-last/Transform-to-XML-section.xsl -xsl:_dir_/XML-last/Transform-to-XML-section.xsl -o:_dir_/XML-last/Transform-to-XML-section.xsl`
	* (3) see eg http://www.oracle.com/technetwork/java/gazfm-138953.html
4. Run 'Transform-to-XML-book.xsl'. This second transformation uses Xinclude to merge the newly created XML TEI files into one single file. The output is saved to the 'XML-edition' folder as 'entire-book.xml'. (See above for more on how to run the transformation).
5. Run 'XML-after-transformation.py' to:
	* change cross-references destination throughout 'entire-book.xml'
	* modify relative URLs throughout
	* delete empty list items
	* delete empty `<div>`s
	* delete tabs

## Further reading
Visit the repo's [wiki](https://github.com/OpenBookPublishers/XML-last/wiki) to read about:
* [Preparing the epub for conversion](https://github.com/OpenBookPublishers/XML-last/wiki/Preparing-the-epub-for-conversion)
* [A quick description of content conversion](https://github.com/OpenBookPublishers/XML-last/wiki/A-quick-description-of-content-conversion)
* [Book and chapter metadata](https://github.com/OpenBookPublishers/XML-last/wiki/Book-and-chapter-metadata)
* [Object metadata](https://github.com/OpenBookPublishers/XML-last/wiki/Object-metadata)
* [The TEI simplePrint schema](https://github.com/OpenBookPublishers/XML-last/wiki/TEI-simplePrint)

If you wish to extract bibliographic citations after conversion, visit https://github.com/OpenBookPublishers/Extract-citations