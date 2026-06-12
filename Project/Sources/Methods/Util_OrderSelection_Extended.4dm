//%attributes = {"folder":"OldCode","lang":"en"}
var $displayedSelection; $dataStore; $dataClass; $criteria : Object
//Util_OrderSelection_ (Simple or Extended)

//This method provides an example of what could be a generic Sort Editor that you can modify and/or adapt to your own needs


var $pict : Picture
$indent:=Char(NBSP ASCII CODE)*2  //Non-breakable Space for indentation

$dataStore:=$1
$dataClass:=$2  //  The DataClass to sort
$displayedSelection:=$3  //  The Entity Selection of this DataClass to sort

$formData:=New object  //To prepare the data to be used with the Generic_OrderBy Form

$formData.zeDataStore:=$dataStore
$formData.zeDataClass:=$dataClass  //This is the  Table to sort

$formData.propertyList:=New collection  //We can also use $dataClass.keys() if we just need the names
$formData.propertySelected:=New object  //will be the current selected element in the propertyList
$formData.propertyPosition:=0  //will be the current selected element position in the propertyList (starting from 0)

Util_GetPropertyList("SORT"; $formData; $displayedSelection)

$formData.criteriaList:=New collection
$formData.criteriaSelected:=New object
$formData.criteriaSelection:=New collection
$formData.criteriaPosition:=0
$formData.clipObject:=Null  //This object will be used by the Drag & Drop

$w:=Open form window("Generic_OrderBy"; Movable form dialog box; Horizontally centered; Vertically centered; *)

SET WINDOW TITLE(Util_Get_LocalizedMessage("Order_By"; Form.dataClassName); $w)  //To be replaced by $dataClass.getInfo().name

DIALOG("Generic_OrderBy"; $formData)

If (OK=1)
	If ($formData.criteriaList.length>0)
		
		//2 ways can be used to use the criteriaList and perform the Order by: 
		If (False)  //  1st way : If you have to add complex calculations :
			$myOrderCol:=New collection
			For each ($criteria; $formData.criteriaList)
				//Here you can do your complex calculations
				$myOrderCol.push(New object("propertyPath"; $criteria.name; "descending"; $criteria.criteriaDesc))
			End for each 
			
		Else   //  2nd way : much simpler, just .extract() the criteriaList into an usable collection
			$myOrderCol:=$formData.criteriaList.extract("name"; "propertyPath"; "criteriaDesc"; "descending")
		End if 
		
		//Then perform the Order by...
		$displayedSelection:=$displayedSelection.orderBy($myOrderCol)
		
	End if 
End if 

$0:=$displayedSelection




