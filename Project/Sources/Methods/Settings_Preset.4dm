//%attributes = {"folder":"OldCode","lang":"en"}
var $settings; $sel : Object
var $pict : Picture

$settings:=$1

$settings.Modes:=New object
$settings.Modes.multiProcess:=False
$settings.Modes.multiRecords:=False
$settings.Display:=New object
$settings.Display.enterInList:=True
$settings.Display.HLinesVisible:=False
$settings.Display.VLinesVisible:=False
$settings.Display.AlternateColor:=True
$settings.Display.AlternateColorRGB:=0x00F3F5FA
$settings.Company:=New object
$settings.Company.Name:="My Company"
$settings.Company.Logo:=$pict
$settings.Products:=New object
$settings.Products.defaultTaxRate:=0.2
$settings.Clients:=New object
$settings.Clients.defaultCountry:="USA"
$settings.Clients.defaultDiscount:=0
$settings.Invoices:=New object
$sel:=ds.INVOICES.query("ProForma = :1 & Credit_Note = :2"; False; False)
If ($sel.length<1)
	$n:="INV00000"
Else 
	$n:=String($sel.max("Invoice_Number"); "00000")
End if 
$settings.Invoices.lastInvoiceNumber:=$n
$sel:=ds.INVOICES.query("ProForma = :1 & Credit_Note = :2"; True; False)
If ($sel.length<1)
	$n:="PRF00000"
Else 
	$n:=String($sel.max("Invoice_Number"); "00000")
End if 
$settings.Invoices.lastProFormaNumber:=$n
$sel:=ds.INVOICES.query("ProForma = :1 & Credit_Note = :2"; False; True)
If ($sel.length<1)
	$n:="QOT00000"
Else 
	$n:=String($sel.max("Invoice_Number"); "00000")
End if 
$settings.Invoices.lastQuoteNumber:=$n