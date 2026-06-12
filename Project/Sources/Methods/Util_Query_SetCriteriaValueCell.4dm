//%attributes = {"folder":"OldCode","lang":"en"}
var $object : Object
var $col_Operator; $col_Condition; $col_ValueType : Collection


$index:=$1
$item:=$2
$type:=$3

$col_Operator:=Form.queryMenus[$index].extract("menu")  //  Just for testing
$col_Condition:=Form.queryMenus[$index].extract("condition")  //  Just for testing
$col_ValueType:=Form.queryMenus[$index].extract("value"; ck keep null)  //can be none long text 

Case of 
	: ($col_ValueType[$item]="none")
		$object:=Form.blankCell
		$object.condition:=$col_Condition[$item]
		
	: ($col_ValueType[$item]="long")
		$object:=New object("valueType"; "integer"; "value"; 0; "condition"; $col_Condition[$item])
		
	: ($col_ValueType[$item]="text")
		$object:=New object("valueType"; "text"; "value"; ""; "condition"; $col_Condition[$item])
		
	Else   //  Null
		Case of 
			: ($type="integer")
				$object:=New object("valueType"; "integer"; "value"; 0; "condition"; $col_Condition[$item])
				
			: ($type="real")
				$object:=New object("valueType"; "real"; "value"; 0; "condition"; $col_Condition[$item])
				
			: ($type="text")
				$object:=New object("valueType"; "text"; "value"; ""; "condition"; $col_Condition[$item])
				
			: ($type="boolean")
				$object:=New object("valueType"; "boolean"; "value"; False; "condition"; $col_Condition[$item])
				
			Else 
				$object:=New object("valueType"; "text"; "value"; ""; "condition"; $col_Condition[$item])
		End case 
End case 

$0:=$object