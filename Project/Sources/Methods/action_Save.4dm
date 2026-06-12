//%attributes = {"folder":"OldCode","lang":"en"}
var $status : Object
var $fl_IsNewRecord : Boolean
var $object : Text

$fl_IsNewRecord:=Form.editEntity.isNew()
If (Form.recordCanBeSaved)
	For each ($object; Form.objectsNames)
		If ($object#"")
			Form.editEntity[$object]:=Util_Collection2Object(Form["data_"+$object])  //To Update the Object Fields
		End if 
	End for each 
	$status:=Form.editEntity.save()  //Here we do not use the 'dk auto merge' parameter, for we use Pessimistic Locking
	
	$flOK2Validate:=False
	Case of 
		: ($status.success)
			$status:=Form.editEntity.unlock()
			$flOK2Validate:=True
			
		: ($status.status=dk status locked)  //This case should never happen in case of  Pessimistic Locking!
			ALERT(Util_Get_LocalizedMessage("Recordinusesaved"; $status.lockInfo.user_name))
			
		: ($status.status=dk status entity does not exist anymore)  //This case also should never happen in case of  Pessimistic Locking!
		: ($status.status=dk status stamp has changed)  //...neither this one...
		: ($status.success & $status.autoMerged)  //Saved & automerged
		: ($status.status=dk status automerge failed)  //Automerge failed,
		: ($status.status=dk status wrong permission)  //Nothing to do :-( You don't have the right to save it, period!
		: ($status.status=dk status serious error)
			ALERT(Util_Get_LocalizedMessage("Something strangesave"; $status.lockInfo.errors.text.join(Char(Carriage return))))
	End case 
	If (In transaction)
		If ($flOK2Validate)
			VALIDATE TRANSACTION
		Else 
			CANCEL TRANSACTION
		End if 
	End if 
End if 

If (Form.settings.Modes.multiRecords)
	Util_RecordInNewWindow("CLOSE")
Else 
	Form.recordCanBeSaved:=False
	If ($fl_IsNewRecord)
		Form.displayedSelection.add(Form.editEntity)
	End if 
	Form.displayedSelection:=Form.displayedSelection
	FORM GOTO PAGE(1)
	Util_UpdateSelection("_LB_1")
End if 