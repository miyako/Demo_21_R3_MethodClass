//%attributes = {"folder":"OldCode","lang":"en"}
var $foregroundColor; $backgroundColor : Integer
var $settings : Object
var $listboxName : Text

$settings:=$1
$listboxName:=$2
$fl_Enterable:=$3

LISTBOX SET GRID(*; $listboxName; $settings.Display.HLinesVisible; $settings.Display.VLinesVisible)
OBJECT GET RGB COLORS(*; $listboxName; $foregroundColor; $backgroundColor)
If ($settings.Display.AlternateColor)
	//OBJECT SET RGB COLORS(*; $listboxName; $foregroundColor; $backgroundColor; $settings.Display.AlternateColorRGB)
Else 
	//OBJECT SET RGB COLORS(*; $listboxName; $foregroundColor; $backgroundColor; Background color none)
End if 
If ($fl_Enterable)
	OBJECT SET ENTERABLE(*; "_FIELD_Value_"; $settings.Display.enterInList & Form.recordCanBeSaved)
End if 
