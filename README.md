# XML-last

This repository contains a conversion tool from epub, generated using Adobe InDesign, to XML. For the conversion to work the InDesign documents need be formatted  following the set of instructions given below. The tool also relies on the use of consistent file and style naming conventions (controlled lists are also given below).

To run the conversion a transformation engine such as SaxonHE (https://sourceforge.net/projects/saxon/files/Saxon-HE/9.8/) will be needed although this open source edition does not allow the validation of the result documents.

## Contents
* Files and directories
* Workflow overview
* Preparing the InDesign documents
* Book- and chapter-level metadata
* Object-level metadata
* Running the conversion
* The simplePrint schema and TEIPublisher

## Files and directories
* __documents and templates__: this folder contains a template file for use in InDesign. It also includes sample input files for book-, chapter- and object-level metadata
* __schemas__: this folder contains the tei_simplePrint schema (also available at http://www.tei-c.org/Guidelines/Customization/index.xml) and the OBP customisation
* __Extract-citations-from-book.xsl__: this script extracts citations from a book already converted to XML and creates a file for submission to CrossRef's cited-by service (https://support.crossref.org/hc/en-us/articles/213534146-Cited-by-overview)
* __LICENSE__
* __README.md__: this file
* __Transform-to-XML-book.xsl__: this script creates a unique book-long XML file by combining the already converted XML documents though Xinclude
* __Transform-to-XML-section.xsl__: this is the main conversion tool as it transforms in turn each XHTML file contained in the input folder into a XML file
* __XML-after-transformation.py__: this python script should be run after conversion to fix some common mistakes in the XML
* __XML-before-transformation.py__: this python script helps set up the conversion by extracting the input files from the epub and creating the output folder among other things

## Workflow overview
![OBP workflow](https://www.openbookpublishers.com/resources/OBP-workflow.jpg)

## Preparing the InDesign documents
