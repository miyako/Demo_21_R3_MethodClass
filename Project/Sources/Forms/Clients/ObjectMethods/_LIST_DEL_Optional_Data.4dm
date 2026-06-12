
If (False)
	//This is the basic way of programming, by passing parameters
	action_Property_Delete_Tradit("_LB_Optional_Data"; Form.data_Optional_Data; Form.cur_Optional_Data; Form.sel_Optional_Data; Form.pos_Optional_Data)
Else 
	//...and this is a more flexible way, by passing as few parameters as possible, requiring only a good naming of variables and form objects:
	action_Property_Delete("_LB_Optional_Data")
End if 

