//%attributes = {"lang":"en"}
// handles listbox creation/filling for current table


$usertable:=ds.Listbox_Setting.query("TableName=:1 and UserName=:2"; Form.dataClassName; Current user).first()
If ($usertable=Null)
	$usertable:=ds.Listbox_Setting.query("TableName=:1 and UserName=:2"; Form.dataClassName; "default").first()
End if 
//If ($usertable=Null)