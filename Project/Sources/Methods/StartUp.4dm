//%attributes = {"folder":"OldCode","lang":"en"}



// Check minimal version of 4D for compatibility
var compatibility_version_check : Text
var $fl_Select : Boolean
$compatibility_version_check:=Application version
If ($compatibility_version_check<"1740")
	// (Content of this message should be included as an xliff resource):
	
	CONFIRM(Util_Get_LocalizedMessage("VersionCheck"))
	If (OK=1)
		QUIT 4D
	End if 
End if 
If (Not(Version type ?? 64 bit version))
	ALERT(Util_Get_LocalizedMessage("Use64bitVersion"))  // to avoid an empty Admin dashboard.
End if 

If ((Application type=4D Local mode) | (Application type=4D Remote mode))
	CALL WORKER("Generic"; "W_Generic"; "StartupScreen"; $fl_Select)
	
End if 

If ((Application type=4D Local mode) | (Application type=4D Server))
	WEB SET ROOT FOLDER(Get 4D folder(Database folder)+"Web")
	WEB START SERVER
End if 