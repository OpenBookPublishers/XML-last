<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:doi="http://www.crossref.org/schema/4.3.5"
    xmlns:ai="http://www.crossref.org/AccessIndicators.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <!-- Create a XML output file for each XHTML input file and set its overall structure -->
    <xsl:template match="/">
        <xsl:result-document href="XML-edition/entire-book.xml" method="xml">
            <teiCorpus>
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <title type="main">
                                <xsl:value-of
                                    select="doc('doi-deposit.xml')/descendant::doi:book_metadata/descendant::doi:title"
                                />
                            </title>
                            <xsl:for-each
                                select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:contributors/doi:person_name">
                                <xsl:choose>
                                    <xsl:when test="contains(@contributor_role, 'author')">
                                        <author>
                                            <xsl:apply-templates select="./doi:given_name"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:apply-templates select="./doi:surname"/>
                                        </author>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <editor>
                                            <xsl:apply-templates select="./doi:given_name"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:apply-templates select="./doi:surname"/>
                                        </editor>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </titleStmt>
                        <!--<editionStmt>
                        <edition n="1">
                        </edition>
                    </editionStmt>-->
                        <publicationStmt>
                            <publisher><xsl:apply-templates select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:publisher/doi:publisher_name"/></publisher>
                            <date>
                                <xsl:value-of
                                    select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:publication_date/doi:year"/>
                                <xsl:text>-</xsl:text>
                                <xsl:value-of
                                    select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:publication_date/doi:month"
                                />
                            </date>
                            <availability>
                                <licence>
                                    <xsl:value-of
                                        select="doc('doi-deposit.xml')/descendant::doi:book_metadata/ai:program/ai:license_ref"
                                    />
                                </licence>
                                <p>This licence applies to the content that follows, unless otherwise stated. Images, quotations and embedded objects are not covered by this licence. <!--Their copyright status is specified below.--></p>
                            </availability>
                            <idno type="DOI">
                                <xsl:value-of
                                    select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:doi_data/doi:doi"
                                />
                            </idno>
                            <xsl:for-each
                                select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:isbn">
                                <idno type="ISBN">
                                    <xsl:apply-templates select="."/>
                                </idno>
                            </xsl:for-each>
                            <idno type="URI">
                                <xsl:value-of
                                    select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:doi_data/doi:resource"
                                />
                            </idno>
                        </publicationStmt>
                        <!--<seriesStmt>
                        <title> Title of the Series </title>
                        <biblScope unit="volume"> Volume n. </biblScope>
                        <idno type="ISSNPrint"> ISSN Print </idno>
                        <idno type="ISSNOnline"> ISSN Digital </idno>
                    </seriesStmt>-->
                        <sourceDesc>
                            <p>This is original content, published in Open Access.</p>
                        </sourceDesc>
                    </fileDesc>
                </teiHeader>
                <xi:include href="XML-edition/title.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/copyright.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/dedication.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/contents.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/acknowledgements.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/acknowledgments.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/contributors.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/illustrations.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/tables.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/music.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/foreword.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/preface.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/introduction.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch1.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch2.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch3.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch4.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch5.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch6.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch7.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch8.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch9.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch10.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch11.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch12.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch13.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch14.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch15.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch16.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch17.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch18.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch19.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch20.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch21.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch22.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch23.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch24.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/ch25.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/bibliography.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/index.xml">
                    <xi:fallback/>
                </xi:include>
                <xi:include href="XML-edition/chronology.xml">
                    <xi:fallback/>
                </xi:include>
            </teiCorpus>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
