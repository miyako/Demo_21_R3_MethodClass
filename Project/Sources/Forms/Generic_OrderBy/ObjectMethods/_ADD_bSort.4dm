var $object : Object

If (Form.propertySelected#Null)
	$object:=Form.propertySelected
	Form.criteriaList:=Form.criteriaList.push($object)
	$object.criteriaDesc:=False
	$object.criteriaPict:=Choose(Num($object.criteriaDesc); Form.pictAsc; Form.pictDesc)
	Form.criteriaList:=Form.criteriaList
End if 
