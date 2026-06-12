//%attributes = {"folder":"OldCode","lang":"en"}
var $propertyName; $queryString : Text
var $dataClass; $selection; $property; $0 : Object

$queryString:=$1
$dataClass:=$2

If (Form event code=On After Keystroke)
	$text:=Get edited text
Else 
	$text:=$queryString
End if 
$isNumeric:=($text=String(Num($text)))
$selection:=$dataClass.all()
$qryString:=""
$qryPropertyList:=New collection
ARRAY TEXT($ar_Properties; 0)
Util_GetSimplePropertyList(->$ar_Properties; $dataClass; $qryPropertyList; "SIMPLE")  //Creates the list of properties for the QuickSelect
For each ($property; $qryPropertyList)
	$type:=$property.type
	$isTypeNumeric:=($type="long") | ($type="number") | ($type="long64") | ($type="float")
	$toAdd:=""
	If ($qryString#"")
		$toAdd:=" OR "
	End if 
	Case of 
		: ($type="variant")
			//We don't use it here
			
		: ($isTypeNumeric)
			If ($isNumeric)
				$qryString:=$qryString+$toAdd+$property.name+" = :1"
			End if 
		Else 
			$qryString:=$qryString+$toAdd+$property.name+" = :2"
	End case 
End for each 

$selection:=$dataClass.query($qryString; $text; "@"+$text+"@")

$0:=$selection

