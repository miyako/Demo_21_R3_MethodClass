$event:=Form event code
Case of 
	: ($event=On Getting Focus)
		OBJECT SET VISIBLE(*; "_PRODUCTLIST_"; Form.queryString#"")
		
	: ($event=On Losing Focus)
		OBJECT SET VISIBLE(*; "_PRODUCTLIST_"; False)
		
	: ($event=On After Keystroke)
		$value:=Get edited text
		If ($value#"")
			OBJECT SET VISIBLE(*; "_PRODUCTLIST_"; True)
			Form.productsList:=ds.PRODUCTS.query("Reference = :1 or Name = :1"; "@"+$value+"@")
		Else 
			OBJECT SET VISIBLE(*; "_PRODUCTLIST_"; False)
		End if 
End case 
