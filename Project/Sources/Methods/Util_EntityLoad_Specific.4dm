//%attributes = {"folder":"OldCode","lang":"en"}
//This method handles calculations specific to some DataClasses, like related DataClasses 
//For instance, modifications on INVOICE_LINES implies an update of INVOICES
//
$isNew:=$1  //True for a new Record

Case of   //Special cases depending on the Table
	: (Form.dataClassName="INVOICES")
		If (Not(Form.editEntity.Lines_Fm_Invoices=Null))
			Form.editEntity.Total:=Form.editEntity.Lines_Fm_Invoices.sum("Total")
			Form.editEntity.Tax:=Form.editEntity.Lines_Fm_Invoices.sum("Total_Tax")
			OBJECT Get pointer(Object named; "_TOTAL_Quantity")->:=Form.editEntity.Lines_Fm_Invoices.sum("Quantity")
			OBJECT Get pointer(Object named; "_TOTAL_TEXT_Quantity")->:=Localized string("Total")
			OBJECT Get pointer(Object named; "_TOTAL_Total")->:=Form.editEntity.Total
			OBJECT Get pointer(Object named; "_TOTAL_TEXT_Total")->:=Localized string("Total")
			
		End if 
		If ($isNew)
			
		End if 
		
	: (Form.dataClassName="CLIENTS")
		Form.queryClient:=""
		If ($isNew)
			Form.editEntity.Country:=Form.settings.Clients.defaultCountry
			Form.editEntity.Discount_Rate:=Form.settings.Clients.defaultDiscount
		Else 
			Form.editEntity.Total_Sales:=Form.editEntity.Invoice_List.sum("Total")
		End if 
		
	: (Form.dataClassName="PRODUCTS")
		If ($isNew)
			Form.editEntity.Tax_Rate:=Form.settings.Products.defaultTaxRate
		End if 
		
	: (Form.dataClassName="INVOICE_LINES")
		If ($isNew)
			Form.editEntity.Discount_Rate:=Form.editEntity.Invoice.Client.Discount_Rate
		End if 
		
End case 







