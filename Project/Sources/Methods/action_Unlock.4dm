//%attributes = {"folder":"OldCode","lang":"en"}
var $status : Object
var $fl_NeedTransaction : Boolean
var $calculatedFields; $touchedFields : Collection
var $field : Text

$fl_NeedTransaction:=$1

If (Form.recordCanBeSaved)  //We will try to lock the Entity (Pessimistic locking)
	If ($fl_NeedTransaction & Not(In transaction))
		START TRANSACTION
	End if 
	$status:=Form.editEntity.lock(dk reload if stamp changed)
	If ($status.success)
		If ($status.wasReloaded)
			ALERT(Localized string("RecordNewVersion"))
		End if 
		Util_EntityLoad(Form.editEntity; Form.objectsNames)
		$fl_NoLock:=False
	Else 
		Case of 
			: ($status.status=dk status entity does not exist anymore)
				BEEP
				ALERT(Localized string("Recordnotexist"))
				Form.recordCanBeSaved:=False
				If (Form.settings.Modes.multiRecords)
					Util_RecordInNewWindow("CLOSE")
				Else 
					FORM GOTO PAGE(1)
				End if 
				
			: ($status.status=dk status locked)
				BEEP
				ALERT(Util_Get_LocalizedMessage("Recordhasbeenlock"; $status.lockInfo.user_name; $status.lockInfo.user4d_id))
				Form.recordCanBeSaved:=False
				
			: ($status.status=dk status serious error)
				BEEP
				ALERT(Util_Get_LocalizedMessage("RecordhasProblem"; $status.lockInfo.errors.text.join(Char(Carriage return))))
				Form.recordCanBeSaved:=False
				
			Else 
				ALERT(Util_Get_LocalizedMessage("Something strangemodify"; $status.lockInfo.errors.text.join(Char(Carriage return))))
				Form.recordCanBeSaved:=False
				
		End case 
		$fl_NoLock:=True
	End if 
	If ($fl_NoLock & In transaction)
		CANCEL TRANSACTION
	End if 
	
Else   //We will unlock the record)
	If (Form.editEntity.touched())  //It has been modified
		If (Form.editEntity.isNew())
			//Can't normally happen, for the Lock button is disabled
		Else 
			$calculatedFields:=New collection("Total_Sales"; "Tax_Rate"; "Discount_Rate"; "Tax"; "Total")  //These fields are automatically recalculated, so they will be always 'touched'...
			$touchedFields:=Form.editEntity.touchedAttributes()  //...which means that we should remove them of the list
			$Fl_TouchedButOK:=True
			For each ($field; $touchedFields)
				If ($calculatedFields.indexOf($field)<0)
					$Fl_TouchedButOK:=False
				End if 
			End for each 
			If ($Fl_TouchedButOK)
				OK:=1
			Else 
				CONFIRM(Util_Get_LocalizedMessage("loseModifs"); Localized string("Save it"); Localized string("Do not save it"))
			End if 
			If (OK=1)
				$status:=Form.editEntity.save()
				//No need to test the success for the Entity was locked, but, just in case...
				Case of   //Save it
					: ($status.success)
						Form.editEntity.unlock()
						$fl_SavedOK:=True
					Else 
						ALERT(Util_Get_LocalizedMessage("Something strangemodify"; $status.lockInfo.errors.text.join(Char(Carriage return))))
						Form.recordCanBeSaved:=False
						$fl_SavedOK:=False
				End case 
				
			Else   //Do not save it
				Form.editEntity.unlock()
				$fl_SavedOK:=False
			End if 
		End if 
		
	Else   //It has not been modified
		Form.editEntity.unlock()
		$fl_SavedOK:=False
	End if 
	
	If (In transaction)
		If ($fl_SavedOK)
			VALIDATE TRANSACTION
		Else 
			CANCEL TRANSACTION
		End if 
	End if 
	
	Util_EntityLoad(Form.editEntity; Form.objectsNames)
End if 
