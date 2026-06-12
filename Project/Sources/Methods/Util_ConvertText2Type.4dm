//%attributes = {"folder":"OldCode","lang":"en"}
//This method will return the value type from the basic type (Text, Num, Date, etc...) 

$valueText:=$1

$valueType:=Is text

Case of 
	: ($valueText="Col")
		$valueType:=Is collection
		
	: ($valueText="Bool")
		$valueType:=Is boolean
		
	: ($valueText="Date")
		$valueType:=Is date
		
	: ($valueText="Text")
		$valueType:=Is text
		
	: ($valueText="Num")
		$valueType:=Is real  //There is no way to know it shoud be 'Is longint'
		
End case 

$0:=$valueType

