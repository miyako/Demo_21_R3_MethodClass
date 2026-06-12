//%attributes = {"folder":"OldCode","lang":"en"}
var $typeList : Collection

$formData:=$1
$colOK2Use:=$2
$what2do:=$3

$path:=Get 4D folder(Current resources folder)+"Images"+Folder separator+"4DIcons"+Folder separator
$typeList:=$colOK2Use.copy()  //We use .copy() in order to NOT modify $colOK2Use, otherwise, $typeList:=$colOK2Use will just duplicate the reference on the same object
If ($what2do="SORT")
	$typeList.push("image").push("blob").push("object").push("array").push("1toN").push("Nto1")  //  To add missing properties and get the pictures...
End if 
For each ($picture; $typeList)
	READ PICTURE FILE($path+$picture+".png"; $pict)
	$formData.pictures[$picture]:=$pict  //  Equivalent to: OB SET($formData.pictures;$picture;$pict)
End for each 
