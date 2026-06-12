$evt:=Form event code

Case of 
	: ($evt=On Load)
		OBJECT SET VISIBLE(*; "_TEXT_COL_"; (Form.type="COL"))
		OBJECT SET VISIBLE(*; "@_VALUE_@"; False)
		OBJECT SET VISIBLE(*; "@_VALUE_"+Form.type+"_@"; True)
		OBJECT SET ENABLED(*; "@_BUT_OK_@"; (Form.case="MOD"))
		Form.nameBefore:=Form.propertyName
		
	Else 
		If ($evt=On After Edit)
			//$p:=object get pointer(Object named;OBJECT Get name(Object with focus))
		End if 
		
		If ((Form.type="COL") | (Form.type="TEXT"))  //Because we decided to not accept an empty text or an empty collection, but it can be changed...
			OBJECT SET ENABLED(*; "@_BUT_OK_@"; ((Form.propertyName#"") & (Form["propertyValue"+Form.type]#"")) | (Form.case="MOD"))
		Else 
			OBJECT SET ENABLED(*; "@_BUT_OK_@"; (Form.propertyName#"") | (Form.case="MOD"))
		End if 
End case 

