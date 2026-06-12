//%attributes = {"folder":"OldCode","lang":"en"}
var $zePaths : Collection
var $currentSelection : Object
var $zeProperty_name : Text
var $fldPtr : Pointer
var $tableNb : Integer

$currentSelection:=$1
$zeProperty_name:=$2

$zePaths:=New collection
ARRAY TEXT($ar_FieldNames; 0)
ARRAY LONGINT($ar_FieldNumbers; 0)
GET FIELD TITLES(Form.dataClassPtr->; $ar_FieldNames; $ar_FieldNumbers)  //Pointer on the table

$found:=Find in array($ar_FieldNames; $zeProperty_name)

If ($found>0)
	$tableNb:=Table(Form.dataClassPtr)
	$fldPtr:=Field($tableNb; $ar_FieldNumbers{$found})
	ARRAY TEXT($ar_Paths; 0)
	USE ENTITY SELECTION($currentSelection)
	DISTINCT ATTRIBUTE PATHS($fldPtr->; $ar_Paths)
	If (Size of array($ar_Paths)>0)
		ARRAY TO COLLECTION($zePaths; $ar_Paths)
		
	End if 
End if 
$0:=$zePaths