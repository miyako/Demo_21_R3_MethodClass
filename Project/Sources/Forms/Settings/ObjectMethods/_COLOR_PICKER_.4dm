var $foreColor; $backColor : Integer
$ObjName:="@_COLOR_@"
OBJECT GET RGB COLORS(*; $ObjName; $foreColor; $backColor)
$backColor:=Select RGB color($backColor)
If (OK=1)
	OBJECT SET RGB COLORS(*; $ObjName; $foreColor; $backColor)
	Form.settings.Display.AlternateColorRGB:=$backColor
End if 