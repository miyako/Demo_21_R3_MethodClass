//%attributes = {"folder":"OldCode","lang":"en"}
var $colFound; $collection_Main; $collection_Sel : Collection
var $collection_Cur : Object
var $collection_Pos : Integer
var $LBName : Text

$LBName:=$1
$collection_Main:=$2
$collection_Cur:=$3
$collection_Sel:=$4
$collection_Pos:=$5

//This is the traditional way. with passing parameters Form.data_Optional_Data;Form.cur_Optional_Data;Form.sel_Optional_Data;Form.pos_Optional_Data)

//For a more flexible way, have a look at action_Property_Delete

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
