<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:jd="http://www.osjava.org/jardiff/0.1" version="1.0">

  <!-- Format output as html -->
  <xsl:output indent="yes"/>

  <!-- External parameter -->
  <xsl:param name="from-api" select="''"/>
  <xsl:param name="to-api" select="''"/>
  <xsl:param name="stylesheet" select="''"/>

  <!-- Match root node -->
  <xsl:template match="jd:diff">
     <html>
      <head>
       <title>Comparing <xsl:value-of select="@old"/> to <xsl:value-of select="@new"/></title>
       <xsl:choose>
         <xsl:when test="$stylesheet">
       <link href="{$stylesheet}" rel="stylesheet" type="text/css"/>
         </xsl:when>
         <xsl:otherwise>
       <style type="text/css">
  <!-- TODO -->
       </style>
         </xsl:otherwise>
       </xsl:choose>
      </head>
      <body>
       <h2>Comparing <xsl:value-of select="@old"/> to <xsl:value-of select="@new"/></h2>
        <xsl:apply-templates/>
       <p>API diff generated by <a href="http://www.osjava.org/jardiff/">JarDiff</a></p>
      </body>
     </html>
  </xsl:template>

  <!-- Skip contents nodes, as these are just meta information -->
  <xsl:template match="jd:oldcontents"/>

  <!-- Skip contents nodes, as these are just meta information -->
  <xsl:template match="jd:newcontents"/>

  <!-- Match removed node (always class removed in this context) -->
  <xsl:template match="jd:removed">
    <xsl:if test="jd:class">
    <h3>Removed classes</h3>
    <ul class="class-removed">
    <xsl:for-each select="jd:class">
      <li>
        <xsl:call-template name="link-from-class">
          <xsl:with-param name="class" select="@name"/>
          <xsl:with-param name="data">
            <xsl:call-template name="print-class-name">
              <xsl:with-param name="class" select="@name"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </li>
    </xsl:for-each>
    </ul>
    </xsl:if>
  </xsl:template>

  <!-- Match added node (always class added in this context) -->
  <xsl:template match="jd:added">
    <xsl:if test="jd:class">
    <h3>Added classes</h3>
    <ul class="class-added">
    <xsl:for-each select="jd:class">
      <li>
        <xsl:call-template name="link-to-class">
          <xsl:with-param name="class" select="@name"/>
          <xsl:with-param name="data">
            <xsl:call-template name="print-class-name">
              <xsl:with-param name="class" select="@name"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </li>
    </xsl:for-each>
    </ul>
    </xsl:if>
  </xsl:template>

  <!-- Match changed node (and process the classchanged contents) -->
  <xsl:template match="jd:changed">
    <xsl:if test="jd:classchanged">
    <h3>Changed classes</h3>
    <ul class="class-changed">
      <xsl:for-each select="jd:classchanged">
        <li><h4>
        <xsl:call-template name="print-class-name">
          <xsl:with-param name="class" select="@name"/>
        </xsl:call-template>
        </h4>
        <!-- Useful backreference -->
        <xsl:variable name="class" select="@name"/>
        <xsl:if test="jd:removed/*">
          <h5>Removed:</h5>
          <ul>
            <xsl:for-each select="jd:removed/jd:field">
              <li>
                <xsl:call-template name="link-from-anchor">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="anchor" select="@name"/>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-field"/>
                  </xsl:with-param>
                </xsl:call-template>
              </li>
            </xsl:for-each>
            <xsl:for-each select="jd:removed/jd:method">
              <li>
                <xsl:call-template name="link-from-anchor">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="anchor">
                    <xsl:call-template name="print-method-anchor">
                      <xsl:with-param name="class" select="$class"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-method">
                      <xsl:with-param name="class" select="$class"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <xsl:if test="jd:added/*">
          <h5>Added:</h5>
          <ul>
            <xsl:for-each select="jd:added/jd:field">
              <li>
                <xsl:call-template name="link-to-anchor">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="anchor" select="@name"/>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-field"/>
                  </xsl:with-param>
                </xsl:call-template>
              </li>
            </xsl:for-each>
            <xsl:for-each select="jd:added/jd:method">
              <li>
                <xsl:call-template name="link-to-anchor">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="anchor">
                    <xsl:call-template name="print-method-anchor">
                      <xsl:with-param name="class" select="$class"/>
                    </xsl:call-template>
                  </xsl:with-param>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-method">
                      <xsl:with-param name="class" select="$class"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        <xsl:if test="jd:changed/*">
          <h5>Changed:</h5>
          <ul>
            <xsl:for-each select="jd:changed/jd:classchange">
            <li>
              <xsl:for-each select="jd:from/jd:class">
                <span>From:
                <xsl:call-template name="link-from-class">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-class"/>
                  </xsl:with-param>
                </xsl:call-template>
                </span>
              </xsl:for-each>
              <br/>
              <xsl:for-each select="jd:to/jd:class">
                <span>To:
                <xsl:call-template name="link-to-class">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-class"/>
                  </xsl:with-param>
                </xsl:call-template>
                </span>
              </xsl:for-each>
            </li>
            </xsl:for-each>
            <xsl:for-each select="jd:changed/jd:fieldchange">
            <li>
              <xsl:for-each select="jd:from/jd:field">
                <span>From: 
                <xsl:call-template name="link-from-anchor">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="anchor" select="@name"/>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-field"/>
                  </xsl:with-param>
                </xsl:call-template>
                </span>
              </xsl:for-each>
              <br/>
              <xsl:for-each select="jd:to/jd:field">
                <span>To: 
                <xsl:call-template name="link-from-anchor">
                  <xsl:with-param name="class" select="$class"/>
                  <xsl:with-param name="anchor" select="@name"/>
                  <xsl:with-param name="data">
                    <xsl:call-template name="print-field"/>
                  </xsl:with-param>
                </xsl:call-template>
                </span>
              </xsl:for-each>
            </li>
            </xsl:for-each>
            <xsl:for-each select="jd:changed/jd:methodchange">
            <li>
              <xsl:for-each select="jd:from/jd:method">
                <span>From:
                  <xsl:call-template name="link-from-anchor">
                    <xsl:with-param name="class" select="$class"/>
                    <xsl:with-param name="anchor">
                      <xsl:call-template name="print-method-anchor">
                        <xsl:with-param name="class" select="$class"/>
                      </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="data">
                      <xsl:call-template name="print-method">
                        <xsl:with-param name="class" select="$class"/>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
                </span>
              </xsl:for-each>
              <br/>
              <xsl:for-each select="jd:to/jd:method">
                <span>To:
                  <xsl:call-template name="link-to-anchor">
                    <xsl:with-param name="class" select="$class"/>
                    <xsl:with-param name="anchor">
                      <xsl:call-template name="print-method-anchor">
                        <xsl:with-param name="class" select="$class"/>
                      </xsl:call-template>
                    </xsl:with-param>
                    <xsl:with-param name="data">
                      <xsl:call-template name="print-method">
                        <xsl:with-param name="class" select="$class"/>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
                </span>
              </xsl:for-each>
            </li>
            </xsl:for-each>
          </ul>
        </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
    </xsl:if>
  </xsl:template>

  <!-- pass unrecognized nodes along unchanged -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>  


  <!-- Print out a method anchor suitable for linking to javadocs -->
  <xsl:template name="print-method-anchor">
    <xsl:param name="class"/>
    <xsl:choose>
      <!-- XXX: This may not be correct for inner classes -->
      <xsl:when test="@name = '&lt;init&gt;'">
        <xsl:call-template name="print-short-name">
          <xsl:with-param name="class" select="$class"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@name"/>
      </xsl:otherwise>
    </xsl:choose>(<xsl:for-each select="jd:arguments/jd:type"><xsl:call-template name="print-type"/><xsl:if test="position() != last()">, </xsl:if></xsl:for-each>)</xsl:template>

  <!-- Print out a method -->
  <xsl:template name="print-method">
    <xsl:param name="class"/>
    <span class="method">
      <xsl:if test="@deprecated='yes'"><em>deprecated: </em></xsl:if>
      <xsl:value-of select="@access"/><xsl:value-of select="' '"/>
      <xsl:if test="@final='yes'">final </xsl:if>
      <xsl:if test="@static='yes'">static </xsl:if>
      <xsl:if test="@synchronized='yes'">synchronized </xsl:if>
      <xsl:if test="@abstract='yes'">abstract </xsl:if>
      <xsl:choose>
        <xsl:when test="@name='&lt;init&gt;'">
          <xsl:call-template name="print-short-name">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="jd:return/jd:type">
            <xsl:call-template name="print-type"/>
          </xsl:for-each>
          <xsl:value-of select="' '"/><xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>(<xsl:for-each select="jd:arguments/jd:type"><xsl:call-template name="print-type"/><xsl:if test="position()!=last()">, </xsl:if></xsl:for-each>)<xsl:for-each select="jd:exception"><xsl:if test="position() = 1"> throws </xsl:if><xsl:call-template name="print-class-name"><xsl:with-param name="class" select="@name"/></xsl:call-template><xsl:if test="position()!=last()">, </xsl:if></xsl:for-each>
    </span>
  </xsl:template>

  <!-- Print out a field -->
  <xsl:template name="print-field">
    <span class="field">
    <xsl:if test="@deprecated='yes'"><em>deprecated: </em></xsl:if>
    <xsl:value-of select="@access"/><xsl:value-of select="' '"/>
    <xsl:if test="@final='yes'">final </xsl:if>
    <xsl:if test="@static='yes'">static </xsl:if>
    <xsl:if test="@transient='yes'">transient </xsl:if>
    <xsl:if test="@volatile='yes'">volatile </xsl:if>
    <xsl:for-each select="jd:type">
      <xsl:call-template name="print-type"/>
    </xsl:for-each>
    <xsl:value-of select="concat(' ',@name)"/>
    <xsl:if test="@value"> = <xsl:value-of select="@value"/></xsl:if>;
    </span>
  </xsl:template>

  <!-- Print out a class -->
  <xsl:template name="print-class">
   <span class="class">
   <xsl:if test="@deprecated='yes'"><i>deprecated: </i></xsl:if>
   <xsl:value-of select="@access"/><xsl:value-of select="' '"/>
   <xsl:if test="@abstract='yes'">abstract<xsl:value-of select="' '"/></xsl:if>
   <xsl:if test="@static='yes'">static<xsl:value-of select="' '"/></xsl:if>
   <xsl:if test="@final='yes'">final<xsl:value-of select="' '"/></xsl:if>
   <xsl:call-template name="print-class-name">
     <xsl:with-param name="class" select="@name"/>
   </xsl:call-template>
   <xsl:if test="@superclass and @superclass != 'java/lang/Object'"> extends <xsl:call-template name="print-class-name"><xsl:with-param name="class" select="@superclass"/></xsl:call-template></xsl:if>
   <xsl:for-each select="jd:implements">
     <xsl:if test="position()=1"> implements </xsl:if>
     <xsl:call-template name="print-class-name"><xsl:with-param name="class" select="@name"/></xsl:call-template>
     <xsl:if test="position()!=last()">, </xsl:if>
   </xsl:for-each>
   </span>
  </xsl:template>

  <!-- Link a class and anchor to the from API documents -->
  <xsl:template name="link-from-anchor">
    <xsl:param name="class"/>
    <xsl:param name="anchor"/>
    <xsl:param name="data"/>
    <xsl:choose>
      <xsl:when test="$from-api and /jd:diff/jd:oldcontents/jd:class[@name = $class]">
        <a href="{$from-api}/{translate($class, '$', '.')}.html#{$anchor}">
          <xsl:value-of select="$data"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$data"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Link a class and anchor to the to API documents -->
  <xsl:template name="link-to-anchor">
    <xsl:param name="class"/>
    <xsl:param name="anchor"/>
    <xsl:param name="data"/>
    <xsl:choose>
      <xsl:when test="$to-api and /jd:diff/jd:newcontents/jd:class[@name = $class]">
        <a href="{$to-api}/{translate($class, '$', '.')}.html#{$anchor}">
          <xsl:value-of select="$data"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$data"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Link a class name to the from API documents -->
  <xsl:template name="link-from-class">
    <xsl:param name="class"/>
    <xsl:param name="data"/>
    <xsl:choose>
      <xsl:when test="$from-api and /jd:diff/jd:oldcontents/jd:class[@name = $class]">
        <a href="{$from-api}/{translate($class, '$', '.')}.html">
          <xsl:value-of select="$data"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$data"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Link a class name to the to API documents -->
  <xsl:template name="link-to-class">
    <xsl:param name="class"/>
    <xsl:param name="data"/>
    <xsl:choose>
      <xsl:when test="$to-api and /jd:diff/jd:newcontents/jd:class[@name = $class]">
        <a href="{$to-api}/{translate($class, '$', '.')}.html">
          <xsl:value-of select="$data"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$data"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Print a class name -->
  <xsl:template name="print-class-name">
    <xsl:param name="class"/>
    <xsl:value-of select="translate($class, '/$', '..')"/>
  </xsl:template>

  <!-- Print out a type (argument, return, field types) -->
  <xsl:template name="print-type">
    <xsl:choose>
      <xsl:when test="@primitive='yes'">
        <xsl:value-of select="@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="print-class-name">
          <xsl:with-param name="class" select="@name"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="@array='yes'">
      <xsl:call-template name="array-subscript">
        <xsl:with-param name="dimensions" select="@dimensions"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- Print out an array subscript -->
  <xsl:template name="array-subscript"><xsl:param name="dimensions"/>[]<xsl:if test="$dimensions > 1"><xsl:call-template name="array-subscript"><xsl:with-param name="dimensions" select="$dimensions - 1"/></xsl:call-template></xsl:if></xsl:template>

  <!-- Print out the short name of a class (used to create constructor text) -->
  <xsl:template name="print-short-name">
    <xsl:param name="class"/>
    <xsl:choose>
      <xsl:when test="contains($class,'/')">
        <xsl:call-template name="print-short-name">
          <xsl:with-param name="class" select="substring-after($class,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="translate($class,'$','.')"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
