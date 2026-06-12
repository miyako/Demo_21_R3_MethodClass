//%attributes = {"folder":"OldCode","lang":"en"}
var $formData; $selection : Object
var $dialog : Text

$what2Do:=$1


Case of 
	: ($what2Do="OPEN")
		$dialog:=Form.currentDialog
		GET WINDOW RECT($left; $top; $right; $bottom; Frontmost window)
		$selection:=Form.dataClass.query("ID = :1"; Form.clickedEntity.ID)
		
		$formData:=OB Copy(Form)
		$formData.settings:=Settings_GetCurrent
		$formData.displayMode:="PAGE"
		$formData.openSelection:=$selection
		$formData.openSubset:=$selection
		$formData.openEntity:=Form.clickedEntity
		
		$windowReference:=Open form window($dialog; Plain form window; $left+20; $top+20)
		$formData.windowRef:=$windowReference
		CALL FORM($windowReference; "Call_Open1Record"; $formData; $selection)
		DIALOG($dialog; $formData; *)
		
	: ($what2Do="CLOSE")
		
		CANCEL
		
End case 
