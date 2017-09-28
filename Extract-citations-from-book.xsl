<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.crossref.org/doi_resources_schema/4.3.6"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:doi="http://www.crossref.org/schema/4.3.5">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="OBP-base-doi"
        select="doc('doi-deposit.xml')/descendant::doi:book_metadata/descendant::doi:doi_data/doi:doi"/>
    <xsl:variable name="doi-batch-id" select="doc('doi-deposit.xml')/descendant::doi:doi_batch_id"/>

    <xsl:template match="/">
        <xsl:result-document href="DOI-citations/{$doi-batch-id}-citations.xml" method="xml">
            <doi_batch version="4.3.6" xmlns="http://www.crossref.org/doi_resources_schema/4.3.6"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.crossref.org/doi_resources_schema/4.3.6 http://www.crossref.org/schema/deposit/doi_resources4.3.6.xsd">
                <head>
                    <doi_batch_id>
                        <xsl:value-of select="$doi-batch-id"/>
                        <xsl:text>-citations</xsl:text>
                    </doi_batch_id>
                    <depositor>
                        <depositor_name>Open Book Publishers</depositor_name>
                        <email_address>distribution@openbookpublishers.com</email_address>
                    </depositor>
                </head>
                <body>
                    <doi_citations>
                        <!-- DOI of the book that contains the citations (extracted from the metadata deposit) -->
                        <doi>
                            <xsl:value-of select="$OBP-base-doi"/>
                        </doi>
                        <citation_list>
                            <xsl:for-each select="//tei:bibl">
                                <xsl:if test="not(parent::tei:figure)">
                                <!-- Numbering citations from 1 to n -->
                                   <xsl:variable name="number">
                                       <xsl:number level="any"/>
                                   </xsl:variable>
                                   <citation key="ref{$number}">
                                       <xsl:choose>
                                           <!-- When the DOI of the work being cited is known, that is enough info  -->
                                           <xsl:when test="./tei:ref/text()[contains(., 'doi')]">
                                               <xsl:if test="./tei:ref[1]/text()[contains(., 'doi')]">
                                                   <xsl:variable name="doi-suffix" select="substring-after(./tei:ref[1]/text(), 'org/')"/>
                                                   <doi>
                                                       <xsl:value-of select="$doi-suffix"/>
                                                   </doi>
                                               </xsl:if>
                                               <xsl:if test="./tei:ref[2]/text()[contains(., 'doi')]">
                                                   <xsl:variable name="doi-suffix" select="substring-after(./tei:ref[2]/text(), 'org/')"/>
                                                   <doi>
                                                       <xsl:value-of select="$doi-suffix"/>
                                                   </doi>
                                               </xsl:if>
                                           </xsl:when>
                                           <!-- When the DOI of the work being cited is NOT known, we deposit an unstructured citation -->
                                           <xsl:otherwise>
                                               <unstructured_citation>
                                                   <xsl:apply-templates/>
                                                   <xsl:call-template name="other-ref"/>
                                               </unstructured_citation>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                   </citation>
                                </xsl:if>
                            </xsl:for-each>
                        </citation_list>
                    </doi_citations>
                </body>
            </doi_batch>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Ignore any URL that is not a DOI (as recommended by CrossRef team) -->
    <xsl:template name="other-ref" match="//tei:bibl/tei:ref"/>
    
    <!-- Do not include italics (as recommended by CrossRef team) 
        <xsl:template match="//tei:bibl/tei:hi[contains(@rendition, 'italic')]">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>-->
    
</xsl:stylesheet>
