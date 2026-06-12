var $object : Object

$evt:=Form event code

Case of 
	: ($evt=On Clicked)
		
	: ($evt=On Drag Over)
		If (Form.clipObject=Null)
			$0:=-1
		End if 
		
	: ($evt=On Drop)
		If (Form.clipObject#Null)
			$object:=Form.clipObject
			Form.criteriaList.push($object)
			$object.criteriaDesc:=False
			$object.criteriaPict:=Choose(Num($object.criteriaDesc); Form.pictAsc; Form.pictDesc)
			CLEAR VARIABLE(Form.clipObject)
		End if 
End case 