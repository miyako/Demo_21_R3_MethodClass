Case of 
	: (FORM Event.code=On Load)
		ARRAY TEXT($tables; 0)
		For each ($table; ds)
			APPEND TO ARRAY($tables; $table)
		End for each 
		$ptr:=OBJECT Get pointer(Object named; "tablelist")
		COPY ARRAY($tables; $ptr->)
		$ptr->:=1
		
		Form.listbox:=ds[$tables{1}].all()
		Databrowser_SetListbox
		
		Databrowser_SetFieldPopup(ds[$tables{1}])
		
End case 