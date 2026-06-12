//%attributes = {"lang":"en"}
// Generate an Excel file on the Desktop listing invoiced products
// sorted by margin descending (highest margin first)

var $lines : cs.INVOICE_LINESSelection
$lines:=ds.INVOICE_LINES.all()

If ($lines.length=0)
    ALERT("No invoice lines found.")
    return
End if 

// Build stats per product
var $stats : Collection
$stats:=New collection

var $products : cs.PRODUCTSSelection
$products:=ds.PRODUCTS.all()

var $product : cs.PRODUCTSEntity
For each ($product; $products)
    
    var $productLines : cs.INVOICE_LINESSelection
    $productLines:=ds.INVOICE_LINES.query("Product_ID = :1"; $product.ID)
    
    If ($productLines.length>0)
        var $stat : Object
        $stat:=New object
        $stat.reference:=$product.Reference
        $stat.name:=$product.Name
        $stat.salePrice:=$product.Sale_Price
        $stat.purchasePrice:=$product.Purchase_Price
        $stat.nbInvoices:=$productLines.length
        $stat.totalQty:=$productLines.sum("Quantity")
        $stat.totalHT:=Round($productLines.sum("Total"); 2)
        $stat.costTotal:=Round($stat.purchasePrice*$stat.totalQty; 2)
        $stat.margin:=Round($stat.totalHT-$stat.costTotal; 2)
        If ($stat.totalHT#0)
            $stat.marginPct:=Round(($stat.margin/$stat.totalHT)*100; 1)
        Else 
            $stat.marginPct:=0
        End if 
        $stats.push($stat)
    End if 
    
End for each 

// Sort by margin rate descending (highest margin % first)
$stats:=$stats.orderBy("marginPct desc")

// Keep only the top 50
If ($stats.length>50)
    $stats:=$stats.slice(0; 50)
End if 

// Build HTML table (Excel-compatible format)
var $html : Text
$html:="<html xmlns:o=\"urn:schemas-microsoft-com:office:office\" "
$html:=$html+"xmlns:x=\"urn:schemas-microsoft-com:office:excel\" "
$html:=$html+"xmlns=\"http://www.w3.org/TR/REC-html40\">"
$html:=$html+"<head><meta charset=\"utf-8\">"
$html:=$html+"<style>"
$html:=$html+"table { border-collapse: collapse; font-family: Calibri, sans-serif; font-size: 11pt; }"
$html:=$html+"th { background-color: #2E75B6; color: white; padding: 8px 12px; border: 1px solid #1F5F8B; text-align: center; }"
$html:=$html+"td { padding: 6px 12px; border: 1px solid #D6DCE4; }"
$html:=$html+"td.num { text-align: right; mso-number-format:'#\\,##0\\.00'; }"
$html:=$html+"td.pct { text-align: right; mso-number-format:'0\\.0%'; }"
$html:=$html+"td.qty { text-align: right; mso-number-format:'#\\,##0'; }"
$html:=$html+"tr:nth-child(even) { background-color: #F2F7FB; }"
$html:=$html+"h1 { font-family: Calibri, sans-serif; color: #2E75B6; }"
$html:=$html+"</style></head><body>"
$html:=$html+"<h1>Invoiced Products - Ranked by Margin</h1>"
$html:=$html+"<table>"
$html:=$html+"<tr>"
$html:=$html+"<th>#</th>"
$html:=$html+"<th>Reference</th>"
$html:=$html+"<th>Product</th>"
$html:=$html+"<th>Sale Price</th>"
$html:=$html+"<th>Purchase Price</th>"
$html:=$html+"<th>Nb Invoices</th>"
$html:=$html+"<th>Qty Sold</th>"
$html:=$html+"<th>Revenue HT</th>"
$html:=$html+"<th>Total Cost</th>"
$html:=$html+"<th>Margin</th>"
$html:=$html+"<th>Margin %</th>"
$html:=$html+"</tr>"

var $rank : Integer
$rank:=0
var $gHT; $gCost; $gMargin : Real
$gHT:=0
$gCost:=0
$gMargin:=0

var $s : Object
For each ($s; $stats)
    $rank:=$rank+1
    $html:=$html+"<tr>"
    $html:=$html+"<td class=\"qty\">"+String($rank)+"</td>"
    $html:=$html+"<td>"+$s.reference+"</td>"
    $html:=$html+"<td>"+$s.name+"</td>"
    $html:=$html+"<td class=\"num\">"+String($s.salePrice; "### ##0.00")+"</td>"
    $html:=$html+"<td class=\"num\">"+String($s.purchasePrice; "### ##0.00")+"</td>"
    $html:=$html+"<td class=\"qty\">"+String($s.nbInvoices)+"</td>"
    $html:=$html+"<td class=\"qty\">"+String($s.totalQty; "### ##0")+"</td>"
    $html:=$html+"<td class=\"num\">"+String($s.totalHT; "### ### ##0.00")+"</td>"
    $html:=$html+"<td class=\"num\">"+String($s.costTotal; "### ### ##0.00")+"</td>"
    $html:=$html+"<td class=\"num\">"+String($s.margin; "### ### ##0.00")+"</td>"
    $html:=$html+"<td class=\"pct\">"+String($s.marginPct; "##0.0")+"%</td>"
    $html:=$html+"</tr>"
    $gHT:=$gHT+$s.totalHT
    $gCost:=$gCost+$s.costTotal
    $gMargin:=$gMargin+$s.margin
End for each 

// Total row
var $gMarginPct : Real
If ($gHT#0)
    $gMarginPct:=Round(($gMargin/$gHT)*100; 1)
Else 
    $gMarginPct:=0
End if 

$html:=$html+"<tr style=\"font-weight:bold; background-color:#D9E2F3;\">"
$html:=$html+"<td></td><td></td><td>TOTAL</td><td></td><td></td><td></td><td></td>"
$html:=$html+"<td class=\"num\">"+String($gHT; "### ### ##0.00")+"</td>"
$html:=$html+"<td class=\"num\">"+String($gCost; "### ### ##0.00")+"</td>"
$html:=$html+"<td class=\"num\">"+String($gMargin; "### ### ##0.00")+"</td>"
$html:=$html+"<td class=\"pct\">"+String($gMarginPct; "##0.0")+"%</td>"
$html:=$html+"</tr></table>"
$html:=$html+"<p style=\"font-family:Calibri; color:#666;\">Generated on "+String(Current date; ISO date)+"</p>"
$html:=$html+"</body></html>"

// Save Excel file on the Desktop
var $desktopPath : Text
$desktopPath:=Get 4D folder(Desktop folder)

var $file : 4D.File
$file:=File($desktopPath+"ProductMarginStats.xls"; fk platform path)
$file.setText($html; "utf-8")

ALERT("File saved:\n"+$file.platformPath)
OPEN URL($file.platformPath)
