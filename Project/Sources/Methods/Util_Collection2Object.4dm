//%attributes = {"folder":"OldCode","lang":"en"}
var $object; $element : Object
var $collection; $colValues : Collection

$collection:=$1

$object:=New object

If ($collection#Null)
	If ($collection.length>0)
		$lineIndex:=0
		For each ($element; $collection)
			$type:=$element.Type  //Util_ConvertText2Type ($element.Type)
			
			Case of 
				: ($type=Is BLOB)
				: ($type=Is null)
				: ($type=Is object)
				: ($type=Is picture)
				: ($type=Is pointer)
				: ($type=Is undefined)
				: ($type=Object array)
				: ($type=Is collection)
					$text:=Replace string($element.Value; Char(Carriage return); ",")
					$colValues:=Split string($text; ","; sk ignore empty strings+sk trim spaces)
					$object[$element.Property]:=$colValues
					
				Else   //is Boolean; is date; is longint; is text; is real; is time
					$object[$element.Property]:=$element.Value
					
			End case 
		End for each 
	End if 
End if 

$0:=$object

