//%attributes = {"folder":"OldCode","lang":"en"}
var $objectAttribute; $element : Object
var $collection : Collection
var $property; $subProp : Text

$objectAttribute:=$1

$collection:=New collection

If ($objectAttribute#Null)
	If (Not(OB Is empty($objectAttribute)))
		$lineIndex:=0
		For each ($property; $objectAttribute)
			$type:=Value type($objectAttribute[$property])
			Case of 
				: ($type=Is BLOB)
				: ($type=Is null)
				: ($type=Is object)
					For each ($subProp; $objectAttribute[$property])
						$collection.push(New object("Property"; $property+"."+$subProp; "Value"; $objectAttribute[$property][$subProp]; "Type"; Value type($objectAttribute[$property][$subProp])))
					End for each 
				: ($type=Is picture)
				: ($type=Is pointer)
				: ($type=Is undefined)
				: ($type=Object array)
				: ($type=Is collection)
					Case of 
						: ($objectAttribute[$property].length=0)
						: (Value type($objectAttribute[$property][0])=Is object)
							$lineIndex:=0
							For each ($element; $objectAttribute[$property])
								$lineIndex:=$lineIndex+1
								For each ($subProp; $element)
									$collection.push(New object("Property"; $property+"["+String($lineIndex)+"]."+$subProp; "Value"; $element[$subProp]; "Type"; Value type($element[$subProp])))
								End for each 
							End for each 
						Else 
							$collection.push(New object("Property"; $property; "Value"; $objectAttribute[$property].join(", "); "Type"; $type))
					End case 
				Else   //is Boolean; is date; is longint; is text; is real; is time
					$collection.push(New object("Property"; $property; "Value"; $objectAttribute[$property]; "Type"; $type))
			End case 
		End for each 
	End if 
End if 

$0:=$collection

