//%attributes = {"lang":"en"}
#DECLARE($step : Integer)

If (Count parameters=0)
	var $proc : Integer
	$proc:=New process(Current method name(); 0; Current method name(); 1)
Else 
	var $ref : Integer
	$ref:=Open form window("CodeRunner"; Plain form window; Horizontally centered; Vertically centered)
	SET MENU BAR(1)
	DIALOG("CodeRunner")
	CLOSE WINDOW($ref)
End if 
