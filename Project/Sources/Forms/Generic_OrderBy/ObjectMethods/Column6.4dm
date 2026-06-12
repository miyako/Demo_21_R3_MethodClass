If (Form event code=On Clicked)
	If (Form.criteriaSelected#Null)
		Form.criteriaSelected.criteriaDesc:=Not(Form.criteriaSelected.criteriaDesc)
		Form.criteriaSelected.criteriaPict:=Choose(Num(Form.criteriaSelected.criteriaDesc); Form.pictAsc; Form.pictDesc)
		//***************************
		Form.criteriaList:=Form.criteriaList  //To force the update of the list
		//***************************
	End if 
End if 