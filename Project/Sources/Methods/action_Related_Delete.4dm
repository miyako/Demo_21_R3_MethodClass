//%attributes = {"folder":"OldCode","lang":"en"}
var $selection_Cur; $selection_Main; $selection_Sel; $status : Object
var $selection_Pos : Integer
var $LBName : Text

$LBName:=$1  //Name of the Listbox
$relation:=$2  //Name of the Relational Attribute One-to-Many

$fieldName:=$relation

//Instead of passing parameters like ;Form.data_Numbers;Form.cur_Numbers;Form.sel_Numbers;Form.pos_Numbers)...
//..We can get the different collections from the name of the Listbox
//For instance, if the name is _LB_Numbers, we can extract "Numbers", and then (thanks to the Bracket Notation)...
//..get the Collections themselves:
If (Form.recordCanBeSaved)
	$selection_Main:=Form.editEntity[$relation]  //returns Form.editEntity.Lines_Fm_Invoices
	$selection_Cur:=Form["cur_"+$fieldName]
	$selection_Sel:=Form["sel_"+$fieldName]
	$selection_Pos:=Form["pos_"+$fieldName]
	
	$event:=Form event code
	
	If ($event=On Clicked)
		If ($selection_Sel.length>0)
			If ($selection_Cur#Null)
				CONFIRM(Util_Get_LocalizedMessage("RemoveLine"; String($selection_Pos)); Localized string("Remove it"); Localized string("Cancel"))
				
				If (OK=1)
					$status:=$selection_Cur.drop()
					
					If ($status.success)
						Form.editEntity.reload()
						//LISTBOX SELECT ROW(*;$LBName;0;lk remove from selection)
						Util_EntityLoad_Specific(False)
						
					Else   //This case should very unlikely happen, for the Record has been locked
						ALERT(Util_Get_LocalizedMessage("Recordnotdeleted"; $status.statusText))
						
					End if 
				End if 
			End if 
		End if 
	End if 
End if 