//%attributes = {"folder":"OldCode","lang":"en"}
var $settings; $targetSelection : Object
var $left; $top; $right; $bottom; $windowRef : Integer
var $fl_Select : Boolean

$dialog:=$1
$fl_Select:=$2
If ($fl_Select)
	$targetSelection:=$3
End if 

$fl_Exist:=(Storage[$dialog]#Null)  //We check if this Window already exists

$formData:=New object
$formData.settings:=Settings_GetCurrent
$formData.currentDialog:=$dialog
$formData.displayMode:="LIST"

//Form.settings.Modes.multiRecords

If ($fl_Exist)  //If yes...
	ARRAY LONGINT($ar_References; 0)
	WINDOW LIST($ar_References)
	$fl_Exist:=(Find in array($ar_References; Storage[$dialog].windowRef)>0)  //...we verify if it still exist
	$windowRef:=Storage[$dialog].windowRef
	
End if 
If ($fl_Exist)  //If yes, we just bring the Dialog to front
	GET WINDOW RECT($left; $top; $right; $bottom; $windowRef)
	SET WINDOW RECT($left; $top; $right; $bottom; $windowRef)  //These 2 lines will bring the Window at the frontmost level
	
Else   //if not, we create the Dialog
	Case of 
		: ($dialog="StartupScreen")
			$windowReference:=Open form window($dialog; Plain form window; *)
			
		: ($dialog="Settings")
			$windowReference:=Open form window($dialog; Controller form window; Horizontally centered; Vertically centered)
			
		Else 
			If ($fl_Select)
				GET WINDOW RECT($left; $top; $right; $bottom; Frontmost window)
				$windowReference:=Open form window($dialog; Plain form window; $left+20; $top+20; *)
			Else 
				$windowReference:=Open form window($dialog; Plain form window; *)
			End if 
			
	End case 
	
	$object:=New shared object  //Then we add the Dialog in the list
	Use ($object)
		$object.name:=$dialog  //This is not necessary, but it helps for debugging...
		$object.windowRef:=$windowReference
	End use 
	Use (Storage)
		Storage[$dialog]:=$object
	End use 
End if 

If ($fl_Select)
	CALL FORM(Storage[$dialog].windowRef; "Call_Update_Select"; $targetSelection)
End if 
If (Not($fl_Exist))
	DIALOG($dialog; $formData; *)
End if 




