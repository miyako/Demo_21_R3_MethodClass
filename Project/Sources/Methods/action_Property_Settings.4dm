//%attributes = {"folder":"OldCode","lang":"en"}
var $LBName : Text
var $fl_Enterable : Boolean

$LBName:=$1
$fl_Enterable:=$2

$settings:=Form.settings

$settingMenu:=Create menu
APPEND MENU ITEM($settingMenu; Localized string("Show Horizontal Grid Lines"))
SET MENU ITEM PARAMETER($settingMenu; -1; "HGrid")
If ($settings.Display.HLinesVisible)
	SET MENU ITEM MARK($settingMenu; -1; Char(18))
End if 
APPEND MENU ITEM($settingMenu; Localized string("Show Vertical Grid Lines"))
SET MENU ITEM PARAMETER($settingMenu; -1; "VGrid")
If ($settings.Display.VLinesVisible)
	SET MENU ITEM MARK($settingMenu; -1; Char(18))
End if 
If ($fl_Enterable)
	APPEND MENU ITEM($settingMenu; Localized string("Enterable"))
	SET MENU ITEM PARAMETER($settingMenu; -1; "Enterable")
	If ($settings.Display.enterInList)
		SET MENU ITEM MARK($settingMenu; -1; Char(18))
	End if 
End if 
APPEND MENU ITEM($settingMenu; Localized string("Alternate Background color"))
SET MENU ITEM PARAMETER($settingMenu; -1; "AlternateBckg")
If ($settings.Display.AlternateColor)
	SET MENU ITEM MARK($settingMenu; -1; Char(18))
End if 

$choice:=Dynamic pop up menu($settingMenu)  //Displays the popup menu
RELEASE MENU($settingMenu)
//Never forget to release every menus...

$fl_DoIt:=True
Case of 
	: ($choice="HGrid")
		$settings.Display.HLinesVisible:=Not($settings.Display.HLinesVisible)
		
	: ($choice="VGrid")
		$settings.Display.VLinesVisible:=Not($settings.Display.VLinesVisible)
		
	: ($choice="Enterable")
		$settings.Display.enterInList:=Not($settings.Display.enterInList)
		
	: ($choice="AlternateBckg")
		$settings.Display.AlternateColor:=Not($settings.Display.AlternateColor)
		
	Else 
		$fl_DoIt:=False
End case 

If ($fl_DoIt)
	Settings_ApplyToListBox($settings; $LBName; $fl_Enterable)
End if 