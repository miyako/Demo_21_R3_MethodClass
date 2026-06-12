//%attributes = {"lang":"en"}
// set Listbox, define values
// Form.listbox entity selection
// "list box" is listbox to fill

$table:=Form.listbox.getDataClass()
$ds:=$table.getDataStore()
$tablename:=$table.getInfo().name
LISTBOX DELETE COLUMN(*; "list box"; 1; 100)

var $nullpointer : Pointer

$file:=File("/PACKAGE/Databrowser/"+$tablename+".myPrefs")
If ($file.exists)
	$object:=JSON Parse($file.getText())
	$counter:=0
	For each ($column; $object.columns)
		$counter:=$counter+1
		LISTBOX INSERT COLUMN FORMULA(*; "List Box"; $counter; $column.title; $column.formula; Is text; $column.title; $nullpointer)
		OBJECT SET TITLE(*; $column.title; $column.title)
		LISTBOX SET COLUMN WIDTH(*; $column.title; $column.width)
	End for each 
	
	
Else 
	
	// without defined content we use the first 10 attributes to display
	$counter:=0
	For each ($field; $table) While ($counter<10)
		$fieldobject:=$table[$field]
		If ($fieldobject.kind="storage")
			If (($fieldobject.fieldType#Is BLOB) & ($fieldobject.fieldType#Is object))
				$counter:=$counter+1
				LISTBOX INSERT COLUMN FORMULA(*; "List Box"; $counter; $field; "This."+$field; $fieldobject.fieldType; $field; $nullpointer)
				OBJECT SET TITLE(*; $field; $field)
			End if 
		End if 
	End for each 
End if 

// build subform
$page:=New object

$top:=10
For each ($field; $table)
	$fieldobject:=$table[$field]
	If ($fieldobject.kind="storage")
		If ($fieldobject.fieldType#Is BLOB)
			$formobject:=New object
			$formobject.text:=$field
			$formobject.type:="text"
			$formobject.left:=10
			$formobject.top:=$top
			$formobject.width:=120
			$formobject.height:=16
			$page[$field]:=$formobject
			
			$formobject:=New object
			$formobject.type:="input"
			$formobject.dataSource:="Form."+$field
			$formobject.left:=130
			$formobject.top:=$top
			$formobject.width:=250
			$formobject.sizingX:="grow"
			If (($fieldobject.fieldType#Is text) & ($fieldobject.fieldType#Is picture) & ($fieldobject.fieldType#Is object))
				$formobject.height:=16
				$top:=$top+25
			Else 
				If ($fieldobject.fieldType=Is picture)
					$formobject.dataSourceTypeHint:="picture"
				End if 
				$formobject.height:=95
				$formobject.sizingY:="grow"
				$top:=$top+100
				
				// add splitter
				$page[$field+"_"]:=$formobject
				
				$formobject:=New object
				$formobject.type:="splitter"
				//$formobject.dataSource:="Form."+$field
				$formobject.left:=1
				$formobject.top:=$top
				$formobject.width:=390
				$formobject.sizingX:="grow"
				$formobject.height:=5
				$top:=$top+10
			End if 
			$page[$field+"_splitter"]:=$formobject
			
			
		End if 
	End if 
	
End for each 
$subform:=New object("pages"; New collection(Null; New object("objects"; $page)))

OBJECT SET SUBFORM(*; "subform"; $subform)

