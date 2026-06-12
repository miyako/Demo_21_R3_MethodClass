//%attributes = {"folder":"OldCode","lang":"en"}

var $1; $pid : Integer
var $invoices : Object
If (Count parameters=0)
	
	For ($i; 1; 3)
		$pid:=Execute on server(Current method name; 0; "QUERYING ON SERVER "+String($i); 10)
	End for 
	
Else 
	
	For ($i; 1; 4000)
		$invoices:=ds.INVOICES.query("Total > :1"; Random/3000).orderBy("Tax desc, Creation_Date asc")
	End for 
	
End if 

