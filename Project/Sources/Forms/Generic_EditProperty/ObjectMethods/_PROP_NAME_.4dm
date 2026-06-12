$name:=Util_FilterPropertyName(Form.propertyName)
If ($name#Form.propertyName)
	BEEP
	ALERT(Util_Get_LocalizedMessage("ForbiddenCharacter"; Form.propertyName))
	Form.propertyName:=$name
	GOTO OBJECT(*; "_PROP_NAME_")
End if 