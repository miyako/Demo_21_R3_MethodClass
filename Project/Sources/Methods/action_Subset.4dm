//%attributes = {"folder":"OldCode","lang":"en"}
If (Form.selectedSubset.length>0)
	Form.displayedSelection:=Form.selectedSubset
	Form.selectedSubset:=Form.dataClass.newSelection()
	Form.clickedEntity:=New object
	Form.clickedEntityPosition:=0
	Form.queryString:=""
End if 
