//%attributes = {"folder":"OldCode","lang":"en"}
var $1; ${2} : Text
$resname:=$1

$message:=Localized string($resname)
If ((OK=1) & ($message#""))
	$message:=Replace string($message; "[CR]"; Char(Carriage return))
	For ($i; 1; Count parameters-1)
		$message:=Replace string($message; "["+String($i)+"]"; ${$i+1})
	End for 
Else 
	$message:=$resname
End if 

$0:=$message
