//%attributes = {"folder":"OldCode","lang":"en"}
var $toDelete; $lockedSelection; $status; $subsel2Kill : Object
var $n : Integer

$toDelete:=$1
$what:=$2

If ($toDelete=Null)
	BEEP
	ALERT(Localized string("There is nothing to delete!"))
	
Else 
	//The second parameter should not be necessary, for it is possible to get the type of object from the object itself:
	//  1st solution : wait for the 'Get Class Name' command which will return 'PRODUCTS' for an Entity, and 'PRODUCTS Selection' for a Selection
	//  2nd solution : Test If (Value type($toDelete.length)=Is undefined), because the read only '.length' property if defined for a Selection, and undifined for an Entity
	
	Case of 
		: ($what="Entity")
			If (Form.recordCanBeSaved)
				$text:=Util_Get_LocalizedMessage("delete this Entity")
				CONFIRM($text; Localized string("Delete it"); Localized string("Cancel"))
				If (OK=1)
					START TRANSACTION
					Case of   //Handling of special cases
						: (Form.dataClassName="INVOICES")  //To delete an invoice, it's necessary to delete invoice lines first
							$subsel2Kill:=Form.editEntity.Lines_Fm_Invoices
							$lockedSelection:=$subsel2Kill.drop(dk stop dropping on first error)
							$fl_Stop:=($lockedSelection.length>0)
						Else 
							$fl_Stop:=True
					End case 
					
					If ($fl_Stop)
						CANCEL TRANSACTION
						ALERT(Localized string("unexpected problem"))
					Else 
						$status:=Form.editEntity.drop()
						
						If ($status.success)
							Form.recordCanBeSaved:=False
							Form.displayedSelection:=Form.displayedSelection.minus(Form.editEntity)
							VALIDATE TRANSACTION
							If (Form.settings.Modes.multiRecords)
								Util_RecordInNewWindow("CLOSE")
							Else 
								FORM GOTO PAGE(1)
								Util_UpdateSelection("_LB_1")
							End if 
							
						Else 
							Case of 
								: ($status.status=dk status locked)  //This case should never happen in case of Pessimistic Locking!
									ALERT(Util_Get_LocalizedMessage("Recordinuse"; $status.lockInfo.user_name))
									
								: ($status.status=dk status entity does not exist anymore)  //This case also should never happen in case of  Pessimistic Locking!
									ALERT(Localized string("Recorddeleted"))
									
								: ($status.status=dk status stamp has changed)  //...neither this one...
								: ($status.status=dk status wrong permission)  //Nothing to do :-( You don't have the right to delete it, period!
								: ($status.status=dk status serious error)
									ALERT(Util_Get_LocalizedMessage("Something strange"; $status.lockInfo.errors.text.join(Char(Carriage return))))
									
							End case 
							CANCEL TRANSACTION
						End if 
					End if 
				End if 
				
			Else 
				BEEP
				ALERT(Localized string("Read-Only mode"))
				
			End if 
			
		: ($what="Selection")
			$n:=Form.selectedSubset.length
			$text:=Util_Get_LocalizedMessage("deleteSelection"; String($n))
			CONFIRM($text; Localized string("Delete it"); Localized string("Cancel"))
			If (OK=1)
				START TRANSACTION  //This is only necessary when deletion of Records imply deletion of records from another Table (i.e. [INVOICES] and [INVOICES_LINES] for instance)
				
				Case of   //Handling of special cases
					: (Form.dataClassName="INVOICES")  //To delete an invoice, it's necessary to delete invoice lines first
						$subsel2Kill:=Form.selectedSubset.Lines_Fm_Invoices
						$lockedSelection:=$subsel2Kill.drop(dk stop dropping on first error)
						$fl_Stop:=($lockedSelection.length>0)
					Else 
						$fl_Stop:=True
				End case 
				
				If ($fl_Stop)
					CANCEL TRANSACTION
					ALERT(Localized string("unexpected problem"))
				Else 
					$lockedSelection:=Form.selectedSubset.drop(dk stop dropping on first error)  //$lockedSelection is an entity selection containing the first not dropped entity
					If ($lockedSelection.length=0)  //The delete action is successful, all the entities have been deleted
						VALIDATE TRANSACTION
						ALERT(Util_Get_LocalizedMessage("You have dropped"; String($n); Form.dataClassName))  //The dropped entity selection remains in memory
						Form.displayedSelection:=Form.displayedSelection.minus($toDelete)
						Util_UpdateSelection("_LB_1")
						
					Else 
						CANCEL TRANSACTION
						ALERT(Localized string("At least one"))
						
					End if 
				End if 
				
			End if 
	End case 
End if 