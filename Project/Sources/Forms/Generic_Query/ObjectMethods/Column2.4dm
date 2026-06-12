var $index; $item : Integer
var $type : Text
$evt:=Form event code

Case of 
	: ($evt=On Data Change)
		$line:=OBJECT Get pointer(Object current)->
		$index:=qry_ar_Operators{$line}.qryIndex
		$type:=qry_ar_Operators{$line}.qryType
		$item:=qry_ar_Operators{$line}.requiredList.indexOf(qry_ar_Operators{$line}.value)
		qry_ar_Values{$line}:=Util_Query_SetCriteriaValueCell($index; $item; $type)
		
		//unitReference
		
End case 