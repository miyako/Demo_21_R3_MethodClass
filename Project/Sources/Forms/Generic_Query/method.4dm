$evt:=Form event code

Case of 
	: ($evt=On Load)
		//ARRAY BOOLEAN(lb_Criterias;0)
		ARRAY OBJECT(qry_ar_Logicals; 0)
		ARRAY TEXT(qry_ar_Properties; 0)
		ARRAY TEXT(qry_ar_PropertyName; 0)
		ARRAY OBJECT(qry_ar_Operators; 0)
		ARRAY OBJECT(qry_ar_Values; 0)
		Form.queryMenus:=Util_Query_PrepareMenus
		Form.blankCell:=New object("valueType"; "color"; "value"; 0x00EEEEEE)
		OBJECT SET ENABLED(*; "@_VAL_@"; False)
		qry_ar_PropertyName:=0
		
	: ($evt=On Clicked)
		
		
End case 

If (($evt=On Load) | ($evt=On Clicked) | ($evt=On Double Clicked) | ($evt=On Drop) | ($evt=On Selection Change) | ($evt=On Data Change))
	OBJECT SET ENABLED(*; "@_ADD_@"; ((Form.propertySelected#Null) & (Form.propertyPosition<=Form.propertyList.length)))
	OBJECT SET ENABLED(*; "@_REM_@"; (qry_ar_PropertyName>0))
	OBJECT SET ENABLED(*; "@_VAL_@"; (Size of array(qry_ar_Operators)>0))
End if 
