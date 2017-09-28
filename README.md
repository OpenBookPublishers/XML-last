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

The standard production workflow at Open Book Publishers is summarised in the graph below.
![OBP workflow](https://www.openbookpublishers.com/resources/OBP-workflow.jpg)

## Preparing the InDesign documents
The instructions below must be followed closely for the conversion tool to function as expected.
The publication must be organised into a collection of InDesign documents (file extension: .indd) listed in a specific order within a book (file extension: .indb). Each document should correspond to a block of content that is considered as a separate unit. From a technical standpoint, a document will correspond to a one input XHTML file in the epub and to one output XML file. Documents must be named according to the following list of accepted filenames. Their order within the book can differ from the one outlined below. Square brackets indicate that document may not occur within a book:

FILENAME | TYPE OF SECTION
-------- | --------------
half-title | Half title page
title | Title page
copyright | Copyright page
[dedication] | [Dedication page]
contents | Table of contents
[illustrations] | [List of illustrations]
[tables] | [List of tables]
[resources] | [List of resources]
[acknowledgments] | [Acknowledgments]
[contributors] | [Contributors’ short biographies]
[foreword] | [Foreword]
[preface] | [Preface]
[introduction] | [Introduction]
ch1 | Chapter 1
[ch2] | [Chapter 2]
[ch3] | [Chapter 3]
[chN] | [Chapter N]
[bibliography] | [Bibliography]
[index] | [Index]
back-page | Back page

ID-document-TEMPLATE.indt contains all the styles needed to format the majority of monographs in the humanities. Style names have been chosen to be self-explanatory and easy to use. While style specifications can and should be changed to match the house style, their names need to remain the same.

### Character Styles
CHARACTER STYLE | TEXT FEATURE
--------------- | ------------
italic | Italicised text
bold | Bolded text (keep to a minimum)
bolditalic | Bolded, italicised text
superscript | Superscript text (including footnote markers)
superscript-italic | Superscript, italicised text
subscript | Subscript text
smaller | Smaller text (for any reasons)
times-new-roman | Times New Roman font face (used for glyphs that do not exist in Palatino)
times-new-roman-italic | as above, italicised
underline | Underlined text
strikethrough | Strikethrough text
strikethrough-italic | Strikethrough, italicised text
line-number | Line numbers in poems 

### Paragraph Styles

PARAGRAPH STYLE | TYPE OF TEXT BLOCK
--------------- | ------------------
running-title | Running headers in master pages
FM-half-title | Half-title
FM-title | Title page: book main title
FM-subtitle | Title page: book subtitle
FM-author | Title page: contributors’ names
FM-affiliation | Title page: contributors’ affiliation
CP-centered-para | Copyright page: centered text
CP-first-para | Copyright page: justified text, with space above
CP-other-para | Copyright page: justified text
TOC-chapter-title | Table of contents: chapter headings
TOC-part-title | Table of contents: part  headings
TOC-author | Table of contents: authors’ names
illustration-list | Any item in an illustration, table or resource list
dedication | Any dedicatory line or paragraph
signature | Author’s signature eg at the end of a preface
heading0 | Part heading
heading1 | Chapter heading
heading1-aut | Chapter heading (when author name follows)
author-name | Author name following chapter heading
heading2 | Section heading (level 1)
heading3 | Section heading (level 2)
heading4 | Section heading (level 3)
heading5 | Section heading (level 4)
first-para | Paragraph in main text, if occurring at the start of a chapter or after an image, table, poem, etc.
other-para | Any other paragraph in main text
footnote-first-para | First paragraph in footnote
footnote-other-para | Any other paragraph in footnote
endnote-first-para | First paragraph in endnote
endnote-other-para | Any other paragraph in endnote
quote-first-para | First paragraph in quote
quote-other-para | Any other paragraph in quote
quote-in-footnote-first-para | First paragraph of a quote in footnote
quote-in-footnote-other-para | Any other paragraph of a quote in footnote
short-ref | Short in-text reference following quoted text
numbered-list-lev1 | Each item in an ordered list
numbered-list-lev2 | Each item in an ordered list within another list’s item
bullet-list-lev1 | Each item in an unordered list
caption-centered | Short image captions (below image)
caption-justified | Longer image captions (below image)
image-centered | Paragraph return carrying an anchored object
table-centered | Paragraph return carrying a table
table-caption | Table captions (above table)
table-text-centered | Table text, aligned in the centre of the cell
table-text-left | Table text, aligned to the left of the cell
poem-first-para | First line in each stanza of a poem
poem-other-para | Any other line in a poem
poem-first-para-indented | Same as above, use only when a poem has two different indentation levels
poem-other-para-indented	
poem-in-footnote | Any line of poetry in footnote
stage-directions | Stage directions in a play
play-first-para | First paragraph in a play (prose)
play-other-para | Any other paragraph in a play (prose)
doi	Chapter-lev | DOI as printed on a section’s first page
bibliography-first-para | First entry in bibliography
bibliography-other-para | Any other entry in bibliography
index-lev1-spaced | First index entry for any given letter A-Z
index-lev1 | Any other main entry in index
index-lev2 | Sub-entry in index (level 1)
index-lev3 | Sub-entry in index (level 2)
index-lev4 | Sub-entry in index (level 3)
highlighted-first-para | The first and following paragraphs in a block that stands out from the surrounding text but is not described by any of the styles above 
highlighted-other-para	
break | Any sequence of characters (eg ****, or ~~~) that breaks the text flow without starting a new section
back-page-title | Back page: main heading
back-page-text | Back page: justified text
back-page-text-centered | Back page: centered text

The conversion to XML works by inferring the nature of a text block from the style that has been used to format it. The paragraph style called “signature”, for example, may be virtually identical to “short-ref” in terms of formatting. The use of two separate styles allows the recording of their rather different function within the text so that this difference can be recovered at the time of conversion.