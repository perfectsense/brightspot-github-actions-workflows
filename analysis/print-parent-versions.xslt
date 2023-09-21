<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pom="http://maven.apache.org/POM/4.0.0" version="1.0">
    <xsl:output method="text" encoding="UTF-8" />

    <xsl:template match="/">
        <xsl:for-each select="/pom:project/pom:parent"><xsl:if test="pom:artifactId = 'brightspot-parent' or pom:artifactId = 'express-parent' or pom:artifactId = 'dari-parent'"><xsl:value-of select="pom:version"/><xsl:text>&#xa;</xsl:text></xsl:if></xsl:for-each>
    </xsl:template>

<!--
    <xsl:template match="dependency[starts-with(@name,'blah')]">
        <xsl:value-of select="concat('HOST: ',@name, ' SERIAL: ', @serial)"/>
    </xsl:template>
-->
</xsl:transform>

