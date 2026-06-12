//%attributes = {"folder":"OldCode","lang":"en"}
var $selection : Object

$selection:=$1

If (FORM Get current page=2)
	FORM GOTO PAGE(1)
End if 

Form.displayedSelection:=$selection

Util_UpdateSelection("_LB_1")
Util_UpdateOnContext(1)  //Because the FORM Get current page will return 2 for it's updated only after display


