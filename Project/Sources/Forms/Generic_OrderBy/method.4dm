$evt:=Form event code

Case of 
	: (($evt=On Load) | ($evt=On Clicked) | ($evt=On Selection Change) | ($evt=On Double Clicked))
		
		OBJECT SET ENABLED(*; "@_ADD_@"; ((Form.propertySelected#Null) & (Form.propertyPosition<=Form.propertyList.length)))
		OBJECT SET ENABLED(*; "@_REM_@"; (Form.criteriaSelected#Null))
		OBJECT SET ENABLED(*; "@_VAL_@"; (Form.criteriaList.length>0))
		//LISTBOX SET PROPERTY(*;"_DESTPROP_";lk hide selection highlight;lk yes)
		
End case 

