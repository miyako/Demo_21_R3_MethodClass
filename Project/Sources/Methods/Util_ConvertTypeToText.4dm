//%attributes = {"folder":"OldCode","lang":"en"}
//This method will return the basic type from the value type

$valueType:=$1

$result:="Text"
Case of 
	: ($valueType=Is BLOB)
	: ($valueType=Is null)
	: ($valueType=Is object)
	: ($valueType=Is picture)
	: ($valueType=Is pointer)
	: ($valueType=Is undefined)
	: ($valueType=Object array)
	: ($valueType=Is collection)
		$result:="Col"
	: ($valueType=Is boolean)
		$result:="Bool"
	: ($valueType=Is date)
		$result:="Date"
	: ($valueType=Is longint)
		$result:="Num"
	: ($valueType=Is text)
		$result:="Text"
	: ($valueType=Is real)
		$result:="Num"
	: ($valueType=Is time)
End case 

$0:=$result

