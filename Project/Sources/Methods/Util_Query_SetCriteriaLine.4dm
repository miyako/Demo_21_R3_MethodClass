//%attributes = {"folder":"OldCode","lang":"en"}
var $propertySelected : Object
var $col_Operator : Collection

$propertySelected:=$1

If ($propertySelected#Null)
	$col_Logicals:=New collection
	$col_Logicals.push(Localized string("operator_and"))\
		.push(Localized string("operator_or"))\
		.push(Localized string("operator_except"))
	
	$n:=Size of array(qry_ar_Properties)
	If ($n=0)
		APPEND TO ARRAY(qry_ar_Logicals; Form.blankCell)
	Else 
		APPEND TO ARRAY(qry_ar_Logicals; New object("valueType"; "text"; "value"; "And"; "requiredList"; $col_Logicals))
	End if 
	APPEND TO ARRAY(qry_ar_Properties; $propertySelected.name)
	APPEND TO ARRAY(qry_ar_PropertyName; $propertySelected.localName)
	Case of   //"long";"string";"number";"date";"duration";"bool";"long64";"float";"variant"
		: ($propertySelected.type="string")
			$index:=0
			$type:="text"
		: ($propertySelected.type="bool")
			$index:=2
			$type:="boolean"
		: ($propertySelected.type="date")
			$index:=3
			$type:="text"
		: ($propertySelected.type="duration")
			$index:=3
			$type:="text"
		: ($propertySelected.type="image")
			$index:=4
			$type:="text"
		: ($propertySelected.type="blob")
			$index:=5
			$type:="integer"
		: ($propertySelected.type="variant")
			$index:=0
			$type:="text"
		: ($propertySelected.type="property")
			$index:=6
			$type:="text"
		: ($propertySelected.type="1toN")
			$index:=6
			$type:="text"
		: ($propertySelected.type="Nto1")
			$index:=6
			$type:="text"
		: ($propertySelected.type="object")
			$index:=6
			$type:="text"
		: ($propertySelected.type="array")  //Added to the normal list of properties for obvious reasons...
			$index:=7
			$type:="text"
		Else 
			$index:=1  //"long";"number";"long64";"float"
			If (($propertySelected.type="long") | ($propertySelected.type="long64"))
				$type:="integer"
			Else 
				$type:="real"
			End if 
	End case 
	$col_Operator:=Form.queryMenus[$index].extract("menu")
	APPEND TO ARRAY(qry_ar_Operators; New object("valueType"; "text"; "value"; $col_Operator[0]; "requiredList"; $col_Operator; "qryIndex"; $index; "qryType"; $type; \
		"originalType"; $propertySelected.type))
	APPEND TO ARRAY(qry_ar_Values; Util_Query_SetCriteriaValueCell($index; 0; $type))
End if 
