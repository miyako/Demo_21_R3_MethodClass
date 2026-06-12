//%attributes = {"folder":"OldCode","lang":"en"}
var $status : Object

$status:=Form.clickedEntity.reload()
If ($status.success)
	Form.editEntity:=Form.clickedEntity
	Util_EntityLoad(Form.editEntity; Form.objectsNames)
	Form.recordCanBeSaved:=False
	If (Form.settings.Modes.multiRecords)
		Util_RecordInNewWindow("OPEN")
	Else 
		FORM GOTO PAGE(2)
	End if 
	
Else 
	Case of 
		: ($status.status=dk status entity does not exist anymore)
			ALERT(Localized string("Recordnotexist"))  //$status.statusText)
			
		Else 
			ALERT(Localized string("unexpected problem"))
			
	End case 
End if 

