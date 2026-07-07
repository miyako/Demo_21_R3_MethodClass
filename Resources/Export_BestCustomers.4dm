//%attributes = {"lang":"en"}
// =============================================================================
// Export_BestCustomers_xlsx
//
// Generates a REAL .xlsx spreadsheet (Office Open XML) on the Desktop, listing
// the best 50 customers with annual revenue broken down in columns.
//
// The .xlsx format is a ZIP archive of XML "parts". This method builds each XML
// part as text, writes them into a temporary folder, then uses 4D's native ZIP
// commands (ZIP Create archive) to package them into the final workbook.
//
//   * Cell background colours form a heat-map highlighting the significance of
//     each customer's revenue (darkest green = strongest, red = weakest).
//   * The document's created / modified timestamps are set to the current
//     date & time (UTC, W3CDTF) in docProps/core.xml.
//
// Data model:  CLIENTS  <--(Client)--  INVOICES(Creation_Date, Total)
// =============================================================================

var $invoices : cs.INVOICESSelection
var $inv : cs.INVOICESEntity
var $years : Collection
var $byClient : Object
var $cid; $yStr; $nm; $cy; $co; $key : Text
var $o : Object
var $y : Integer
var $stats : Collection
var $s : Object
var $maxYear; $maxGrand; $v; $r; $cents; $whole; $rem : Real
var $totalCols; $ci; $n; $rr; $rank; $row; $sIdx; $tr; $lastRow : Integer
var $ss; $remStr; $lit; $lastCol : Text
var $L : Collection
var $ct; $rels; $core; $app; $wb; $wbrels; $styles; $sheet; $ts : Text
var $yearTotals : Object
var $build : 4D.Folder
var $zip; $status : Object
var $xlsx : 4D.File

// -----------------------------------------------------------------------------
// 1) Gather data in a single pass over the invoices
// -----------------------------------------------------------------------------
$invoices:=ds.INVOICES.all()

If ($invoices.length=0)
	ALERT("No invoices found.")
	return
End if

$years:=[]
$byClient:={}  // key = client ID -> {name; city; country; count; grand; years{}}

For each ($inv; $invoices)

	If ($inv.Creation_Date#!00-00-00!) & ($inv.Client#Null)

		$cid:=String($inv.Client_ID)

		If ($byClient[$cid]=Null)

			// Escape XML-sensitive characters once per customer
			$nm:=$inv.Client.Name
			$nm:=Replace string($nm; "&"; "&amp;"; *)
			$nm:=Replace string($nm; "<"; "&lt;"; *)
			$nm:=Replace string($nm; ">"; "&gt;"; *)
			$cy:=$inv.Client.City
			$cy:=Replace string($cy; "&"; "&amp;"; *)
			$cy:=Replace string($cy; "<"; "&lt;"; *)
			$cy:=Replace string($cy; ">"; "&gt;"; *)
			$co:=$inv.Client.Country
			$co:=Replace string($co; "&"; "&amp;"; *)
			$co:=Replace string($co; "<"; "&lt;"; *)
			$co:=Replace string($co; ">"; "&gt;"; *)

			$o:={}
			$o.name:=$nm
			$o.city:=$cy
			$o.country:=$co
			$o.count:=0
			$o.grand:=0
			$o.years:={}
			$byClient[$cid]:=$o

		End if

		$y:=Year of($inv.Creation_Date)
		$yStr:=String($y)

		$byClient[$cid].count:=$byClient[$cid].count+1
		$byClient[$cid].grand:=$byClient[$cid].grand+$inv.Total
		$byClient[$cid].years[$yStr]:=Num($byClient[$cid].years[$yStr])+$inv.Total

		If ($years.indexOf($y)=-1)
			$years.push($y)
		End if

	End if

End for each

$years:=$years.orderBy(ck ascending)

// Build the customer collection, keep the best 50 by grand total
$stats:=[]
For each ($key; $byClient)
	$stats.push($byClient[$key])
End for each

$stats:=$stats.orderBy("grand desc")
If ($stats.length>50)
	$stats:=$stats.slice(0; 50)
End if

// Reference maxima (over the displayed customers) for the colour heat-map
$maxYear:=0
$maxGrand:=0
For each ($s; $stats)
	If ($s.grand>$maxGrand)
		$maxGrand:=$s.grand
	End if
	For each ($y; $years)
		$v:=Num($s.years[String($y)])
		If ($v>$maxYear)
			$maxYear:=$v
		End if
	End for each
End for each

// -----------------------------------------------------------------------------
// 2) Pre-compute column letters (A, B, ... Z, AA ...)
//    Columns: 1=#  2=Customer  3=City  4=Country  5=Invoices
//             6..=one per year  then Grand Total
// -----------------------------------------------------------------------------
$totalCols:=5+$years.length+1
$L:=[]
$L.push("")  // index 0 placeholder so $L[colIndex] is 1-based
For ($ci; 1; $totalCols)
	$n:=$ci
	$ss:=""
	While ($n>0)
		$rr:=($n-1)%26
		$ss:=Char(65+$rr)+$ss
		$n:=Int(($n-1)/26)
	End while
	$L.push($ss)
End for
$lastCol:=$L[$totalCols]
$lastRow:=2+$stats.length+1  // title + header + data + total
$tr:=3+$stats.length  // total row number

// -----------------------------------------------------------------------------
// 3) Static XML parts
// -----------------------------------------------------------------------------
// Current date & time, W3CDTF (e.g. 2026-07-07T09:15:42Z) for the doc metadata
$ts:=Substring(Timestamp; 1; 19)+"Z"

$ct:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$ct:=$ct+"<Types xmlns='http://schemas.openxmlformats.org/package/2006/content-types'>"
$ct:=$ct+"<Default Extension='rels' ContentType='application/vnd.openxmlformats-package.relationships+xml'/>"
$ct:=$ct+"<Default Extension='xml' ContentType='application/xml'/>"
$ct:=$ct+"<Override PartName='/xl/workbook.xml' ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml'/>"
$ct:=$ct+"<Override PartName='/xl/worksheets/sheet1.xml' ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml'/>"
$ct:=$ct+"<Override PartName='/xl/styles.xml' ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml'/>"
$ct:=$ct+"<Override PartName='/docProps/core.xml' ContentType='application/vnd.openxmlformats-package.core-properties+xml'/>"
$ct:=$ct+"<Override PartName='/docProps/app.xml' ContentType='application/vnd.openxmlformats-officedocument.extended-properties+xml'/>"
$ct:=$ct+"</Types>"

$rels:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$rels:=$rels+"<Relationships xmlns='http://schemas.openxmlformats.org/package/2006/relationships'>"
$rels:=$rels+"<Relationship Id='rId1' Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument' Target='xl/workbook.xml'/>"
$rels:=$rels+"<Relationship Id='rId2' Type='http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties' Target='docProps/core.xml'/>"
$rels:=$rels+"<Relationship Id='rId3' Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties' Target='docProps/app.xml'/>"
$rels:=$rels+"</Relationships>"

$core:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$core:=$core+"<cp:coreProperties xmlns:cp='http://schemas.openxmlformats.org/package/2006/metadata/core-properties' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' xmlns:dcmitype='http://purl.org/dc/dcmitype/' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>"
$core:=$core+"<dc:title>Best Customers - Annual Revenue</dc:title>"
$core:=$core+"<dc:creator>4D</dc:creator>"
$core:=$core+"<cp:lastModifiedBy>4D</cp:lastModifiedBy>"
$core:=$core+"<dcterms:created xsi:type='dcterms:W3CDTF'>"+$ts+"</dcterms:created>"
$core:=$core+"<dcterms:modified xsi:type='dcterms:W3CDTF'>"+$ts+"</dcterms:modified>"
$core:=$core+"</cp:coreProperties>"

$app:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$app:=$app+"<Properties xmlns='http://schemas.openxmlformats.org/officeDocument/2006/extended-properties'>"
$app:=$app+"<Application>4D</Application>"
$app:=$app+"</Properties>"

$wb:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$wb:=$wb+"<workbook xmlns='http://schemas.openxmlformats.org/spreadsheetml/2006/main' xmlns:r='http://schemas.openxmlformats.org/officeDocument/2006/relationships'>"
$wb:=$wb+"<sheets><sheet name='Best Customers' sheetId='1' r:id='rId1'/></sheets>"
$wb:=$wb+"</workbook>"

$wbrels:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$wbrels:=$wbrels+"<Relationships xmlns='http://schemas.openxmlformats.org/package/2006/relationships'>"
$wbrels:=$wbrels+"<Relationship Id='rId1' Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet' Target='worksheets/sheet1.xml'/>"
$wbrels:=$wbrels+"<Relationship Id='rId2' Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles' Target='styles.xml'/>"
$wbrels:=$wbrels+"</Relationships>"

// -----------------------------------------------------------------------------
// 4) styles.xml
//    Style indexes (cellXfs):
//      0 default | 1 header | 2 text | 3 integer
//      4 money(no fill) | 5..9 money heat-map tiers (strong->weak)
//      10 total label | 11 total money | 12 title
// -----------------------------------------------------------------------------
$styles:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$styles:=$styles+"<styleSheet xmlns='http://schemas.openxmlformats.org/spreadsheetml/2006/main'>"
$styles:=$styles+"<numFmts count='2'>"
$styles:=$styles+"<numFmt numFmtId='164' formatCode='#,##0.00'/>"
$styles:=$styles+"<numFmt numFmtId='165' formatCode='#,##0'/>"
$styles:=$styles+"</numFmts>"
$styles:=$styles+"<fonts count='4'>"
$styles:=$styles+"<font><sz val='11'/><name val='Calibri'/></font>"
$styles:=$styles+"<font><b/><sz val='11'/><color rgb='FFFFFFFF'/><name val='Calibri'/></font>"
$styles:=$styles+"<font><b/><sz val='11'/><name val='Calibri'/></font>"
$styles:=$styles+"<font><b/><sz val='14'/><color rgb='FF1B4F72'/><name val='Calibri'/></font>"
$styles:=$styles+"</fonts>"
$styles:=$styles+"<fills count='9'>"
$styles:=$styles+"<fill><patternFill patternType='none'/></fill>"
$styles:=$styles+"<fill><patternFill patternType='gray125'/></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FF1B4F72'/></patternFill></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FF1E8449'/></patternFill></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FF58D68D'/></patternFill></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FFF7DC6F'/></patternFill></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FFF0B27A'/></patternFill></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FFEC7063'/></patternFill></fill>"
$styles:=$styles+"<fill><patternFill patternType='solid'><fgColor rgb='FFD9E2F3'/></patternFill></fill>"
$styles:=$styles+"</fills>"
$styles:=$styles+"<borders count='2'>"
$styles:=$styles+"<border><left/><right/><top/><bottom/><diagonal/></border>"
$styles:=$styles+"<border><left style='thin'><color rgb='FFBFBFBF'/></left><right style='thin'><color rgb='FFBFBFBF'/></right><top style='thin'><color rgb='FFBFBFBF'/></top><bottom style='thin'><color rgb='FFBFBFBF'/></bottom><diagonal/></border>"
$styles:=$styles+"</borders>"
$styles:=$styles+"<cellStyleXfs count='1'><xf numFmtId='0' fontId='0' fillId='0' borderId='0'/></cellStyleXfs>"
$styles:=$styles+"<cellXfs count='13'>"
$styles:=$styles+"<xf numFmtId='0' fontId='0' fillId='0' borderId='0' xfId='0'/>"
$styles:=$styles+"<xf numFmtId='0' fontId='1' fillId='2' borderId='1' xfId='0' applyFont='1' applyFill='1' applyBorder='1' applyAlignment='1'><alignment horizontal='center' vertical='center' wrapText='1'/></xf>"
$styles:=$styles+"<xf numFmtId='0' fontId='0' fillId='0' borderId='1' xfId='0' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='165' fontId='0' fillId='0' borderId='1' xfId='0' applyNumberFormat='1' applyBorder='1' applyAlignment='1'><alignment horizontal='right'/></xf>"
$styles:=$styles+"<xf numFmtId='164' fontId='0' fillId='0' borderId='1' xfId='0' applyNumberFormat='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='164' fontId='0' fillId='3' borderId='1' xfId='0' applyNumberFormat='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='164' fontId='0' fillId='4' borderId='1' xfId='0' applyNumberFormat='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='164' fontId='0' fillId='5' borderId='1' xfId='0' applyNumberFormat='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='164' fontId='0' fillId='6' borderId='1' xfId='0' applyNumberFormat='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='164' fontId='0' fillId='7' borderId='1' xfId='0' applyNumberFormat='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='0' fontId='2' fillId='8' borderId='1' xfId='0' applyFont='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='164' fontId='2' fillId='8' borderId='1' xfId='0' applyNumberFormat='1' applyFont='1' applyFill='1' applyBorder='1'/>"
$styles:=$styles+"<xf numFmtId='0' fontId='3' fillId='0' borderId='0' xfId='0' applyFont='1' applyAlignment='1'><alignment horizontal='left' vertical='center'/></xf>"
$styles:=$styles+"</cellXfs>"
$styles:=$styles+"<cellStyles count='1'><cellStyle name='Normal' xfId='0' builtinId='0'/></cellStyles>"
$styles:=$styles+"</styleSheet>"

// -----------------------------------------------------------------------------
// 5) worksheets/sheet1.xml
// -----------------------------------------------------------------------------
$sheet:="<?xml version='1.0' encoding='UTF-8' standalone='yes'?>"
$sheet:=$sheet+"<worksheet xmlns='http://schemas.openxmlformats.org/spreadsheetml/2006/main'>"
$sheet:=$sheet+"<dimension ref='A1:"+$lastCol+String($lastRow)+"'/>"
$sheet:=$sheet+"<sheetViews><sheetView workbookViewId='0'><pane ySplit='2' topLeftCell='A3' activePane='bottomLeft' state='frozen'/></sheetView></sheetViews>"
$sheet:=$sheet+"<sheetFormatPr defaultRowHeight='15'/>"
$sheet:=$sheet+"<cols>"
$sheet:=$sheet+"<col min='1' max='1' width='5' customWidth='1'/>"
$sheet:=$sheet+"<col min='2' max='2' width='30' customWidth='1'/>"
$sheet:=$sheet+"<col min='3' max='4' width='16' customWidth='1'/>"
$sheet:=$sheet+"<col min='5' max='5' width='10' customWidth='1'/>"
$sheet:=$sheet+"<col min='6' max='"+String($totalCols)+"' width='14' customWidth='1'/>"
$sheet:=$sheet+"</cols>"
$sheet:=$sheet+"<sheetData>"

// --- Title row (row 1) ---
$sheet:=$sheet+"<row r='1' ht='22' customHeight='1'>"
$sheet:=$sheet+"<c r='A1' s='12' t='inlineStr'><is><t>Best Customers - Annual Revenue</t></is></c>"
$sheet:=$sheet+"</row>"

// --- Header row (row 2) ---
$sheet:=$sheet+"<row r='2' ht='28' customHeight='1'>"
$sheet:=$sheet+"<c r='"+$L[1]+"2' s='1' t='inlineStr'><is><t>#</t></is></c>"
$sheet:=$sheet+"<c r='"+$L[2]+"2' s='1' t='inlineStr'><is><t>Customer</t></is></c>"
$sheet:=$sheet+"<c r='"+$L[3]+"2' s='1' t='inlineStr'><is><t>City</t></is></c>"
$sheet:=$sheet+"<c r='"+$L[4]+"2' s='1' t='inlineStr'><is><t>Country</t></is></c>"
$sheet:=$sheet+"<c r='"+$L[5]+"2' s='1' t='inlineStr'><is><t>Invoices</t></is></c>"
$ci:=5
For each ($y; $years)
	$ci:=$ci+1
	$sheet:=$sheet+"<c r='"+$L[$ci]+"2' s='1' t='inlineStr'><is><t>"+String($y)+"</t></is></c>"
End for each
$sheet:=$sheet+"<c r='"+$lastCol+"2' s='1' t='inlineStr'><is><t>Grand Total</t></is></c>"
$sheet:=$sheet+"</row>"

// --- Data rows ---
$rank:=0
$yearTotals:={}  // running totals per year for the TOTAL row
For each ($y; $years)
	$yearTotals[String($y)]:=0
End for each

For each ($s; $stats)
	$rank:=$rank+1
	$row:=2+$rank

	$sheet:=$sheet+"<row r='"+String($row)+"'>"
	$sheet:=$sheet+"<c r='"+$L[1]+String($row)+"' s='3'><v>"+String($rank)+"</v></c>"
	$sheet:=$sheet+"<c r='"+$L[2]+String($row)+"' s='2' t='inlineStr'><is><t>"+$s.name+"</t></is></c>"
	$sheet:=$sheet+"<c r='"+$L[3]+String($row)+"' s='2' t='inlineStr'><is><t>"+$s.city+"</t></is></c>"
	$sheet:=$sheet+"<c r='"+$L[4]+String($row)+"' s='2' t='inlineStr'><is><t>"+$s.country+"</t></is></c>"
	$sheet:=$sheet+"<c r='"+$L[5]+String($row)+"' s='3'><v>"+String($s.count)+"</v></c>"

	$ci:=5
	For each ($y; $years)
		$ci:=$ci+1
		$v:=Num($s.years[String($y)])
		$v:=Round($v; 2)
		If ($v=0)
			$sheet:=$sheet+"<c r='"+$L[$ci]+String($row)+"' s='4'/>"
		Else
			// heat-map tier from the value's ratio to the strongest annual figure
			If ($maxYear<=0)
				$sIdx:=4
			Else
				$r:=$v/$maxYear
				Case of
					: ($r>=0.75)
						$sIdx:=5
					: ($r>=0.50)
						$sIdx:=6
					: ($r>=0.25)
						$sIdx:=7
					: ($r>=0.10)
						$sIdx:=8
					Else
						$sIdx:=9
				End case
			End if
			// build a locale-independent numeric literal (period decimal, 2 dp)
			$cents:=Round($v*100; 0)
			$whole:=Int($cents/100)
			$rem:=$cents-($whole*100)
			$remStr:=String($rem)
			If ($rem<10)
				$remStr:="0"+$remStr
			End if
			$lit:=String($whole)+"."+$remStr
			$sheet:=$sheet+"<c r='"+$L[$ci]+String($row)+"' s='"+String($sIdx)+"'><v>"+$lit+"</v></c>"
			$yearTotals[String($y)]:=$yearTotals[String($y)]+$v
		End if
	End for each

	// Grand total cell (coloured against the strongest customer)
	$v:=Round($s.grand; 2)
	If ($maxGrand<=0)
		$sIdx:=4
	Else
		$r:=$v/$maxGrand
		Case of
			: ($r>=0.75)
				$sIdx:=5
			: ($r>=0.50)
				$sIdx:=6
			: ($r>=0.25)
				$sIdx:=7
			: ($r>=0.10)
				$sIdx:=8
			Else
				$sIdx:=9
		End case
	End if
	$cents:=Round($v*100; 0)
	$whole:=Int($cents/100)
	$rem:=$cents-($whole*100)
	$remStr:=String($rem)
	If ($rem<10)
		$remStr:="0"+$remStr
	End if
	$lit:=String($whole)+"."+$remStr
	$sheet:=$sheet+"<c r='"+$lastCol+String($row)+"' s='"+String($sIdx)+"'><v>"+$lit+"</v></c>"

	$sheet:=$sheet+"</row>"
End for each

// --- TOTAL row ---
$sheet:=$sheet+"<row r='"+String($tr)+"'>"
$sheet:=$sheet+"<c r='"+$L[1]+String($tr)+"' s='10'/>"
$sheet:=$sheet+"<c r='"+$L[2]+String($tr)+"' s='10' t='inlineStr'><is><t>TOTAL</t></is></c>"
$sheet:=$sheet+"<c r='"+$L[3]+String($tr)+"' s='10'/>"
$sheet:=$sheet+"<c r='"+$L[4]+String($tr)+"' s='10'/>"
$sheet:=$sheet+"<c r='"+$L[5]+String($tr)+"' s='10'/>"
$maxGrand:=0  // reuse as running grand-of-grands
$ci:=5
For each ($y; $years)
	$ci:=$ci+1
	$v:=Round($yearTotals[String($y)]; 2)
	$maxGrand:=$maxGrand+$v
	$cents:=Round($v*100; 0)
	$whole:=Int($cents/100)
	$rem:=$cents-($whole*100)
	$remStr:=String($rem)
	If ($rem<10)
		$remStr:="0"+$remStr
	End if
	$lit:=String($whole)+"."+$remStr
	$sheet:=$sheet+"<c r='"+$L[$ci]+String($tr)+"' s='11'><v>"+$lit+"</v></c>"
End for each
$v:=Round($maxGrand; 2)
$cents:=Round($v*100; 0)
$whole:=Int($cents/100)
$rem:=$cents-($whole*100)
$remStr:=String($rem)
If ($rem<10)
	$remStr:="0"+$remStr
End if
$lit:=String($whole)+"."+$remStr
$sheet:=$sheet+"<c r='"+$lastCol+String($tr)+"' s='11'><v>"+$lit+"</v></c>"
$sheet:=$sheet+"</row>"

$sheet:=$sheet+"</sheetData>"
$sheet:=$sheet+"<mergeCells count='1'><mergeCell ref='A1:"+$lastCol+"1'/></mergeCells>"
$sheet:=$sheet+"</worksheet>"

// -----------------------------------------------------------------------------
// 6) Lay the parts out in a temporary folder
// -----------------------------------------------------------------------------
$build:=Folder(Temporary folder+"xlsx_build_"+String(Milliseconds); fk platform path)
If ($build.exists)
	$build.delete(Delete with contents)
End if
$build.create()
$build.folder("_rels").create()
$build.folder("docProps").create()
$build.folder("xl").create()
$build.folder("xl/_rels").create()
$build.folder("xl/worksheets").create()

$build.file("[Content_Types].xml").setText($ct; "utf-8-no-bom")
$build.file("_rels/.rels").setText($rels; "utf-8-no-bom")
$build.file("docProps/core.xml").setText($core; "utf-8-no-bom")
$build.file("docProps/app.xml").setText($app; "utf-8-no-bom")
$build.file("xl/workbook.xml").setText($wb; "utf-8-no-bom")
$build.file("xl/_rels/workbook.xml.rels").setText($wbrels; "utf-8-no-bom")
$build.file("xl/styles.xml").setText($styles; "utf-8-no-bom")
$build.file("xl/worksheets/sheet1.xml").setText($sheet; "utf-8-no-bom")

// -----------------------------------------------------------------------------
// 7) ZIP the parts into the final .xlsx (destination = path inside the archive)
// -----------------------------------------------------------------------------
// NB: "destination" is a directory PREFIX that 4D concatenates in front of the
// source file's own name. So it must be the containing folder (trailing "/"),
// or an empty string for parts that live at the archive root.
$zip:={}
$zip.files:=[]
$zip.files.push({source: $build.file("[Content_Types].xml"); destination: ""})
$zip.files.push({source: $build.file("_rels/.rels"); destination: "_rels/"})
$zip.files.push({source: $build.file("docProps/core.xml"); destination: "docProps/"})
$zip.files.push({source: $build.file("docProps/app.xml"); destination: "docProps/"})
$zip.files.push({source: $build.file("xl/workbook.xml"); destination: "xl/"})
$zip.files.push({source: $build.file("xl/_rels/workbook.xml.rels"); destination: "xl/_rels/"})
$zip.files.push({source: $build.file("xl/styles.xml"); destination: "xl/"})
$zip.files.push({source: $build.file("xl/worksheets/sheet1.xml"); destination: "xl/worksheets/"})

$xlsx:=File(Get 4D folder(Desktop folder)+"BestCustomers.xlsx"; fk platform path)
If ($xlsx.exists)
	$xlsx.delete()
End if

$status:=ZIP Create archive($zip; $xlsx)

// Tidy up the temporary build folder
$build.delete(Delete with contents)

If ($status.success)
	ALERT("Spreadsheet created:\n"+$xlsx.platformPath+"\n\nGenerated on "+$ts)
	OPEN URL($xlsx.platformPath)
Else
	ALERT("Failed to create the archive.")
End if
