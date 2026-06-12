//%attributes = {"folder":"OldCode","lang":"en"}
$listbox:=$1

If (Form.editEntity#Null)
	If (Not(OB Is empty(Form.editEntity)))
		$n:=Form.editEntity.indexOf(Form.displayedSelection)  //Find the position of the current selected entity 
		
		If ($n<1)
			LISTBOX SELECT ROW(*; $listbox; 0; lk remove from selection)  //Deselect every line
		Else 
			LISTBOX SELECT ROW(*; $listbox; $n+1; lk replace selection)  //Update the highlighted line
			OBJECT SET SCROLL POSITION(*; $listbox; $n+1; 1)  // displays 4th row of 2nd column of list box in the first position
		End if 
	End if 
End if 
