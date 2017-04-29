<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:variable name="table_column"><![CDATA[ & ]]></xsl:variable>
  <xsl:variable name="table_row"><![CDATA[ \\]]></xsl:variable>

  <xsl:param name="include-folio-numbers">yes</xsl:param>
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
<xsl:choose>
  <xsl:when test="$include-folio-numbers = 'yes'">
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
  </xsl:when>
  <xsl:otherwise>
    \begin{longtabu} to \textwidth {X[0.5,l] X[5,l]}
    
    \toprule
    \textbf{No.} <xsl:value-of select="$table_column"/> \textbf{Title} \\ \midrule
    \endfirsthead
    
    \multicolumn{2}{c}{{\tablename} \thetable{} -- continued} \\
    \toprule
    \textbf{No.} <xsl:value-of select="$table_column"/> \textbf{Title} \\ \midrule
    \endhead
    
    \midrule
    \caption{List of questions in <xsl:value-of select="$authorName"/>, \emph{<xsl:value-of select="$textTitle"/>}.\hfill\enskip} \\
    \endfoot
    
    \bottomrule
    \caption{List of questions in <xsl:value-of select="$authorName"/>, \emph{<xsl:value-of select="$textTitle"/>}.\hfill\enskip} \\
    \label{fig:question-list:Dinsdale}
    \endlastfoot
    </xsl:otherwise>
  </xsl:choose>
<xsl:apply-templates select="//div[@id='body']"/>
\end{longtabu}
  </xsl:template>

  <xsl:template match="//header">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="head">
    <xsl:choose>
      <xsl:when test="$include-folio-numbers = 'yes'">
        <xsl:text>\multicolumn{3}{c}{\textbf{</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\multicolumn{2}{c}{\textbf{</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates />
    <xsl:text>}}</xsl:text>
    <xsl:value-of select="$table_row"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="item">
    <xsl:variable name="itemTokenizedID" select="tokenize(fileName/@filestem, '-')"/>
    <xsl:variable name="itemStructureNumber" select="$itemTokenizedID[3]"/>
    <xsl:variable name="structure-number">
      <!-- If title contains number -->
      <xsl:if test="translate(title, '1234567890', '') != title">
        <!-- If title contains comma -->
        <xsl:if test="translate(title, ',', '') != title">
          <xsl:number value="translate(substring-before(title, ','), translate(substring-before(title, ','), '1234567890', ''), '')"  format="I"/>
          <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:number value="translate(substring-after(title, ','), translate(substring-after(title, ','), '1234567890', ''), '')"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$structure-number"/>
    <xsl:value-of select="$table_column"/>
    <xsl:choose>
      <xsl:when test="title and not(question-title or question-title = '')">
        <xsl:value-of select="normalize-space(title)"/>
      </xsl:when>
      <xsl:when test="question-title">
        <xsl:value-of select="normalize-space(question-title)"/>
      </xsl:when>
      <xsl:otherwise>No title or questionTitle provided</xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$include-folio-numbers = 'yes'">
      <xsl:value-of select="$table_column"/>
      <xsl:call-template name="getWitnesses" />
    </xsl:if>
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
