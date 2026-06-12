//%attributes = {"folder":"OldCode","lang":"en"}
var $displayedSelection; $zeProperty; $dataClass; $criteria : Object
var $property : Text
//Util_OrderSelection_ (Simple or Extended)

//This method provides an example of what could be a generic Sort Editor that you can modify and/or adapt to your own needs

var $pict : Picture
$indent:=Char(NBSP ASCII CODE)*2

$dataClass:=$1  //  The DataClass to sort
$displayedSelection:=$2  //  The Entity Selection of this DataClass to sort

$formData:=New object  //To prepare the data to use with the Generic_OrderBy Form

//We get the things that we will need (here the pictures of up and down arrows) but it can be Strings or any other data
$path:=Get 4D folder(Current resources folder)+"Images"+Folder separator+"4DIcons"+Folder separator
$formData.pictures:=New collection
READ PICTURE FILE($path+"ArrowUp.png"; $pict)
$formData.pictAsc:=$pict
READ PICTURE FILE($path+"ArrowDown.png"; $pict)
$formData.pictDesc:=$pict

$formData.zeDataClass:=$dataClass  //This is the  Table to sort

$formData.propertyList:=New collection  //We can also use $dataClass.keys() if we just need the names
$formData.propertySelected:=New object  //will be the current selected element in the propertyList
$formData.propertyPosition:=0  //will be the current selected element position in the propertyList (starting from 0)

//We make the list of the Entity Types accepted by Order by, in a Collection (much simpler than an array)
$colOK4Sort:=New collection("long"; "string"; "number"; "date"; "duration"; "bool"; "long64"; "float")
// Other types, like image, blob, or objects, cannot be use directly for sorting

$formData.pictures:=New object
Util_GetPropertyTypePictures($formData; $colOK4Sort; "SORT")

For each ($property; $formData.zeDataClass)  //For each property in the DataClass ($property is the property name)
	$zeProperty:=$formData.zeDataClass[$property]  //Access the property from it's name
	Case of 
		: ($zeProperty.kind="storage")
			If ($colOK4Sort.indexOf($zeProperty.type)>-1)  //We can use it for sorting
				$formData.propertyList.push(New object("name"; $zeProperty.name; "type"; $zeProperty.type; "localName"; Util_Get_LocalizedMessage($zeProperty.name)))
			End if 
			
		: ($zeProperty.kind="relatedEntities")
			
		: ($zeProperty.kind="relatedEntity")
			
		Else 
			
	End case 
End for each 

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
			
		Else   //  2nd way : much simpler, just .extract) the criteriaList into an usable collection
			$myOrderCol:=$formData.criteriaList.extract("name"; "propertyPath"; "criteriaDesc"; "descending")
		End if 
		
		//Then perform the Order by...
		$displayedSelection:=$displayedSelection.orderBy($myOrderCol)
		
	End if 
End if 

$0:=$displayedSelection

