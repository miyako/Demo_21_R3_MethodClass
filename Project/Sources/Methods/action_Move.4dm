//%attributes = {"folder":"OldCode","lang":"en"}
$what2do:=$1

If (Form event code#On Load)
	//Products_InputCommonTasks($evt;"SAVE")
End if 

$OK:=True

Case of 
	: ($what2do="FIRST")
		Form.clickedEntity:=Form.clickedEntity.first()
	: ($what2do="PREVIOUS")
		If (Not(Form.clickedEntity.previous()=Null))
			Form.clickedEntity:=Form.clickedEntity.previous()
		End if 
	: ($what2do="NEXT")
		If (Not(Form.clickedEntity.next()=Null))  //isLast())
			Form.clickedEntity:=Form.clickedEntity.next()
		End if 
	: ($what2do="LAST")
		Form.clickedEntity:=Form.clickedEntity.last()
	Else 
		$OK:=False
End case 

If ($OK)
	Form.editEntity:=Form.clickedEntity
	Util_EntityLoad(Form.editEntity; Form.objectsNames)
End if 


