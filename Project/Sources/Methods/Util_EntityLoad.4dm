//%attributes = {"folder":"OldCode","lang":"en"}
var $collection; $objectsNames : Collection
var $entity : Object
var $object : Text

$entity:=$1
$objectsNames:=$2

$isNew:=False
If ($entity#Null)
	If ($entity.isNew())
		Form.recordCanBeSaved:=True
		For each ($object; $objectsNames)
			Form["data_"+$object]:=New collection
			Form["cur_"+$object]:=New object
			Form["pos_"+$object]:=0
			Form["sel_"+$object]:=New collection
		End for each 
		$isNew:=True
	Else 
		For each ($object; $objectsNames)
			If ($entity[$object]=Null)
				Form["data_"+$object]:=New collection
			Else 
				Form["data_"+$object]:=Util_Object2Collection($entity[$object])
			End if 
			Form["cur_"+$object]:=New object
			Form["pos_"+$object]:=0
			Form["sel_"+$object]:=New collection
		End for each 
	End if 
Else 
	
End if 

Util_EntityLoad_Specific($isNew)

Util_HandleButtons($entity)

