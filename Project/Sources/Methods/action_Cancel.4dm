//%attributes = {"folder":"OldCode","lang":"en"}
var $status : Object

If (Form.recordCanBeSaved)
	$status:=Form.editEntity.unlock()
	Form.recordCanBeSaved:=False
	If (In transaction)
		CANCEL TRANSACTION
	End if 
End if 

If (Form.settings.Modes.multiRecords)
	Util_RecordInNewWindow("CLOSE")
Else 
	FORM GOTO PAGE(1)
	Util_UpdateSelection("_LB_1")
End if 