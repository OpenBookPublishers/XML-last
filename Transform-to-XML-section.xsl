<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:doi="http://www.crossref.org/schema/4.3.5"
    xmlns:ai="http://www.crossref.org/AccessIndicators.xsd">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Create a XML output file for each XHTML input file and set its overall structure -->
   
    <xsl:template match="/">
        <xsl:for-each select="collection('input/?select=*.xhtml')">
            <xsl:variable name="outfile" select="descendant::html:title"/>
            <xsl:variable name="chapter-doi-number"
                select="substring(descendant::html:p[starts-with(@class, 'doi')]/html:a, 26)"/>
            <xsl:result-document href="XML-edition/{$outfile}.xml" method="xml">
                <TEI>
                    <teiHeader>
                        <fileDesc>
                            <xsl:choose>
                                <xsl:when test="descendant::html:p[starts-with(@class, 'doi')]">
                                    <titleStmt>
                                        <title>
                                            <xsl:apply-templates
                                                select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/doi:titles/doi:title"
                                            />
                                        </title>
                                        <xsl:for-each
                                            select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/doi:contributors/doi:person_name">
                                            <author>
                                                <xsl:apply-templates select="./doi:given_name"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:apply-templates select="./doi:surname"/>
                                            </author>
                                        </xsl:for-each>
                                        <respStmt>
                                            <resp>
                                                <xsl:text>This is a section of </xsl:text>
                                                <title>
                                                  <xsl:value-of
                                                  select="doc('doi-deposit.xml')/descendant::doi:book_metadata/descendant::doi:title"
                                                  />
                                                </title>
                                                <xsl:text> (DOI: </xsl:text>
                                                <idno type="DOI">
                                                  <xsl:value-of
                                                  select="doc('doi-deposit.xml')/descendant::doi:book_metadata/descendant::doi:doi_data/doi:doi"
                                                  />
                                                </idno>
                                                <xsl:text>) </xsl:text>
                                                <xsl:if
                                                  test="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:contributors/doi:person_name[contains(@contributor_role, 'editor')]">
                                                  <xsl:text>edited </xsl:text>
                                                </xsl:if>
                                                <xsl:text>by </xsl:text>
                                            </resp>
                                            <xsl:for-each
                                                select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:contributors/doi:person_name">
                                                <name>
                                                  <xsl:apply-templates select="./doi:given_name"/>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:apply-templates select="./doi:surname"/>
                                                </name>
                                            </xsl:for-each>
                                        </respStmt>
                                    </titleStmt>
                                    <extent>
                                        <xsl:text>Pages </xsl:text>
                                        <xsl:apply-templates
                                            select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/doi:pages/doi:first_page"/>
                                        <xsl:text>-</xsl:text>
                                        <xsl:apply-templates
                                            select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/doi:pages/doi:last_page"/>
                                        <xsl:text> of the printed edition.</xsl:text>
                                    </extent>
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
                                                <xsl:apply-templates
                                                  select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/ai:program/ai:license_ref"
                                                />
                                            </licence>
                                            <p>This licence applies to the content that follows,
                                                unless otherwise stated. The inclusion of quoted
                                                passages falls under fair dealing. Images and
                                                embedded objects may not be covered by this licence,
                                                in which case their copyright status is specified in
                                                text.</p>
                                        </availability>
                                        <idno type="DOI">
                                            <xsl:apply-templates
                                                select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/doi:doi_data/doi:doi"
                                            />
                                        </idno>
                                        <idno type="URI">
                                            <xsl:apply-templates
                                                select="doc('doi-deposit.xml')/descendant::doi:content_item/descendant::doi:*[contains(text(), $chapter-doi-number)]/ancestor::doi:content_item/doi:doi_data/doi:resource"
                                            />
                                        </idno>
                                    </publicationStmt>
                                </xsl:when>
                                <xsl:otherwise>
                                    <titleStmt>
                                        <xsl:choose>
                                            <xsl:when
                                                test="descendant::html:*[starts-with(@class, 'heading1')]">
                                                <title>
                                                  <xsl:value-of
                                                  select="descendant::html:*[starts-with(@class, 'heading1')]"
                                                  />
                                                </title>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <title>
                                                  <xsl:value-of select="$outfile"/>
                                                </title>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:for-each
                                            select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:contributors/doi:person_name">
                                            <author>
                                                <xsl:apply-templates select="./doi:given_name"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:apply-templates select="./doi:surname"/>
                                            </author>
                                        </xsl:for-each>
                                        <respStmt>
                                            <resp>
                                                <xsl:text>This is a section of </xsl:text>
                                                <title>
                                                  <xsl:value-of
                                                  select="doc('doi-deposit.xml')/descendant::doi:book_metadata/descendant::doi:title"
                                                  />
                                                </title>
                                                <xsl:text> (DOI: </xsl:text>
                                                <idno type="DOI">
                                                  <xsl:value-of
                                                  select="doc('doi-deposit.xml')/descendant::doi:book_metadata/descendant::doi:doi_data/doi:doi"
                                                  />
                                                </idno>
                                                <xsl:text>) </xsl:text>
                                                <xsl:if
                                                  test="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:contributors/doi:person_name[contains(@contributor_role, 'editor')]">
                                                  <xsl:text>edited </xsl:text>
                                                </xsl:if>
                                                <xsl:text>by </xsl:text>
                                            </resp>
                                            <xsl:for-each
                                                select="doc('doi-deposit.xml')/descendant::doi:book_metadata/doi:contributors/doi:person_name">
                                                <name>
                                                  <xsl:apply-templates select="./doi:given_name"/>
                                                  <xsl:text> </xsl:text>
                                                  <xsl:apply-templates select="./doi:surname"/>
                                                </name>
                                            </xsl:for-each>
                                        </respStmt>
                                    </titleStmt>
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
                                            <p>This licence applies to the content that follows,
                                                unless otherwise stated. The inclusion of quoted
                                                passages falls under fair dealing. Images and
                                                embedded objects may not be covered by this licence,
                                                in which case their copyright status is specified in
                                                text.</p>
                                        </availability>
                                    </publicationStmt>
                                </xsl:otherwise>
                            </xsl:choose>
                            <sourceDesc>
                                <p>This is original content, published in Open Access.</p>
                            </sourceDesc>
                        </fileDesc>
                        <xsl:if test="descendant::html:p[starts-with(@class, 'abstract')]">
                            <profileDesc>
                                <abstract>
                                    <p>
                                        <xsl:copy/>
                                        <xsl:apply-templates
                                            select="descendant::html:p[starts-with(@class, 'abstract')]"
                                        />
                                    </p>
                                </abstract>
                            </profileDesc>
                        </xsl:if>
                    </teiHeader>
                    <text xml:id="{$outfile}">
                        <body>
                            <xsl:apply-templates select="//html:body/html:div"/>
                        </body>
                    </text>
                </TEI>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <!-- Delete footnote section from the end of the input documents -->
    <xsl:template match="//html:div[@class = '_idFootnotes']"/>

    <!-- Set the hierarchy of <div>s inside each document using 'for-each-group' -->
    <xsl:template match="//html:body/html:div">
        <div>
            <xsl:for-each-group select="html:*"
                group-starting-with="html:*[starts-with(@class, 'heading1')]">
                <xsl:apply-templates select="." mode="group"/>
            </xsl:for-each-group>
        </div>
    </xsl:template>

    <xsl:template match="//html:*[starts-with(@class, 'heading1')]" mode="group">
        <head type="chapter">
            <!-- This treatment of heading0 implies that the element occurs before heading1, in the first chapter belonging to that part.
                If heading0 occurs in a separate file, a different treatment must be devised. -->
            <xsl:if test="preceding-sibling::html:*[starts-with(@class, 'heading0')]">
                <xsl:element name="label">
                    <xsl:attribute name="type" select="'beginning-of-section'"/>
                    <xsl:value-of
                        select="preceding-sibling::html:*[starts-with(@class, 'heading0')]"/>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates select="."/>
        </head>
        <xsl:for-each-group select="current-group() except ."
            group-starting-with="html:*[starts-with(@class, 'heading2')]">
            <xsl:apply-templates select="." mode="group"/>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="//html:*[starts-with(@class, 'heading2')]" mode="group">
        <div>
            <head type="section-lev1">
                <xsl:apply-templates select="."/>
            </head>
            <xsl:for-each-group select="current-group() except ."
                group-starting-with="html:*[starts-with(@class, 'heading3')]">
                <xsl:apply-templates select="." mode="group"/>
            </xsl:for-each-group>
        </div>
    </xsl:template>

    <xsl:template match="//html:*[starts-with(@class, 'heading3')]" mode="group">
        <div>
            <head type="section-lev2">
                <xsl:apply-templates select="."/>
            </head>
            <xsl:for-each-group select="current-group() except ."
                group-starting-with="html:*[starts-with(@class, 'heading4')]">
                <xsl:apply-templates select="." mode="group"/>
            </xsl:for-each-group>
        </div>
    </xsl:template>

    <xsl:template match="//html:*[starts-with(@class, 'heading4')]" mode="group">
        <div>
            <head type="section-lev3">
                <xsl:apply-templates select="."/>
            </head>
            <xsl:for-each-group select="current-group() except ."
                group-starting-with="html:*[starts-with(@class, 'heading5')]">
                <xsl:apply-templates select="." mode="group"/>
            </xsl:for-each-group>
        </div>
    </xsl:template>

    <xsl:template match="//html:*[starts-with(@class, 'heading5')]" mode="group">
        <div>
            <head type="section-lev4">
                <xsl:apply-templates select="."/>
            </head>
            <xsl:apply-templates select="current-group() except ."/>
        </div>
    </xsl:template>

    <xsl:template
        match="//html:*[not(starts-with(@class, 'heading1') or starts-with(@class, 'heading2') or starts-with(@class, 'heading3') or starts-with(@class, 'heading4') or starts-with(@class, 'heading5') or (starts-with(@class, '_idGenObject')))]"
        mode="group">
        <xsl:apply-templates select="current-group()"/>
    </xsl:template>

    <!-- Styling the text -->

    <xsl:template match="//html:p[starts-with(@class, 'heading0')]"/>

    <xsl:template match="//html:p[starts-with(@class, 'FM-title')]">
        <head type="main">
            <xsl:apply-templates/>
        </head>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'FM-subtitle')]">
        <head type="sub">
            <xsl:apply-templates/>
        </head>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'FM-author')]">
        <docAuthor>
            <xsl:apply-templates/>
        </docAuthor>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'FM-affiliation')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'CP')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'TOC')]">
        <xsl:choose>
            <xsl:when test="contains(@class, 'author')">
                <name>
                    <xsl:apply-templates/>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'illustration')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'author-name')]">
        <docAuthor>
            <xsl:apply-templates/>
        </docAuthor>
    </xsl:template>

    <xsl:template
        match="//html:p[starts-with(@class, 'first-para') or starts-with(@class, 'other-para') or starts-with(@class, 'normal-para')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'footnote')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'quote-first')]">
        <quote>
            <xsl:apply-templates/>
            <!--<bibl>
                <availability>
                    <licence>Quotations fall under fair dealing and are not licenced under the terms stated above.</licence>
                </availability>
            </bibl>-->
        </quote>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'quote-other')]">
        <quote type="cont">
            <xsl:apply-templates/>
            <!--<bibl>
                <availability>
                    <licence>Quotations fall under fair dealing and are not licenced under the terms stated above.</licence>
                </availability>
            </bibl>-->
        </quote>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'highlighted')]">
        <ab type="highlighted">
            <xsl:apply-templates/>
        </ab>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'abstract')]">
        <desc>
            <xsl:apply-templates/>
        </desc>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'short-ref')]">
        <label type="short-reference">
            <xsl:apply-templates/>
        </label>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'translation')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'table-caption')]">
        <p corresp="#{generate-id(following-sibling::html:table[1])}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="html:ol">
        <list type="ordered">
            <xsl:apply-templates/>
        </list>
    </xsl:template>

    <xsl:template match="html:ul">
        <list>
            <xsl:apply-templates/>
        </list>
    </xsl:template>

    <xsl:template match="html:li">
        <item>
            <xsl:apply-templates/>
        </item>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'caption')]">
        <p
            corresp="#{generate-id(preceding-sibling::html:div[descendant::html:img][1]/descendant::html:img)}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'numbered')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'bullet')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'table-text')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'poem')]">
        <l>
            <xsl:apply-templates/>
        </l>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'dedication')]">
        <salute>
            <xsl:apply-templates/>
        </salute>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'signature')]">
        <signed>
            <xsl:apply-templates/>
        </signed>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'doi')]">
        <byline>
            <xsl:apply-templates/>
        </byline>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'endnote')]">
        <note>
            <xsl:apply-templates/>
        </note>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'stage')]">
        <stage>
            <xsl:apply-templates/>
        </stage>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'play')]">
        <sp>
            <p>
                <xsl:apply-templates/>
            </p>
        </sp>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'bibliography')]">
        <bibl>
            <xsl:apply-templates/>
        </bibl>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'index')]">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="//html:p[starts-with(@class, 'break')]">
        <milestone unit="section"/>
    </xsl:template>

    <!-- IMAGES, AUDIO and VIDEO -->
    <xsl:template match="//html:img">
        <xsl:variable name="imagepath">
            <xsl:value-of select="@src"/>
        </xsl:variable>
        <xsl:variable name="imagefilename">
            <xsl:value-of select="substring($imagepath, 8)"/>
        </xsl:variable>
        <figure xml:id="{generate-id()}">
            <graphic url="{@src}"/>
            <!-- Insert a caption if present -->
            <xsl:if
                test="ancestor::html:div/following-sibling::html:*[1][starts-with(@class, 'caption')]">
                <figDesc>
                    <xsl:value-of
                        select="ancestor::html:div/following-sibling::html:p[1]/node()[not(descendant::html:a)]"
                    />
                </figDesc>
            </xsl:if>
            <!-- Extract metadata from csv if not OBP logo, CC logo or QR code -->
            <xsl:if
                test="not(contains(@src, 'logo') or contains(@src, 'QR') or contains(@src, 'CC-'))">
                <xsl:if test="unparsed-text-available('Object-metadata.csv', 'iso-8859-1')">
                    <xsl:variable name="in"
                        select="unparsed-text('Object-metadata.csv', 'iso-8859-1')"/>
                    <xsl:analyze-string select="$in" regex="\n">
                        <xsl:non-matching-substring>
                            <xsl:if test="contains(., $imagefilename)">
                                <bibl>
                                    <xsl:analyze-string select="."
                                        regex='"(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)"'>
                                        <xsl:matching-substring>
                                            <title>
                                                <xsl:value-of select="regex-group(2)"/>
                                            </title>
                                            <author>
                                                <xsl:value-of select="regex-group(3)"/>
                                            </author>
                                            <date>
                                                <xsl:value-of select="regex-group(4)"/>
                                            </date>
                                            <respStmt>
                                                <name>
                                                  <xsl:value-of select="regex-group(5)"/>
                                                </name>
                                                <resp>
                                                  <xsl:value-of select="regex-group(6)"/>
                                                </resp>
                                            </respStmt>
                                            <availability>
                                                <licence>
                                                  <xsl:value-of select="regex-group(7)"/>
                                                </licence>
                                                <p>Every effort has been made to identify and
                                                  contact copyright holders and any omission or
                                                  error will be corrected if notification is made to
                                                  the publisher. If you think we got this wrong, or
                                                  you wish to know more, please visit <ref
                                                  target="https://www.openbookpublishers.com/section/85/1/image-copyright"
                                                  >https://www.openbookpublishers.com/section/85/1/image-copyright</ref></p>
                                            </availability>
                                            <xsl:if test="regex-group(8) != 'None'">
                                                <xsl:choose>
                                                  <xsl:when test="contains(regex-group(8), 'doi')">
                                                  <idno type="DOI">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </idno>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <ref target="{regex-group(8)}">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </ref>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </bibl>
                            </xsl:if>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
            </xsl:if>
            <!-- Include audio file if present -->
            <xsl:if test="contains(@src, 'Sound')">
                <xsl:if
                    test="ancestor::html:div/preceding-sibling::html:*[1]/descendant::html:audio">
                    <xsl:variable name="audiopath">
                        <xsl:value-of
                            select="ancestor::html:div/preceding-sibling::html:*[1]/descendant::html:audio/html:source/@src"
                        />
                    </xsl:variable>
                    <xsl:variable name="audiofilename">
                        <xsl:value-of select="substring($audiopath, 7)"/>
                    </xsl:variable>
                    <xsl:element name="media">
                        <xsl:attribute name="mimeType">
                            <xsl:value-of
                                select="ancestor::html:div/preceding-sibling::html:*[1]/descendant::html:audio/html:source/@type"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="url">
                            <xsl:value-of select="$audiopath"/>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:if test="unparsed-text-available('Object-metadata.csv', 'iso-8859-1')">
                        <xsl:variable name="in"
                            select="unparsed-text('Object-metadata.csv', 'iso-8859-1')"/>
                        <xsl:analyze-string select="$in" regex="\n">
                            <xsl:non-matching-substring>
                                <xsl:if test="contains(., $audiofilename)">
                                    <bibl>
                                        <xsl:analyze-string select="."
                                            regex='"(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)"'>
                                            <xsl:matching-substring>
                                                <title>
                                                  <xsl:value-of select="regex-group(2)"/>
                                                </title>
                                                <author>
                                                  <xsl:value-of select="regex-group(3)"/>
                                                </author>
                                                <date>
                                                  <xsl:value-of select="regex-group(4)"/>
                                                </date>
                                                <respStmt>
                                                  <name>
                                                  <xsl:value-of select="regex-group(5)"/>
                                                  </name>
                                                  <resp>
                                                  <xsl:value-of select="regex-group(6)"/>
                                                  </resp>
                                                </respStmt>
                                                <availability>
                                                  <licence>
                                                  <xsl:value-of select="regex-group(7)"/>
                                                  </licence>
                                                  <p>Every effort has been made to identify and
                                                  contact copyright holders and any omission or
                                                  error will be corrected if notification is made to
                                                  the publisher. If you think we got this wrong, or
                                                  you wish to know more, please visit <ref
                                                  target="https://www.openbookpublishers.com/section/85/1/image-copyright"
                                                  >https://www.openbookpublishers.com/section/85/1/image-copyright</ref></p>
                                                </availability>
                                                <xsl:if test="regex-group(8) != 'None'">
                                                  <xsl:choose>
                                                  <xsl:when test="contains(regex-group(8), 'doi')">
                                                  <idno type="DOI">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </idno>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <ref target="{regex-group(8)}">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </ref>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:if>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </bibl>
                                </xsl:if>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:if>
                </xsl:if>
                <xsl:if
                    test="ancestor::html:div/following-sibling::html:*[1]/descendant::html:audio">
                    <xsl:variable name="audiopath">
                        <xsl:value-of
                            select="ancestor::html:div/following-sibling::html:*[1]/descendant::html:audio/html:source/@src"
                        />
                    </xsl:variable>
                    <xsl:variable name="audiofilename">
                        <xsl:value-of select="substring($audiopath, 7)"/>
                    </xsl:variable>
                    <xsl:element name="media">
                        <xsl:attribute name="mimeType">
                            <xsl:value-of
                                select="ancestor::html:div/following-sibling::html:*[1]/descendant::html:audio/html:source/@type"
                            />
                        </xsl:attribute>
                        <xsl:attribute name="url">
                            <xsl:value-of select="$audiopath"/>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:if test="unparsed-text-available('Object-metadata.csv', 'iso-8859-1')">
                        <xsl:variable name="in"
                            select="unparsed-text('Object-metadata.csv', 'iso-8859-1')"/>
                        <xsl:analyze-string select="$in" regex="\n">
                            <xsl:non-matching-substring>
                                <xsl:if test="contains(., $audiofilename)">
                                    <bibl>
                                        <xsl:analyze-string select="."
                                            regex='"(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)"'>
                                            <xsl:matching-substring>
                                                <title>
                                                  <xsl:value-of select="regex-group(2)"/>
                                                </title>
                                                <author>
                                                  <xsl:value-of select="regex-group(3)"/>
                                                </author>
                                                <date>
                                                  <xsl:value-of select="regex-group(4)"/>
                                                </date>
                                                <respStmt>
                                                  <name>
                                                  <xsl:value-of select="regex-group(5)"/>
                                                  </name>
                                                  <resp>
                                                  <xsl:value-of select="regex-group(6)"/>
                                                  </resp>
                                                </respStmt>
                                                <availability>
                                                  <licence>
                                                  <xsl:value-of select="regex-group(7)"/>
                                                  </licence>
                                                  <p>Every effort has been made to identify and
                                                  contact copyright holders and any omission or
                                                  error will be corrected if notification is made to
                                                  the publisher. If you think we got this wrong, or
                                                  you wish to know more, please visit <ref
                                                  target="https://www.openbookpublishers.com/section/85/1/image-copyright"
                                                  >https://www.openbookpublishers.com/section/85/1/image-copyright</ref></p>
                                                </availability>
                                                <xsl:if test="regex-group(8) != 'None'">
                                                  <xsl:choose>
                                                  <xsl:when test="contains(regex-group(8), 'doi')">
                                                  <idno type="DOI">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </idno>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <ref target="{regex-group(8)}">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </ref>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:if>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </bibl>
                                </xsl:if>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <!-- Include video file if present -->
            <xsl:if test="ancestor::html:div/following-sibling::html:*[1]/descendant::html:video">
                <xsl:variable name="videopath">
                    <xsl:value-of
                        select="ancestor::html:div/following-sibling::html:*[1]/descendant::html:video/html:source/@src"
                    />
                </xsl:variable>
                <xsl:variable name="videofilename">
                    <xsl:value-of select="substring($videopath, 7)"/>
                </xsl:variable>
                <xsl:element name="media">
                    <xsl:attribute name="mimeType">
                        <xsl:value-of
                            select="ancestor::html:div/following-sibling::html:*[1]/descendant::html:video/html:source/@type"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="url">
                        <xsl:value-of
                            select="$videopath"
                        />
                    </xsl:attribute>
                </xsl:element>
                <xsl:if test="unparsed-text-available('Object-metadata.csv', 'iso-8859-1')">
                    <xsl:variable name="in"
                        select="unparsed-text('Object-metadata.csv', 'iso-8859-1')"/>
                    <xsl:analyze-string select="$in" regex="\n">
                        <xsl:non-matching-substring>
                            <xsl:if test="contains(., $videofilename)">
                                <bibl>
                                    <xsl:analyze-string select="."
                                        regex='"(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)","(.+?)"'>
                                        <xsl:matching-substring>
                                            <title>
                                                <xsl:value-of select="regex-group(2)"/>
                                            </title>
                                            <author>
                                                <xsl:value-of select="regex-group(3)"/>
                                            </author>
                                            <date>
                                                <xsl:value-of select="regex-group(4)"/>
                                            </date>
                                            <respStmt>
                                                <name>
                                                  <xsl:value-of select="regex-group(5)"/>
                                                </name>
                                                <resp>
                                                  <xsl:value-of select="regex-group(6)"/>
                                                </resp>
                                            </respStmt>
                                            <availability>
                                                <licence>
                                                  <xsl:value-of select="regex-group(7)"/>
                                                </licence>
                                                <p>Every effort has been made to identify and
                                                  contact copyright holders and any omission or
                                                  error will be corrected if notification is made to
                                                  the publisher. If you think we got this wrong, or
                                                  you wish to know more, please visit <ref
                                                  target="https://www.openbookpublishers.com/section/85/1/image-copyright"
                                                  >https://www.openbookpublishers.com/section/85/1/image-copyright</ref></p>
                                            </availability>
                                            <xsl:if test="regex-group(8) != 'None'">
                                                <xsl:choose>
                                                  <xsl:when test="contains(regex-group(8), 'doi')">
                                                  <idno type="DOI">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </idno>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <ref target="{regex-group(8)}">
                                                  <xsl:value-of select="regex-group(8)"/>
                                                  </ref>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:if>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </bibl>
                            </xsl:if>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
            </xsl:if>
        </figure>
    </xsl:template>

    <!-- TABLES -->
    <xsl:template match="//html:table">
        <xsl:choose>
            <xsl:when test="ancestor::html:body[starts-with(@id, 'contents')]">
                <list xml:id="table-of-contents">
                    <xsl:apply-templates/>
                </list>
            </xsl:when>
            <xsl:otherwise>
                <table xml:id="{generate-id()}">
                    <xsl:apply-templates/>
                </table>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//html:tr">
        <xsl:choose>
            <xsl:when test="ancestor::html:body[starts-with(@id, 'contents')]">
                <item>
                    <xsl:apply-templates/>
                </item>
            </xsl:when>
            <xsl:otherwise>
                <row>
                    <xsl:apply-templates/>
                </row>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//html:td">
        <xsl:choose>
            <xsl:when test="ancestor::html:body[starts-with(@id, 'contents')]">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="cell">
                    <xsl:for-each select="@*">
                        <xsl:choose>
                            <xsl:when test="name(.) = 'colspan'">
                                <xsl:attribute name="cols">
                                    <xsl:value-of select="."> </xsl:value-of>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:when test="name(.) = 'rowspan'">
                                <xsl:attribute name="rows">
                                    <xsl:value-of select="."> </xsl:value-of>
                                </xsl:attribute>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- LINKS AND ANCHORS -->
    <xsl:template match="//html:a">
        <!-- Links and cross-refs -->
        <xsl:if test="@href">
            <xsl:choose>
                <xsl:when test="starts-with(@class, '_idFootnoteAnchor')"/>
                <xsl:when test="descendant::html:img">
                    <xsl:apply-templates select="descendant::html:img"/>
                </xsl:when>
                <xsl:otherwise>
                    <ref target="{replace(@href, 'xhtml#', 'xml#')}">
                        <xsl:apply-templates/>
                    </ref>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="not(@href)">
            <!-- Index markers -->
            <anchor xml:id="{@id}">
                <xsl:apply-templates/>
            </anchor>
        </xsl:if>
    </xsl:template>

    <!-- CHARACTER STYLES -->
    <xsl:template match="//html:span">
        <xsl:for-each select=".">
            <xsl:choose>
                <!-- Some more anchors -->
                <xsl:when test="@id and not(node())">
                    <anchor xml:id="{@id}">
                        <xsl:apply-templates/>
                    </anchor>
                </xsl:when>
                <!-- Actual spans -->
                <xsl:when test="node()">
                    <xsl:choose>
                        <!-- Italic -->
                        <xsl:when test="starts-with(@class, 'italic')">
                            <hi rendition="simple:italic">
                                <xsl:apply-templates/>
                            </hi>
                        </xsl:when>
                        <xsl:when test="starts-with(@class, 'bold')">
                            <!-- Bold italic -->
                            <xsl:if test="contains(@class, 'italic')">
                                <hi rendition="simple:bold">
                                    <hi rendition="simple:italic">
                                        <xsl:apply-templates/>
                                    </hi>
                                </hi>
                            </xsl:if>
                            <!-- Bold -->
                            <xsl:if test="not(contains(@class, 'italic'))">
                                <hi rendition="simple:bold">
                                    <xsl:apply-templates/>
                                </hi>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="starts-with(@class, 'superscript')">
                            <xsl:choose>
                                <!-- Find footnotes and move them inside the text at the right point of insertion -->
                                <xsl:when
                                    test="descendant::html:a[starts-with(@class, '_idFootnoteLink')]">
                                    <xsl:variable name="footnote-n">
                                        <xsl:value-of select="descendant::html:a"/>
                                    </xsl:variable>
                                    <xsl:element name="note">
                                        <xsl:attribute name="n">
                                            <xsl:value-of select="$footnote-n"/>
                                        </xsl:attribute>
                                        <xsl:apply-templates
                                            select="ancestor::html:body/descendant::html:div[starts-with(@class, '_idFootnotes')]/html:div[number($footnote-n)]"
                                        />
                                    </xsl:element>
                                </xsl:when>
                                <!-- Superscript italic -->
                                <xsl:when test="contains(@class, 'italic')">
                                    <hi rendition="simple:italic">
                                        <hi rendition="simple:superscript">
                                            <xsl:apply-templates/>
                                        </hi>
                                    </hi>
                                </xsl:when>
                                <!-- Superscript -->
                                <xsl:otherwise>
                                    <hi rendition="simple:superscript">
                                        <xsl:apply-templates/>
                                    </hi>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- Subscript -->
                        <xsl:when test="starts-with(@class, 'subscript')">
                            <hi rendition="simple:subscript">
                                <xsl:apply-templates/>
                            </hi>
                        </xsl:when>
                        <!-- Smaller -->
                        <xsl:when test="starts-with(@class, 'smaller')">
                            <hi rendition="simple:smaller">
                                <xsl:apply-templates/>
                            </hi>
                        </xsl:when>
                        <xsl:when test="starts-with(@class, 'times')">
                            <!-- Times New Roman italic -->
                            <xsl:if test="contains(@class, 'italic')">
                                <hi rendition="simple:italic">
                                    <xsl:apply-templates/>
                                </hi>
                            </xsl:if>
                            <!-- Times New Roman -->
                            <xsl:if test="not(contains(@class, 'italic'))">
                                <xsl:apply-templates/>
                            </xsl:if>
                        </xsl:when>
                        <!-- Underline -->
                        <xsl:when test="starts-with(@class, 'underline')">
                            <hi rendition="simple:underline">
                                <xsl:apply-templates/>
                            </hi>
                        </xsl:when>
                        <!-- Strikethrough italic -->
                        <xsl:when test="starts-with(@class, 'strikethrough')">
                            <xsl:if test="contains(@class, 'italic')">
                                <hi rendition="simple:strikethrough">
                                    <hi rendition="simple:italic">
                                        <xsl:apply-templates/>
                                    </hi>
                                </hi>
                            </xsl:if>
                            <!-- Strikethrough -->
                            <xsl:if test="not(contains(@class, 'italic'))">
                                <hi rendition="simple:strikethrough">
                                    <xsl:apply-templates/>
                                </hi>
                            </xsl:if>
                        </xsl:when>
                        <!-- Hyperlink -->
                        <xsl:when test="starts-with(@class, 'hyperlink')">
                            <xsl:apply-templates/>
                        </xsl:when>
                        <!-- Language -->
                        <xsl:when test="@lang">
                            <xsl:apply-templates/>
                        </xsl:when>
                        <!-- Line numbers in poetry -->
                        <xsl:when test="starts-with(@class, 'line-number')">
                            <label type="line-number">
                                <xsl:apply-templates/>
                            </label>
                        </xsl:when>
                        <xsl:otherwise>
                            <hi rendition="simple:normalstyle">
                                <xsl:apply-templates/>
                            </hi>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
