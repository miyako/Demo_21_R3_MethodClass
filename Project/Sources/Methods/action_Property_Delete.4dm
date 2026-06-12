//%attributes = {"folder":"OldCode","lang":"en"}
var $colFound; $collection_Main; $collection_Sel : Collection
var $collection_Cur : Object
var $collection_Pos : Integer
var $LBName : Text

$LBName:=$1

//Instead of passing parameters like ;Form.data_Numbers;Form.cur_Numbers;Form.sel_Numbers;Form.pos_Numbers)...
//..We can get the different collections from the name of the Listbox
//For instance, if the name is _LB_Numbers, we can extract "Numbers", and then (thanks to the Bracket Notation)...
//..get the Collections themselves:

$fieldName:=Substring($LBName; Length("_LB_")+1)

$collection_Main:=Form["data_"+$fieldName]  //This is exactly the same than Form.data_Numbers or Form.data_Optional_Data
$collection_Cur:=Form["cur_"+$fieldName]
$collection_Sel:=Form["sel_"+$fieldName]
$collection_Pos:=Form["pos_"+$fieldName]
$event:=Form event code

If ($event=On Clicked)
	If ($collection_Sel.length>0)
		If ($collection_Cur#Null)
			CONFIRM(Util_Get_LocalizedMessage("RemoveProperty"; $collection_Cur.Property); Localized string("Remove it"); Localized string("Cancel"))
			
			If (OK=1)
				$collection_Main.remove($collection_Pos-1)
				$collection_Main:=$collection_Main
				LISTBOX SELECT ROW(*; $LBName; 0; lk remove from selection)
			End if 
		End if 
	End if 
End if 
