//%attributes = {"folder":"OldCode","lang":"en"}
var $settings; $settingsSel; $status : Object

$settingsSel:=ds.DEFAULT_SETTINGS.all()
If ($settingsSel.length<1)
	$settings:=ds.DEFAULT_SETTINGS.new()
	Settings_Preset($settings)
	$status:=$settings.save()  //No need to check the success, for it's a new entity
Else 
	$settings:=$settingsSel.first()
	
End if 

$0:=$settings

