//%attributes = {"folder":"OldCode","lang":"en"}
var $pict : Picture
var $pictureName : Text

$pictureName:=$1

If ($pictureName#"")
	READ PICTURE FILE(""; $pict)
	If (OK=1)
		Form.editEntity[$pictureName]:=$pict
	End if 
End if 