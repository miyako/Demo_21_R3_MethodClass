$line:=Find in array(lb_Criterias; True)
If ($line>0)
	LISTBOX DELETE ROWS(lb_Criterias; $line; 1)
	LISTBOX SELECT ROW(lb_Criterias; 0; lk remove from selection)
	qry_ar_Properties:=0
	If (Size of array(lb_Criterias)>0)
		If (qry_ar_Logicals{1}.valueType="text")
			qry_ar_Logicals{1}:=Form.blankCell
		End if 
	End if 
End if 
