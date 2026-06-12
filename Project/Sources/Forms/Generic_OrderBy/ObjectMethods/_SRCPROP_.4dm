var $object : Object

$evt:=Form event code

Case of 
	: ($evt=On Double Clicked)
		If (Form.propertySelected#Null)
			$object:=Form.propertySelected
			Form.criteriaList:=Form.criteriaList.push($object)
			$object.criteriaDesc:=False
			$object.criteriaPict:=Choose(Num($object.criteriaDesc); Form.pictAsc; Form.pictDesc)
		End if 
		
	: ($evt=On Begin Drag Over)
		Form.clipObject:=Form.propertySelected
		
		
End case 