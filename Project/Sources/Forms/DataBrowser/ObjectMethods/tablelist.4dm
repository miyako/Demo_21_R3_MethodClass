If (FORM Event.code=On Data Change)
	$ptr:=OBJECT Get pointer(Object current)
	If ($ptr->#0)
		$table:=Form.listbox.getDataClass()
		$ds:=$table.getDataStore()
		$tablename:=$ptr->{$ptr->}
		Form.listbox:=$ds[$tablename].all()
		$table:=$ds[$tablename]
		Databrowser_SetListbox
		
		Databrowser_SetFieldPopup($table)
	End if 
End if 