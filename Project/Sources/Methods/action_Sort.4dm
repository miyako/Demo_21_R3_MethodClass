//%attributes = {"folder":"OldCode","lang":"en"}
If (Macintosh option down)
	//If you want an extended method using the Table properties, objects fields, and related tables
	If (Form.displayedSelection=Null)
		Form.displayedSelection:=Util_OrderSelection_Extended(ds; Form.dataClass; Form.dataClass.newSelection(dk keep ordered))
	Else 
		Form.displayedSelection:=Util_OrderSelection_Extended(ds; Form.dataClass; Form.displayedSelection)
	End if 
	
Else 
	//If you want a simple method using only the Table properties
	Form.displayedSelection:=Util_OrderSelection_Simple(Form.dataClass; Form.displayedSelection)
	
End if 
