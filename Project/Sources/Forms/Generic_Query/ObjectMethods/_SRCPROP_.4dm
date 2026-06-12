$evt:=Form event code

Case of 
	: ($evt=On Double Clicked)
		If (Form.propertySelected#Null)
			Util_Query_SetCriteriaLine(Form.propertySelected)
		End if 
		
	: ($evt=On Begin Drag Over)
		Form.clipObject:=Form.propertySelected
		
		
End case 