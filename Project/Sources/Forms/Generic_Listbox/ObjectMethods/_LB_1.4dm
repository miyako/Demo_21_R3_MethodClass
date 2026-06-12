$event:=Form event code

Case of 
	: ($event=On Double Clicked)
		//action_Open 
		
	: (($event=On Begin Drag Over) | ($event=On Drag Over) | ($event=On Drop))
		//Action_DragNDrop ($event;Form.selectedSubset)
		
		
End case 