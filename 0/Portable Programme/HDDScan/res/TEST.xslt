<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
      <title>HDDScan Drive Test Report</title>
    </head>
    <body>
      <br />
      <div style="font-weight: bold; z-index: 102; left: 66px; color: navy;
        font-family: 'Arial'; position: absolute; top: 25px; height: 11px; background-color: white">
		  <span style="width: 500px">
			  HDDScan Drive Test Report
		  </span>
		  
      </div>
		<br />
		<div style="font-weight: normal; z-index: 101; left: 66px; width: 500px; position: absolute;
        top: 88px; font-size: 10pt; font-family: Arial">
			<span stype="font-color: white; font-size: 10pt; font-weight: normal; bgcolor: black">
				Model:  <xsl:value-of select="HDDScanReport/@model" />
			</span>
			<br />
			<span stype="font-color: white; font-size: 10pt; font-weight: normal; bgcolor: black">
				Firmware:  <xsl:value-of select="HDDScanReport/@firmware" />
			</span>
			<br />
			<span stype="font-color: white; font-size: 10pt; font-weight: normal; bgcolor: black">
				Serial:  <xsl:value-of select="HDDScanReport/@serial" />
			</span>
			<br />
			<span stype="font-color: white; font-size: 10pt; font-weight: normal; bgcolor: black">
				LBA:  <xsl:value-of select="HDDScanReport/@LBA" />
			</span>
			<br />
			<br />
			<span stype="font-size: 10pt; font-weight: normal">
				Report By:  <xsl:value-of select="HDDScanReport/@app" />
			</span>
			<br />
			<span stype="font-size: 10pt; font-weight: normal">
				Report Date: <xsl:value-of select="HDDScanReport/@time" />
			</span>
		<br />
			<br />
			<br />
		<img src="chart.emf" alt="Report graph" title="Report graph"/>
			<br />
			<br />
		<img src="stat.jpg" alt="Statistics" title="Statistics"/>
			<br />
			<br />
			<br />
			<br />
			<xsl:for-each select="HDDScanReport/REPORT">
	
			<xsl:for-each select="Property">				
				<xsl:value-of select="@Value"/>
				<br />
			</xsl:for-each>
			<br />	
			</xsl:for-each>
		</div>

	</body>
  </html>
</xsl:template>

</xsl:stylesheet> 
