//%attributes = {"lang":"en"}
// Create ~5000 invoices from 01/01/2020 to 31/12/2025
// Each invoice has 1 to 15 lines with random products and quantities

var $clients : cs.CLIENTSSelection
var $products : cs.PRODUCTSSelection
var $nbClients : Integer
var $nbProducts : Integer

$clients:=ds.CLIENTS.all()
$products:=ds.PRODUCTS.all()
$nbClients:=$clients.length
$nbProducts:=$products.length

If ($nbClients=0) | ($nbProducts=0)
	ALERT("No clients or products found. Aborting.")
	return
End if 

var $startDate : Date
var $endDate : Date
var $totalDays : Integer

$startDate:=!2020-01-01!
$endDate:=!2025-12-31!
$totalDays:=$endDate-$startDate

var $i : Integer
var $nbInvoices : Integer
$nbInvoices:=5000

var $payMethods : Collection
$payMethods:=New collection("Credit Card"; "Bank Transfer"; "Check"; "Cash"; "PayPal")

SET WINDOW TITLE("Creating invoices... 0/"+String($nbInvoices))

For ($i; 1; $nbInvoices)
	
	var $invoice : cs.INVOICESEntity
	$invoice:=ds.INVOICES.new()
	
	// Random date between start and end
	var $randomDay : Integer
	$randomDay:=Abs(Random) % ($totalDays+1)
	$invoice.Creation_Date:=$startDate+$randomDay
	
	// Random client
	var $clientIndex : Integer
	$clientIndex:=(Abs(Random) % $nbClients)
	$invoice.Client_ID:=$clients[$clientIndex].ID
	
	// Invoice number: INV-YYYY-NNNNN
	$invoice.Invoice_Number:="INV-"+String(Year of($invoice.Creation_Date))+"-"+String($i; "00000")
	
	// Payment info
	$invoice.ProForma:=False
	$invoice.Credit_Note:=False
	$invoice.Proforma_Number:=""
	$invoice.Payment_Delay:=30
	$invoice.Payment_Method:=$payMethods[Abs(Random) % 5]
	$invoice.Payment_Reference:=""
	
	// Paid status: ~80% paid
	var $isPaid : Boolean
	$isPaid:=((Abs(Random) % 100)<80)
	$invoice.Paid:=$isPaid
	If ($isPaid)
		var $payDelay : Integer
		$payDelay:=1+(Abs(Random) % 60)
		$invoice.Payment_Date:=$invoice.Creation_Date+$payDelay
		$invoice.Payment_Reference:="PAY-"+String($i; "00000")
	End if 
	
	// Save invoice first to get its ID
	$invoice.save()
	
	// Create invoice lines
	var $nbLines : Integer
	$nbLines:=1+(Abs(Random) % 15)
	
	// Limit lines to available products
	If ($nbLines>$nbProducts)
		$nbLines:=$nbProducts
	End if 
	
	var $usedProducts : Collection
	$usedProducts:=New collection
	
	var $subtotalBT : Real
	var $totalTax : Real
	$subtotalBT:=0
	$totalTax:=0
	
	var $j : Integer
	For ($j; 1; $nbLines)
		
		// Find a product not yet used in this invoice
		var $prodIndex : Integer
		$prodIndex:=Abs(Random) % $nbProducts
		While ($usedProducts.indexOf($prodIndex)>=0)
			$prodIndex:=($prodIndex+1) % $nbProducts
		End while 
		$usedProducts.push($prodIndex)
		
		var $product : cs.PRODUCTSEntity
		$product:=$products[$prodIndex]
		
		var $line : cs.INVOICE_LINESEntity
		$line:=ds.INVOICE_LINES.new()
		
		$line.Invoice_ID:=$invoice.ID
		$line.Product_ID:=$product.ID
		$line._ProductReference:=$product.Reference
		$line._ProductName:=$product.Name
		$line.Line_Number:=$j
		
		// Random quantity 1 to 50
		var $qty : Integer
		$qty:=1+(Abs(Random) % 50)
		$line.Quantity:=$qty
		$line.Unit_Price:=$product.Sale_Price
		$line.Tax_Rate:=$product.Tax_Rate
		
		// Random discount 0%, 5%, 10%, 15%, 20%
		var $disc : Real
		$disc:=(Abs(Random) % 5)*5
		$line.Discount_Rate:=$disc
		
		// Compute line totals
		var $lineTotal : Real
		$lineTotal:=Round($qty*$product.Sale_Price*(1-($disc/100)); 2)
		$line.Total:=$lineTotal
		$line.Total_Tax:=Round($lineTotal*($product.Tax_Rate/100); 2)
		
		$subtotalBT:=$subtotalBT+$lineTotal
		$totalTax:=$totalTax+$line.Total_Tax
		
		$line.save()
		
	End for 
	
	// Update invoice totals
	$invoice.Subtotal_BT:=Round($subtotalBT; 2)
	$invoice.Tax:=Round($totalTax; 2)
	$invoice.Total:=Round($subtotalBT+$totalTax; 2)
	$invoice.save()
	
	If (($i % 100)=0)
		SET WINDOW TITLE("Creating invoices... "+String($i)+"/"+String($nbInvoices))
	End if 
	
End for 

SET WINDOW TITLE("")
ALERT(String($nbInvoices)+" invoices created successfully.")
