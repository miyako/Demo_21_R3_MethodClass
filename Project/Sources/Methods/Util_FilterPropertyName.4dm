//%attributes = {"folder":"OldCode","lang":"en"}
//Filters property names containing annoying chars

$name:=$1

//While a Property name can theoritically contain every possible characters, some of them may be a cause of problems...

$badChars:=".[]{}/,:()"+Char(160)+Char(Double quote)+Char(92)  //This list can be adapted to your own needs

$result:=""

For ($i; 1; Length($name))
	If (Position($name[[$i]]; $badChars)<1)
		$result:=$result+$name[[$i]]
	End if 
End for 

$0:=$result