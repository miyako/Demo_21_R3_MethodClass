If (FORM Event.code=On Data Change)
	// find indexed fields
	$table:=Form.listbox.getDataClass()
	$ds:=$table.getDataStore()
	$tablename:=$table.getInfo().name
	
	$ptr:=OBJECT Get pointer(Object named; "fieldlist")
	$selectedfield:=$ptr->
	If ($selectedfield=1)
		$querystring:=""
		$fieldcol:=New collection
		
		For each ($field; $table)
			$fieldobject:=$table[$field]
			If ($fieldobject.kind="storage")
				If ($fieldobject.indexed)
					$string:="("+$field+" = :1)"
					$fieldcol.push($string)
				End if 
			End if 
		End for each 
		
		
		$querystring:=$fieldcol.join(" or ")
		Form.listbox:=$table.query($querystring; Form.query+"@")
	Else 
		$fieldname:=$ptr->{$ptr->}
		If ($fieldname#"-")
			$querystring:=$fieldname+" = :1"
			Form.listbox:=$table.query($querystring; Form.query+"@")
		End if 
	End if 
	
End if 