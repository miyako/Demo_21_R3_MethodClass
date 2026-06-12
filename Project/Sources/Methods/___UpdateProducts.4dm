//%attributes = {"lang":"en"}
// Update PRODUCTS: set Tax_Rate to 20 and Purchase_Price between 25% and 95% of Sale_Price

var $selection : cs.PRODUCTSSelection
var $product : cs.PRODUCTSEntity
var $ratio : Real

$selection:=ds.PRODUCTS.all()

For each ($product; $selection)
	$product.Tax_Rate:=20
	$ratio:=(25+(Random % 71))/100  // between 0.25 and 0.95
	$product.Purchase_Price:=Round($product.Sale_Price*$ratio; 2)
	$product.save()
End for each 

ALERT(String($selection.length)+" products updated.")
