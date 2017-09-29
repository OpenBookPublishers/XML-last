# XML-last

This repository contains a set of tools to convert an epub created with Adobe InDesign into a series of XML files that follow the TEI simplePrint customisation. For the conversion to work the InDesign documents need be formatted following a specific set of instructions (see the project's wiki).

To run the conversion a transformation engine such as SaxonHE will be needed (https://sourceforge.net/projects/saxon/files/Saxon-HE/9.8/ -- note that the open source edition of Saxon does not allow the validation of the result documents).

## Files and directories
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

Go the project's wiki to read more about:
* OBP Publishing workflow overview
* Preparing the epub for conversion
* Book- and chapter-level metadata
* Object-level metadata
* The simplePrint schema and TEIPublisher
