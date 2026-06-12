//%attributes = {"lang":"en"}
var $1; $table : Object
$table:=$1

ARRAY TEXT($fieldlist; 0)
APPEND TO ARRAY($fieldlist; "All index fields")
APPEND TO ARRAY($fieldlist; "-")
For each ($field; $table)
	$fieldobject:=$table[$field]
	If ($fieldobject.kind="storage")
		If (($fieldobject.fieldType#Is BLOB) & ($fieldobject.fieldType#Is object) & ($fieldobject.fieldType#Is picture))
			APPEND TO ARRAY($fieldlist; $field)
		End if 
	End if 
End for each 
$ptr:=OBJECT Get pointer(Object named; "fieldlist")
COPY ARRAY($fieldlist; $ptr->)
$ptr->:=1