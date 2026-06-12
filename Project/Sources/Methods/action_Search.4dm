//%attributes = {"folder":"OldCode","lang":"en"}
Form.displayedSelection:=Util_Query_Extended(ds; Form.dataClass; Form.displayedSelection; Form.inSelection)
If (OK=1)
	Form.queryString:=""
End if 