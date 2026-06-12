$event:=Form event code

Case of 
	: ($event=On Load)
		OBJECT Get pointer(Object named; "_TITLE_")->:=Localized string("STARTUP")
		OBJECT Get pointer(Object named; "_PRODUCTS_Text")->:=Localized string("PRODUCTS")
		OBJECT Get pointer(Object named; "_CLIENTS_Text")->:=Localized string("CLIENTS")
		OBJECT Get pointer(Object named; "_INVOICES_Text")->:=Localized string("INVOICES")
		OBJECT Get pointer(Object named; "_SETTINGS_Text")->:=Localized string("SETTINGS")
		
End case 