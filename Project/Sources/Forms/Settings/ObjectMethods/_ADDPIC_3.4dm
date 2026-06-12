var $pict : Picture

READ PICTURE FILE(""; $pict)

If (OK=1)
	Form.settings.Company.Logo:=$pict
End if 