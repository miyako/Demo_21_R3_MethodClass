If (FORM Event.code=On Clicked) && (Contextual click)
	
	var $menu:=Create menu
	APPEND MENU ITEM($menu; "show code")
	SET MENU ITEM PARAMETER($menu; -1; "show-code")
	var $command:=Dynamic pop up menu($menu)
	RELEASE MENU($menu)
	Case of 
		: ($command="")
		: ($command="show-code")
			demo_1
	End case 
	
End if 