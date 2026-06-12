var $object : Text

$event:=Form event code

Case of 
	: ($event=On Load)
		//General
		Form.queryString:=""
		Form.inSelection:=False
		Form.dataClass:=ds.INVOICES
		Form.dataClassName:=Form.dataClass.getInfo().name
		Form.dataClassPtr:=Table(Form.dataClass.getInfo().tableNumber)
		
		SetupListbox
		
	: ($event=On Close Box)
		Case of 
			: (FORM Get current page=1)
				BEEP
				//CANCEL  // CHECK IF record needs to be saved
				
				
		End case 
		
End case 
