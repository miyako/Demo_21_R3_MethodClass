
If (False)
	//This is the basic way of programming, by passing parameters
	action_Property_Delete_Tradit("_LB_Numbers"; Form.data_Numbers; Form.cur_Numbers; Form.sel_Numbers; Form.pos_Numbers)
Else 
	//...and this is a more flexible way, by passing as few parameters as possible, requiring only a good naming of variables and form objects:
	action_Property_Delete("_LB_Numbers")
End if 


