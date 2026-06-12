$evt:=Form event code

Case of 
	: ($evt=On Drag Over)
		If (Form.clipObject=Null)
			$0:=-1
		End if 
		
	: ($evt=On Drop)
		If (Form.clipObject#Null)
			Util_Query_SetCriteriaLine(Form.clipObject)
		End if 
		
End case 