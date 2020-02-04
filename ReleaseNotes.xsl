<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="utf-8" indent="yes" doctype-system="about:legacy-compat"/>

  <xsl:param name="LNG"/>
  <xsl:param name="TOC"/>
  <xsl:param name="LVL2"/>

  <xsl:template match="root">
    <html>
      <head>
        <title>Release Notes</title>
        <style type="text/css">
          H1, H2, H3, H4, H5, H6 { font-family : Verdana, Geneva, Arial, Helvetica, sans-serif; }
          H1 {color : rgb(175, 184, 195);}
          H2 { font-size : 13pt; margin-top: 50pt; margin-bottom: -5pt; background-color: rgb(236, 239, 243);}
          H3 { font-size : 11pt; margin-bottom: -5pt; margin-top: 25pt; font-weight : bold; }
          H4 { font-size : 10pt; margin-bottom: -5pt; font-weight : bold; }
          H5 { text-align: center; color: #ff0000; }
          LI, P {font-family : Verdana, Geneva, Arial, Helvetica, sans-serif; font-size : 10pt; }
          LI { margin-left : -11pt }
          body { margin-left:80px; margin-right:80px; margin-top:50px; margin-bottom:50px }
          p.copyright {text-align: center; font-size: 8pt; }
          ul.nobullets {list-style: none ; padding: 0; margin-left: 1em; line-height: 125%;}
          p.back {margin-top: 50px; margin-bottom: 50px;}
        </style>
      </head>
      <body>

        <xsl:if test="$LNG='EN'">

          <div align="center">
            <h1>
              <xsl:value-of select="HistoryEntries/@ProductName"/> - <xsl:value-of select="HistoryEntries/@ReleaseNo"/> - Build <xsl:value-of select="HistoryEntries/@Build"/>
            </h1>
            <h3>Release Notes</h3>
            <p class="copyright">© 2015 Cubeware GmbH. All rights reserved.</p>
          </div>
		  
		 <xsl:if test="$TOC='yes'">
			<h2 id="TOP">Table of contents</h2>
			<ul class="nobullets">
			<xsl:apply-templates select="HistoryEntries" mode="TOC"/>
			</ul>
		</xsl:if>
		
		<xsl:if test="@ReleaseType='Fixpack'">
			<h2 id="TOP">Notes</h2>
			<p>In order to install this fixpack, simply execute the file <i><xsl:value-of select="HistoryEntries/@SetupExecutable"/></i>.</p>
		</xsl:if>
		
            <xsl:apply-templates/>

          <p class="back">
            <A href="#TOP">back to top</A>
          </p>

          <div>
            <p class="copyright">
              © 2015 Cubeware GmbH. Cubeware is a registered trademark of Cubeware GmbH. All other product names are trademarks of the respective manufacturers. We reserve the right to make technical modifications. Errors excepted. <xsl:value-of select="HistoryEntries/@BuildDate"/>.
            </p>
          </div>

        </xsl:if>

        <xsl:if test="$LNG='DE'">

          <div align="center">
            <h1>
              <xsl:value-of select="HistoryEntries/@ProductName"/> - <xsl:value-of select="HistoryEntries/@ReleaseNo"/> - Build <xsl:value-of select="HistoryEntries/@Build"/>
            </h1>
            <h3>Release Notes</h3>
            <p class="copyright">© 2015 Cubeware GmbH. Alle Rechte vorbehalten.</p>
          </div>
		 
		<!-- TOC can be activated/deactivated in the batch-file by setting the parameter to yes resp. no-->		 
		 <xsl:if test="$TOC='yes'">
			<h2 id="TOP">Inhaltsverzeichnis</h2>
			<ul class="nobullets">
			<xsl:apply-templates select="HistoryEntries" mode="TOC"/>
			</ul>
		</xsl:if>
      
		<xsl:if test="HistoryEntries/@ReleaseType='Fixpack'">
			<h2 id="TOP">Hinweise</h2>
			<p>Um den Fixpack zu installieren, führen Sie die Datei <i><xsl:value-of select="HistoryEntries/@SetupExecutable"/>
      </i> aus.</p>
		</xsl:if>

          <xsl:apply-templates/>

          <p class="back">
            <A href="#TOP">back to top</A>
          </p>

          <div>
            <p class="copyright">
              © 2015 Cubeware GmbH. Cubeware ist ein geschütztes Warenzeichen der Cubeware GmbH. Alle anderen Produktnamen sind eingetragene Marken und Warenzeichen der jeweiligen Hersteller. Technische Änderungen und Irrtum vorbehalten. <xsl:value-of select="HistoryEntries/@BuildDate"/>.
            </p>
          </div>

        </xsl:if>

      </body>
    </html>

  </xsl:template>

  <!-- the Category attribute serves as the key to group and sort entries according to the Muench grouping technique -->
  <xsl:key name="CAT" match="HistoryEntry" use="@Category" />
  
  <!-- the Area attribute serves as the key to group and sort entries on the second level -->
  <xsl:key name="AREA" match="HistoryEntry" use="@Area" />
  
  <!-- this key is required to access Content nodes after processing the headings -->
  <xsl:key name="CONTENT" match="HistoryEntry/Content" use="@Category" />

  <xsl:template match="HistoryEntries">
	
	<xsl:variable name="path_product" select="//HistoryEntries/HistoryEntry/@Product"/>
	
	<!-- look for the first History node of a certain Category and create a header depending on the language chosen -->
    <xsl:for-each select="HistoryEntry[generate-id()= generate-id(key('CAT', @Category)[1])]">
      <xsl:sort select="//HistoryEntries/@Category" order="ascending" />

      <xsl:if test="@Category='FIX'">
        <xsl:if test="$LNG='DE'">
          <h2><a name="{generate-id()}">Behobene Fehler und Probleme</a></h2>
        </xsl:if>
        <xsl:if test="$LNG='EN'">
          <h2><a name="{generate-id()}">Bug fixes and resolved problems</a></h2>
        </xsl:if>
      </xsl:if>

      <xsl:if test="@Category='KNI' ">
        <xsl:if test="$LNG='DE'">
          <h2><a name="{generate-id()}">Bekannte Fehler und Probleme</a></h2>
        </xsl:if>
        <xsl:if test="$LNG='EN'">
          <h2><a name="{generate-id()}">Known issues</a></h2>
        </xsl:if>
      </xsl:if>

      <xsl:if test="@Category='CHG'">
        <xsl:if test="$LNG='DE'">
          <h2><a name="{generate-id()}">Änderungen gegenüber früheren Versionen</a></h2>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <h2><a name="{generate-id()}">Changed functionality</a></h2>
        </xsl:if>
      </xsl:if>

      <xsl:if test="@Category='IMP'">
        <xsl:if test="$LNG='DE'">
          <h2><a name="{generate-id()}">Optimierungen und Verbesserungen</a></h2>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <h2><a name="{generate-id()}">Optimisations and improvements</a></h2>
        </xsl:if>
      </xsl:if>

      <xsl:if test="@Category='NEW'">
        <xsl:if test="$LNG='DE'">
          <h2><a name="{generate-id()}">Neue Features und Funktionen</a></h2>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <h2><a name="{generate-id()}">New features and functions</a></h2>
        </xsl:if>
      </xsl:if>

      <xsl:if test="@Category='COM'">
        <xsl:if test="$LNG='DE'">
          <h2><a name="{generate-id()}">Kompatibilität</a></h2>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <h2><a name="{generate-id()}">Compatibility</a></h2>
        </xsl:if>
      </xsl:if>
	 
	
	
	<!-- second level headings for history entries of selected products -->
	<xsl:if test="$LVL2='yes'">
	
		<xsl:variable name="category" select="@Category"/>		
		
		<xsl:if test="$path_product='Common' or $path_product='Cockpit' or $path_product='SAP Connectivity'">
		<xsl:for-each select="../HistoryEntry[generate-id() = generate-id(key('AREA', @Area)[@Category = $category][1])]">
		<xsl:sort select="@Area" order="ascending"/>
		
		<xsl:for-each select="key('AREA', @Area)[@Category = $category]">
		
				<xsl:if test="position() = 1">
				
					<!-- Connect -->
					<xsl:if test="$path_product='Common'">
						<xsl:if test="@Area='Common\Tools\SupportTool'">
							<h3>Support Tool (cwsupport.exe)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\OLAP\ODBO'">
							<h3>OLE DB for OLAP (cwiooledb.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\RDB\ODBC'">
							<h3>Microsoft ODBC (cwirodbc.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\OLAP\TM1'">
							<h3>IBM Cognos TM1 9.4 UNICODE (cwiotm1u.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\OLAP\PM OLAP'">
							<h3>Infor PM OLAP 10.1 UNICODE (cwiopmolap.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\OLAP\Cubebuilder'">
							<h3>Cube Builder for Microsoft Analysis Services 2008/2012 (cwiossas05.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\OLAP\Analysis Services'">
							<h3>Microsoft Analysis Services (cwiooledb.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\RDB\OLEDB'">
							<h3>OLE DB (cwiroledb.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\RDB\Text'">
							<h3>Textfile (cwirtext.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Interfaces\MIgration Wizard'">
							<h3>Migration Wizard (cwtomig.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Driver\OLAP\Essbase'">
							<h3>Oracle/Hyperion Essbase (cwioessbase.dll)</h3>      
						</xsl:if>
						<xsl:if test="@Area='Common\Interfaces\TCL-Script'">
							<h3>TCL</h3>      
						</xsl:if>
					</xsl:if>  
					
					<!-- Cockpit -->
					<xsl:if test="$path_product='Cockpit'">
						<xsl:if test="@Area='Cockpit\Distribution\History\Neutral\Export and Print' or @Area='Cockpit\Distribution\History\Windows\Export and Print' or @Area='Cockpit\Distribution\History\Windows\Export and Print'">
							<xsl:if test="$LNG='DE'">
								<h3>Export und Druck</h3>      
							</xsl:if>
							<xsl:if test="$LNG='EN'">
								<h3>Export and print</h3>      
							</xsl:if>						
						</xsl:if>
					<xsl:if test="@Area='Cockpit\Distribution\History\Neutral\Report Design' or @Area='Cockpit\Distribution\History\Windows\Report Design' or @Area='Cockpit\Distribution\History\Windows\Report Design'">
                    	<xsl:if test="$LNG='DE'">
							<h3>Berichtsdesign</h3>      
						</xsl:if>
						<xsl:if test="$LNG='EN'">
							<h3>Report design</h3>      
						</xsl:if>	
					</xsl:if>
					<xsl:if test="@Area='Cockpit\Distribution\History\Neutral\Administration' or @Area='Cockpit\Distribution\History\Windows\Administration' or @Area='Cockpit\Distribution\History\Windows\Administration'">
						<xsl:if test="$LNG='DE'">
							<h3>Administration</h3>      
						</xsl:if>
						<xsl:if test="$LNG='EN'">
							<h3>Administration</h3>      
						</xsl:if>	    
					</xsl:if>
					<xsl:if test="@Area='Cockpit\Distribution\History\Neutral\Miscellaneous Bug Fixes' or @Area='Cockpit\Distribution\History\Windows\Miscellaneous Bug Fixes' or @Area='Cockpit\Distribution\History\Windows\Miscellaneous Bug Fixes'">
						<xsl:if test="$LNG='DE'">
						<h3>Weitere</h3>      
						</xsl:if>
						<xsl:if test="$LNG='EN'">
						<h3>Miscellaneous</h3>      
						</xsl:if>	  
					</xsl:if>				
					</xsl:if>
					
					<!-- SAP Connect -->
					<xsl:if test="$path_product='SAP Connectivity'">
						<xsl:if test="@Area='SAP Connectivity'">
							<xsl:if test="$LNG='DE'">
								<h3>Allgemein</h3>      
							</xsl:if>
							<xsl:if test="$LNG='EN'">
								<h3>General</h3>      
							</xsl:if>						
						</xsl:if>
						<xsl:if test="@Area='SAP Connectivity\OLAP\BW'">
							<h3>SAP NetWeaver BW (OLAP - BAPI)</h3>  
						</xsl:if>
						<xsl:if test="@Area='SAP Connectivity\RDB\BAPI'">
							<h3>SAP NetWeaver AS ABAP - BAPI</h3>  
						</xsl:if>
						<xsl:if test="@Area='SAP Connectivity\RDB\OLEDB'">
							<h3>Cubeware OLE DB Provider</h3>   
						</xsl:if>
						<xsl:if test="@Area='SAP Connectivity\RDB\BW'">
							<h3>SAP NetWeaver BW (Query Flat)</h3>      							
						</xsl:if>
						<xsl:if test="@Area='SAP Connectivity\RDB\OpenSQL'">
							<h3>SAP NetWeaver AS ABAP - Open SQL</h3> 
						</xsl:if>
					</xsl:if>			
				
				</xsl:if>
		
		<xsl:if test="$LNG='DE'">
		<h4>
			<xsl:value-of select="concat(Content[@Language='DE']/@Category,': ')"/>
			<xsl:value-of select="Content[@Language='DE']/Title"/>
		</h4>
		<p><xsl:value-of select="Content[@Language='DE']/Text"/></p>
		</xsl:if>
			
		<xsl:if test="$LNG='EN'">
		<h4>
			<xsl:value-of select="concat(Content[@Language='EN']/@Category,': ')"/>
			<xsl:value-of select="Content[@Language='EN']/Title"/>
		</h4>
		<p><xsl:value-of select="Content[@Language='EN']/Text"/></p>
		</xsl:if>		
	</xsl:for-each>
	</xsl:for-each>
	</xsl:if>	
	</xsl:if>
	
	  
	<!-- create HTML for each Content node in one-level grouping (excluding products with two-level sorting, which is handled above) -->
	<xsl:if test="$LNG='EN' and $LVL2='no'">
      <xsl:for-each select="key('CONTENT', @Category)[@Language='EN']">
        <xsl:sort select="@Category"  />
		
		<h4>
          <xsl:value-of select="concat(self::node()[@Language='EN']/@Category,': ')"/>
          <xsl:value-of select="self::node()[@Language='EN']/Title"/>
        </h4>
        <p>
          <xsl:value-of select="self::node()[@Language='EN']/Text"/>
        </p>				
      </xsl:for-each>
	</xsl:if>
	
	<xsl:if test="$LNG='DE' and $LVL2='no'">
      <xsl:for-each select="key('CONTENT', @Category)[@Language='DE']">
        <xsl:sort select="@Category"  />
		
		<h4>
          <xsl:value-of select="concat(self::node()[@Language='DE']/@Category,': ')"/>
          <xsl:value-of select="self::node()[@Language='DE']/Title"/>
        </h4>
        <p>
          <xsl:value-of select="self::node()[@Language='DE']/Text"/>
        </p>				
      </xsl:for-each>
	</xsl:if>	
	</xsl:for-each>
	
  </xsl:template>
	
	<!-- generate table of contents (TOC) with hyperlinks based on automatically generated IDs -->
	<!-- TOC can be activated or deactivated in the batch file by setting the parameter to yes resp. no-->
	<xsl:template match="HistoryEntries" mode="TOC">
	
	<xsl:for-each select="HistoryEntry[generate-id()= generate-id(key('CAT', @Category)[1])]">
      <xsl:sort select="//HistoryEntries/@Category" order="ascending" />

      <xsl:if test="@Category='FIX'">
        <xsl:if test="$LNG='DE'">
          <li><a href="#{generate-id()}">Behobene Fehler und Probleme</a> <xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
        <xsl:if test="$LNG='EN'">
          <li><a href="#{generate-id()}">Bug fixes and resolved problems</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
      </xsl:if>



      <xsl:if test="@Category='KNI' ">
        <xsl:if test="$LNG='DE'">
          <li><a href="#{generate-id()}">Bekannte Fehler und Probleme</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
        <xsl:if test="$LNG='EN'">
          <li><a href="#{generate-id()}">Known issues</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
      </xsl:if>
	  
	  
	  
	  <xsl:if test="@Category='CHG'">
        <xsl:if test="$LNG='DE'">
          <li><a href="#{generate-id()}">Änderungen gegenüber früheren Versionen</a> <xsl:value-of select="concat(' (',@Category,')')"/> </li>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <li><a href="#{generate-id()}">Changed functionality</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
      </xsl:if>



      <xsl:if test="@Category='IMP'">
        <xsl:if test="$LNG='DE'">
          <li><a href="#{generate-id()}">Optimierungen und Verbesserungen</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <li><a href="#{generate-id()}">Optimisations and improvements</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
      </xsl:if>

      <xsl:if test="@Category='NEW'">
        <xsl:if test="$LNG='DE'">
          <li><a href="#{generate-id()}">Neue Features und Funktionen</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <li><a href="#{generate-id()}">New features and functions</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
      </xsl:if>


      <xsl:if test="@Category='COM'">
        <xsl:if test="$LNG='DE'">
          <li><a href="#{generate-id()}">Kompatibilität</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>

        <xsl:if test="$LNG='EN'">
          <li><a href="#{generate-id()}">Compatibility</a><xsl:value-of select="concat(' (',@Category,')')"/></li>
        </xsl:if>
      </xsl:if>	  
	 
	</xsl:for-each>
	
	</xsl:template>


</xsl:stylesheet>