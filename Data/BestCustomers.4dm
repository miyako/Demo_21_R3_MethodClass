//%attributes = {"lang":"en"}
// Generate an Excel file on the Desktop listing best customers
// with annual revenue broken down in columns

var $invoices : cs.INVOICESSelection
$invoices:=ds.INVOICES.all()

If ($invoices.length=0)
    ALERT("No invoices found.")
    return
End if 

// Determine the range of years
var $years : Collection
$years:=New collection

var $inv : cs.INVOICESEntity
For each ($inv; $invoices)
    If ($inv.Creation_Date#!00-00-00!)
        var $y : Integer
        $y:=Year of($inv.Creation_Date)
        If ($years.indexOf($y)=-1)
            $years.push($y)
        End if 
    End if 
End for each 

$years:=$years.orderBy(ck ascending)

// Build stats per client
var $stats : Collection
$stats:=New collection

var $clients : cs.CLIENTSSelection
$clients:=ds.CLIENTS.all()

var $client : cs.CLIENTSEntity
For each ($client; $clients)
    
    var $clientInvoices : cs.INVOICESSelection
    $clientInvoices:=ds.INVOICES.query("Client_ID = :1"; $client.ID)
    
    If ($clientInvoices.length>0)
        var $stat : Object
        $stat:=New object
        $stat.clientName:=$client.Name
        $stat.city:=$client.City
        $stat.country:=$client.Country
        $stat.nbInvoices:=$clientInvoices.length
        $stat.grandTotal:=0
        
        // Revenue per year
        var $yearTotals : Object
        $yearTotals:=New object
        
        var $yr : Variant
        For each ($yr; $years)
            $yearTotals[String($yr)]:=0
        End for each 
        
        var $invoice : cs.INVOICESEntity
        For each ($invoice; $clientInvoices)
            If ($invoice.Creation_Date#!00-00-00!)
                var $invoiceYear : Integer
                $invoiceYear:=Year of($invoice.Creation_Date)
                $yearTotals[String($invoiceYear)]:=$yearTotals[String($invoiceYear)]+$invoice.Total
                $stat.grandTotal:=$stat.grandTotal+$invoice.Total
            End if 
        End for each 
        
        $stat.yearTotals:=$yearTotals
        $stat.grandTotal:=Round($stat.grandTotal; 2)
        $stats.push($stat)
    End if 
    
End for each 

// Sort by grand total descending (best customers first)
$stats:=$stats.orderBy("grandTotal desc")

// Build HTML table (Excel-compatible format)
var $html : Text
$html:="<html xmlns:o=\"urn:schemas-microsoft-com:office:office\" "
$html:=$html+"xmlns:x=\"urn:schemas-microsoft-com:office:excel\" "
$html:=$html+"xmlns=\"http://www.w3.org/TR/REC-html40\">"
$html:=$html+"<head><meta charset=\"utf-8\">"
$html:=$html+"<style>"
$html:=$html+"body { background-color: #F8F9FA; margin: 20px; }"
$html:=$html+"table { border-collapse: collapse; font-family: Calibri, sans-serif; font-size: 11pt; width: 100%; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }"
$html:=$html+"th { background-color: #1B4F72; color: white; padding: 10px 14px; border: 1px solid #154360; text-align: center; font-weight: bold; letter-spacing: 0.3px; }"
$html:=$html+"td { padding: 8px 14px; border: 1px solid #D5D8DC; color: #2C3E50; }"
$html:=$html+"td.num { text-align: right; mso-number-format:'#\\,##0\\.00'; color: #1A5276; font-weight: 500; }"
$html:=$html+"td.qty { text-align: right; mso-number-format:'#\\,##0'; }"
$html:=$html+"tr:nth-child(even) { background-color: #EBF5FB; }"
$html:=$html+"tr:nth-child(odd) { background-color: #FFFFFF; }"
$html:=$html+"tr:hover { background-color: #D4E6F1; }"
$html:=$html+"tr:first-child td { border-top: 2px solid #1B4F72; }"
$html:=$html+"h1 { font-family: Calibri, sans-serif; color: #1B4F72; margin-bottom: 15px; border-bottom: 3px solid #2E86C1; padding-bottom: 10px; display: inline-block; }"
$html:=$html+"</style></head><body>"
$html:=$html+"<h1>Best Customers - Annual Revenue</h1>"
$html:=$html+"<table>"
$html:=$html+"<tr>"
$html:=$html+"<th>#</th>"
$html:=$html+"<th>Customer</th>"
$html:=$html+"<th>City</th>"
$html:=$html+"<th>Country</th>"
$html:=$html+"<th>Invoices</th>"

// Year columns
For each ($yr; $years)
    $html:=$html+"<th>"+String($yr)+"</th>"
End for each 

$html:=$html+"<th>Grand Total</th>"
$html:=$html+"</tr>"

var $rank : Integer
$rank:=0
var $gTotal : Real
$gTotal:=0

// Year grand totals
var $yearGrandTotals : Object
$yearGrandTotals:=New object
For each ($yr; $years)
    $yearGrandTotals[String($yr)]:=0
End for each 

var $s : Object
For each ($s; $stats)
    $rank:=$rank+1
    $html:=$html+"<tr>"
    $html:=$html+"<td class=\"qty\">"+String($rank)+"</td>"
    $html:=$html+"<td>"+$s.clientName+"</td>"
    $html:=$html+"<td>"+$s.city+"</td>"
    $html:=$html+"<td>"+$s.country+"</td>"
    $html:=$html+"<td class=\"qty\">"+String($s.nbInvoices)+"</td>"
    
    var $prevVal : Real
    $prevVal:=-1
    For each ($yr; $years)
        var $val : Real
        $val:=Round($s.yearTotals[String($yr)]; 2)
        If ($val=0)
            $html:=$html+"<td class=\"num\" style=\"background-color:#F2F3F4; color:#AAB7B8;\">-</td>"
        Else 
            var $cellBg : Text
            If ($prevVal<0)
                // First year with data - neutral
                $cellBg:="background-color:#EBF5FB;"
            Else 
                If ($prevVal=0)
                    // New customer that year - light green
                    $cellBg:="background-color:#D5F5E3; color:#1E8449;"
                Else 
                    var $change : Real
                    $change:=(($val-$prevVal)/$prevVal)*100
                    If ($change>=20)
                        // Strong growth
                        $cellBg:="background-color:#82E0AA; color:#145A32; font-weight:bold;"
                    Else 
                        If ($change>0)
                            // Moderate growth
                            $cellBg:="background-color:#D5F5E3; color:#1E8449;"
                        Else 
                            If ($change>=-20)
                                // Moderate decline
                                $cellBg:="background-color:#FADBD8; color:#922B21;"
                            Else 
                                // Strong decline
                                $cellBg:="background-color:#F1948A; color:#641E16; font-weight:bold;"
                            End if 
                        End if 
                    End if 
                End if 
            End if 
            $html:=$html+"<td class=\"num\" style=\""+$cellBg+"\">"+String($val; "### ### ##0.00")+"</td>"
        End if 
        $prevVal:=$val
        $yearGrandTotals[String($yr)]:=$yearGrandTotals[String($yr)]+$val
    End for each 
    
    $html:=$html+"<td class=\"num\">"+String($s.grandTotal; "### ### ##0.00")+"</td>"
    $html:=$html+"</tr>"
    $gTotal:=$gTotal+$s.grandTotal
End for each 

// Total row
$html:=$html+"<tr style=\"font-weight:bold; background-color:#1B4F72; color:white;\">"
$html:=$html+"<td></td><td style=\"color:white;\">TOTAL</td><td></td><td></td><td></td>"
For each ($yr; $years)
    $html:=$html+"<td class=\"num\" style=\"color:white;\">"+String(Round($yearGrandTotals[String($yr)]; 2); "### ### ##0.00")+"</td>"
End for each 
$html:=$html+"<td class=\"num\" style=\"color:white;\">"+String(Round($gTotal; 2); "### ### ##0.00")+"</td>"
$html:=$html+"</tr></table>"
$html:=$html+"<p style=\"font-family:Calibri; color:#666;\">Generated on "+String(Current date; ISO date)+"</p>"
$html:=$html+"</body></html>"

// Save Excel file on the Desktop
var $desktopPath : Text
$desktopPath:=Get 4D folder(Desktop folder)

var $file : 4D.File
$file:=File($desktopPath+"BestCustomers.xls"; fk platform path)
$file.setText($html; "utf-8")

ALERT("File saved:\n"+$file.platformPath)
OPEN URL($file.platformPath)
