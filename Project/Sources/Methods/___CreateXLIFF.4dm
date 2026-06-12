//%attributes = {"folder":"OldCode","lang":"en"}
$text:=""
$cr:=Char(Carriage return)

For each ($dataClass; ds)
	$text:=$text+"<group resname=\"CLASS-"+$dataClass+"\">"+$cr
	
	
	For each ($property; ds[$dataClass])  //For each property in the DataClass ($property is the property name)
		$text:=$text+"<trans-unit resname=\""+$property+"\">"+$cr
		$text:=$text+"<source>"+$property+"</source>"+$cr
		$text:=$text+"<target>"+$property+"</target>"+$cr
		$text:=$text+"</trans-unit>"+$cr
		
	End for each 
	$text:=$text+"</group>"+$cr
	
End for each 
$docref:=Create document(""; ".txt")
CLOSE DOCUMENT($docref)
TEXT TO DOCUMENT(Document; $text; "UTF-8")
