//%attributes = {"folder":"OldCode","lang":"en"}
//This method sets the Window Title according to the content of the screen

var $selected; $selection; $dataClass; $currentEntity : Object
var $entitySelected; $entityInTable : Integer
$selection:=$1
$selected:=$2
$dataClassName:=$3
$currentEntity:=$4
$currentPage:=$5
$currentWindowRef:=$6

$display:=""

Case of 
	: ($currentPage=1)  //We display a List
		
		$display:=Util_Get_LocalizedMessage("No_Record"; $dataClassName)
		$entityInSelection:=$selection.length  //We get the number of Records (Entities) in the Selection
		If ($entityInSelection>0)  //We have at least one entity
			$entitySelected:=$selected.length
			//When getDataClass will be available, we will use nex line...
			//$dataClass:=$selection.first().getDataClass()  //So we get the DataClass...
			//...Meanwhile we use this :
			$dataClass:=Form.dataClass  //So we get the DataClass...
			
			$entityInTable:=$dataClass.all().length  //...and the total number of Records
			$display:=String($entityInSelection; "|Long")+" "+$dataClassName+" / "+String($entityInTable; "|Long")
			$display:=$display+" ("+String($entitySelected; "|Long")+" "+Localized string("Selected")+")"
		End if 
		
	: ($currentPage=2)  //We display an Entity
		$display:=Choose(Num($currentEntity.isNew()); "ID "+$currentEntity.getKey(dk key as string); Localized string("New_Record"))
		$display:=$dataClassName+" ("+$display+")"
		
End case 

SET WINDOW TITLE($display; $currentWindowRef)

