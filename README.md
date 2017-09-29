# XML-last

This repository contains a set of tools to convert an epub created with Adobe InDesign into a series of XML files that follow the TEI simplePrint customisation. For the conversion to work the InDesign documents need be formatted following a specific set of instructions (see the repo's [wiki](https://github.com/OpenBookPublishers/XML-last/wiki)).

## Files and directories in this repository
* __documents and templates__: this folder contains a template file for use in InDesign. It also includes sample input files for book-, chapter- and object-level metadata
* __schemas__: this folder contains the tei_simplePrint schema (also available at http://www.tei-c.org/Guidelines/Customization/index.xml) and the OBP customisation
* __Extract-citations-from-book.xsl__: this script extracts citations from a book already converted to XML and creates a file for submission to CrossRef's cited-by service (https://support.crossref.org/hc/en-us/articles/213534146-Cited-by-overview)
* __LICENSE__
* __README.md__: this file
* __Transform-to-XML-book.xsl__: this script creates a unique book-long XML file by combining the already converted XML documents though Xinclude
* __Transform-to-XML-section.xsl__: this is the main conversion tool as it transforms in turn each XHTML file forming the input epub into a XML file
* __XML-after-transformation.py__: this python script can be run after conversion to fix some common mistakes in the XML
* __XML-before-transformation.py__: this python script must be run before conversion; it extracts the XHTML files from the input epub and creates the output folder among other things

## Running the conversion
1. copy your input files to the project folder:
	* the epub of the book you want to convert 
	* the file containing book- and optionally chapter-level metadata for DOI deposit to CrossRef (see 'book-chapter-metadata-TEMPLATE.xml' in the 'documents and templates' folder)
	* (optional) the file containing object-level metadata (see 'Object-metadata-TEMPLATE.csv' in the 'documents and templates' folder) 
2. Run 'XML-before-transformation.py' (you will need Python 3.6.2 or newer). This will:
	* un-package the epub
	* copy the content of the 'OEBPS' folder to a newly created 'input' folder
	* re-name the DOI deposit to a standard filename
	* copy images, audio or video files contained in the epub to the output folder, 'XML-edition'
3. Run 'Transform-to-XML-section.xsl' (XSLT 2.0) to transform each input XHTML file into a XML file. The output files will be saved to the 'XML-edition' folder. To run this conversion a processor such as SaxonHE will be needed (https://sourceforge.net/projects/saxon/files/Saxon-HE/9.8/ -- note that the open source edition of Saxon does not allow the validation of the result documents). Saxon can be run (1) from within a product that provides a graphical user interface (such as oXygen, https://www.oxygenxml.com/), (2) from the command line or (3) from within a Java or .NET application.
	* (1) select 'Transform-to-XML-section.xsl' as both the input and the XSL source of the transformation; the output field can be left blank
	* (2) type java `-jar _dir_/saxon9he.jar -s:_dir_/XML-last/Transform-to-XML-section.xsl -xsl:_dir_/XML-last/Transform-to-XML-section.xsl -o:_dir_/XML-last/Transform-to-XML-section.xsl`
	* (3) see eg http://www.oracle.com/technetwork/java/gazfm-138953.html
4. Run 'Transform-to-XML-book.xsl'. This second transformation uses Xinclude to merge the newly created XML files into one single file. The output is saved to the 'XML-edition' folder as 'entire-book.xml'. (See above for more on how to run the transformation).
5. Run 'XML-after-transformation.py' to:
	* change the destination of internal links throughout the 'entire-book.xml' file (now internal links)
	* modify relative URLs throughout
	* delete empty list items
	* delete empty `<div>`s
	* delete tabs
6. If you wish to extract citation data from the book and create a file for submission to CrossRef's cited-by service you can run 'Extract-citations-from-book.xsl'. The program will:
	* individuate every element that has been tagged as a bibliographic entry within 'entire-book.xml' 
	* extract and number them sequentially
	* convert them to a `<citation>` or `<unstructured_citation>` element

## Further reading
Visit the repo's [wiki](https://github.com/OpenBookPublishers/XML-last/wiki) to read about:
* [Preparing the epub for conversion](https://github.com/OpenBookPublishers/XML-last/wiki/Preparing-the-epub-for-conversion)
* Book- and chapter-level metadata
* Object-level metadata
* The simplePrint schema and TEIPublisher
* Extracting citation data for submission to CrossRef's cited-by service
