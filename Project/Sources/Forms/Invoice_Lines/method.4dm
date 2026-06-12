$event:=Form event code

Case of 
	: ($event=On Load)
		Form.queryString:=""
		OBJECT SET ENABLED(*; "@_BUT_OK_@"; (Form.case="MOD"))
		GOTO OBJECT(*; "_PROP_Product_Reference_")
		If (Form.case="MOD")
			OBJECT SET VISIBLE(*; "_QUERY_@"; True)
		End if 
		
	: ($event=On Data Change)
		Form.Total:=Form.Quantity*Form.Unit_Price*(100-Form.Discount_Rate)/100
		Form.Total_Tax:=Round(Form.Total*Form.Tax_Rate/100; 2)
		OBJECT SET ENABLED(*; "@_BUT_OK_@"; (Form.case="MOD") | (Form.Quantity>0))
	Else 
		
		//If ((Form.type="COL") | (Form.type="TEXT"))  //Because we decided to not accept an empty text or an empty collection, but it can be changed...
		//OBJECT SET ENABLED(*;"@_BUT_OK_@";((Form.propertyName#"") & (Form["propertyValue"+Form.type]#"")) | (Form.case="MOD"))
		//Else 
		//OBJECT SET ENABLED(*;"@_BUT_OK_@";(Form.propertyName#"") | (Form.case="MOD"))
		//End if 
End case 

