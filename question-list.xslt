<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:variable name="table_column"><![CDATA[ & ]]></xsl:variable>
  <xsl:variable name="table_row"><![CDATA[ \\{}]]></xsl:variable>

  <xsl:output method="text" indent="no"/>
  <xsl:template match="text()">
    <xsl:value-of select="replace(., '\s+', ' ')"/>
  </xsl:template>

  <xsl:variable name="multipleWitnesses">
    <xsl:if test="count(hasWitnesses/descendant::witness) &lt; 1">
      <xsl:value-of select="true()"/>
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="authorName" select="/listofFileNames/header/authorName"/>
  <xsl:variable name="textTitle" select="/listofFileNames/header/commentaryName"/>

  <xsl:template match="/">
% NOTE: This requires the following packages enabled in the preamble:
% \usepackage{tabu, longtable, booktabs}
\tabulinesep=1.5mm
\begin{longtabu} to \textwidth {X[0.5,l] X[5,l] X[1.5,l]}

\toprule
\textbf{No.} <xsl:value-of select="$table_column"/> \textbf{Title} <xsl:value-of select="$table_column"/> \textbf{Witnesses} \\ \midrule
\endfirsthead

\multicolumn{3}{c}{{\tablename} \thetable{} -- continued} \\
\toprule
\textbf{No.} <xsl:value-of select="$table_column"/> \textbf{Title} <xsl:value-of select="$table_column"/> \textbf{Witnesses} \\ \midrule
\endhead

\midrule
\caption{List of questions in <xsl:value-of select="$authorName"/>, \emph{<xsl:value-of select="$textTitle"/>}.\hfill\enskip} \\
\endfoot

\bottomrule
\caption{List of questions in <xsl:value-of select="$authorName"/>, \emph{<xsl:value-of select="$textTitle"/>}.\hfill\enskip} \\
\label{fig:question-list:Dinsdale}
\endlastfoot
<xsl:apply-templates select="//div[@id='body']"/>
\end{longtabu}
  </xsl:template>

  <xsl:template match="//header">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="head">
    <xsl:text>\multicolumn{3}{c}{\textbf{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}}\\&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="item">
    <xsl:variable name="itemTokenizedID" select="tokenize(fileName/@filestem, '-')"/>
    <xsl:variable name="itemStructureNumber" select="$itemTokenizedID[3]"/>
    <xsl:variable name="questionNumber">
      <xsl:if test="contains($itemStructureNumber, 'q') and contains($itemStructureNumber, 'l')">
        <xsl:number value="substring-after(substring-before($itemStructureNumber, 'q'), 'l')" format="I"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="substring-after($itemStructureNumber, 'q')"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$questionNumber"/>
    <xsl:value-of select="$table_column"/>
    <xsl:choose>
      <xsl:when test="title and (not(questionTitle) or (questionTitle = ''))">
        <xsl:value-of select="normalize-space(title)"/>
      </xsl:when>
      <xsl:when test="questionTitle">
        <xsl:value-of select="normalize-space(questionTitle)"/>
      </xsl:when>
      <xsl:otherwise>No title or questionTitle provided</xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$table_column"/>
    <xsl:call-template name="getWitnesses" />
    <xsl:value-of select="$table_row"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template name="getWitnesses">
    <xsl:param name="context" select="hasWitnesses"/>
    <xsl:for-each  select="$context/witness">
      <xsl:value-of select="translate(@ref, '#', '')"/>
      <xsl:choose>
        <xsl:when test="count(folio) &gt; 1">
          <!-- More than one folio -->
          <xsl:value-of select="folio[1]"/>
          <xsl:variable name="firstColumns" select="tokenize(folio[1]/@c, ' ')"/>
          <xsl:value-of select="$firstColumns[1]"/>
          <xsl:text>--</xsl:text>
          <xsl:value-of select="folio[last()]"/>
          <xsl:variable name="lastColumns" select="tokenize(folio[last()]/@c, ' ')"/>
          <xsl:value-of select="$lastColumns[last()]"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Just one folio -->
          <xsl:value-of select="folio"/>
          <xsl:variable name="columns" select="tokenize(folio/@c, ' ')"/>
          <xsl:choose>
            <xsl:when test="count($columns) = 0">
              <!-- Assumption: When no columns are given, it takes up both. This also assumes that
                   the manuscript is written in two columns -->
              <xsl:text>a--b</xsl:text>
            </xsl:when>
            <xsl:when test="count($columns) = 1">
              <xsl:value-of select="$columns[1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$columns[1]"/>
              <xsl:text>--</xsl:text>
              <xsl:value-of select="$columns[last()]"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::witness">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
