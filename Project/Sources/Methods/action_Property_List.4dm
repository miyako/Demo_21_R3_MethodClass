//%attributes = {"folder":"OldCode","lang":"en"}
var $column; $row : Integer
var $colFound; $collection_Main; $collection_Sel : Collection
var $collection_Cur : Object
var $collection_Pos : Integer
var $LBName : Text

$LBName:=$1

$event:=Form event code

Case of 
	: (($event=On Clicked) | ($event=On Double Clicked))
		If (Right click | Contextual click | ($event=On Double Clicked))
			If (Form.recordCanBeSaved)
				LISTBOX GET CELL POSITION(*; $LBName; $column; $row)
				action_Property_Add($LBName)
			End if 
		End if 
End case 
