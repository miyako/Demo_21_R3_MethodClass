//%attributes = {"folder":"OldCode","lang":"en"}
var $1; $0; $o; $variant; $3 : Object
var $2; $property : Text
var $properties : Collection

$object:=$1
$path:=$2
$variant:=$3

$properties:=Split string($path; ".")

If ($properties.length>0)
	$i:=0
	For each ($property; $properties)
		Case of 
			: ($i>=($properties.length-1))  //last property in the path, must take the value
				$o[$property]:=$variant.value
				
			: ($i=0)
				If ($object[$property]=Null)
					$object[$property]:=New object
				End if 
				$o:=$object[$property]
				
			Else 
				If ($o[$property]=Null)
					$o[$property]:=New object
				End if 
				$o:=$o[$property]
				
		End case 
		$i:=$i+1
	End for each 
End if 

$0:=$object
