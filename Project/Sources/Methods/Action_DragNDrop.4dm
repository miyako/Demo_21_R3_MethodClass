//%attributes = {"folder":"OldCode","lang":"en"}
var $1 : Integer
var $2; $DnDsource : Object
var $PrimaryKey : Text
var $dragCollection : Collection

$event:=$1
$selection:=$2

Case of 
	: ($event=On Begin Drag Over)
		$nbOfLines:=$selection.length
		Case of 
			: ($nbOfLines<1)
				//Nothing to do
			Else 
				$icon:=Util_Get_DragNDropIcon($nbOfLines)
				SET DRAG ICON($icon)
				
				ARRAY REAL($array; 0)
				$collection:=$selection.toCollection("ID")
				COLLECTION TO ARRAY($collection; $array; "ID")
				$dragCollection:=New shared collection
				Use ($dragCollection)
					ARRAY TO COLLECTION($dragCollection; $array)
				End use 
				$dragThings:=New shared object
				Use ($dragThings)
					$dragThings.sourceDataClass:=Form.dataClassName
					$dragThings.sourceSelField:="ID"
				End use 
				Use (Storage)
					Storage.DnDdataClassInfo:=$dragThings
					Storage.DnDcollection:=$dragCollection
					//storage.DnDproperty:="ID"
				End use 
				
		End case 
		
	: ($event=On Drag Over)
		
		
	: ($event=On Drop)
		$DnDsource:=Storage.DnDdataClassInfo
		If ($DnDsource#Null)
			$source:=Storage.DnDdataClassInfo.sourceDataClass
			If ($source=Form.dataClassName)
				//Drop inside the same class, we do nothing
			Else 
				$PrimaryKey:=Storage.DnDdataClassInfo.sourceSelField
				$collection:=Storage.DnDcollection
				If (($source#"") & ($collection.length>0))
					$dataSource:=ds[$source]
					$selection2use:=$dataSource.query($PrimaryKey+" in :1"; $collection)
					var $nilPtr : Pointer
					Call_Update_Dialogs($nilPtr; $dataSource; $source; $selection2use; $selection2use; $selection2use.first(); "DragDrop"; 1; Form.dataClassName)
				End if 
				Use (Storage)
					Storage.DnDdataClassInfo:=New shared object
					Storage.DnDcollection:=New shared collection
					//storage.DnDproperty:="ID"
				End use 
			End if 
		End if 
End case 