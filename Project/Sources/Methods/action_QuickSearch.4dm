//%attributes = {"folder":"OldCode","lang":"en"}
var $propertyName : Text
var $selection; $property : Object

If (Form event code=On After Keystroke)
	$text:=Get edited text
Else 
	$text:=Form.queryString
End if 
$isNumeric:=($text=String(Num($text)))
$choice:=(Form.popupPtr)->
If (Form.inSelection)
	$selection:=Form.displayedSelection
Else 
	$selection:=Form.dataClass.all()
End if 
If ($choice<4)  //Search everywhere
	$qryString:=""
	For each ($property; Form.qryPropertyList)
		$type:=$property.type
		$isTypeNumeric:=($type="long") | ($type="number") | ($type="long64") | ($type="float")
		$toAdd:=""
		If ($qryString#"")
			$toAdd:=" OR "
		End if 
		If ($isTypeNumeric)
			If ($isNumeric)
				$qryString:=$qryString+$toAdd+$property.name+" = :1"
			End if 
		Else 
			$qryString:=$qryString+$toAdd+$property.name+" = :2"
		End if 
	End for each 
	Form.displayedSelection:=$selection.query($qryString; $text; "@"+$text+"@")
Else 
	$propertyName:=Form.qryPropertyList[$choice-3].name
	$type:=Form.qryPropertyList[$choice-3].type
	$isTypeNumeric:=($type="long") | ($type="number") | ($type="long64") | ($type="float")
	If ($isNumeric & $isTypeNumeric)
		Form.displayedSelection:=$selection.query($propertyName+" = :1"; $text)
	Else 
		Form.displayedSelection:=$selection.query($propertyName+" = :1"; "@"+$text+"@")
	End if 
End if 

