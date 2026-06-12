//%attributes = {"publishedWeb":true,"lang":"en"}
ARRAY TEXT($namearray; 0)
ARRAY TEXT($valuearray; 0)
WEB GET VARIABLES($namearray; $valuearray)
If (Size of array($namearray)>0)
	Case of 
		: ($namearray{1}="name")
			$sel:=ds.CLIENTS.query("Name=:1"; $valuearray{1})
		: ($namearray{1}="city")
			$sel:=ds.CLIENTS.query("City=:1"; $valuearray{1})
		Else 
			$sel:=ds.CLIENTS.newSelection()
	End case 
	$result:=$sel.toCollection(""; dk with primary key+dk with stamp)
End if 

$answer:=JSON Stringify($result)
WEB SEND TEXT($answer; "application/json")