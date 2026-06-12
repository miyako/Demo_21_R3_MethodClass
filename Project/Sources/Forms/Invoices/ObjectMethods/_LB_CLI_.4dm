$event:=Form event code
Case of 
	: ($event=On Clicked)
		If (Form.cur_clientSelection#Null)
			Form.editEntity.Client_ID:=Form.cur_clientSelection.ID
			
			OBJECT SET VISIBLE(*; "@DNE_@"; True)
			OBJECT SET VISIBLE(*; "@_CLI_@"; False)
			Form.queryClient:=""
			GOTO OBJECT(*; "_FIELD_Invoice_Number_")
		End if 
		
End case 