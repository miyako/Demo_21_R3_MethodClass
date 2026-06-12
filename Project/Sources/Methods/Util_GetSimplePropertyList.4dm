//%attributes = {"folder":"OldCode","lang":"en"}
var $currentSelection; $zeProperty; $dataClass; $zeRelatedDataclass; $zeRelatedProperty; $object; $criteria : Object
var $property; $relatedProperty : Text
var $zePaths; $typeList : Collection

$popupPtr:=$1
$dataClass:=$2
$qryPropertyList:=$3
$case:=$4  //Can be COMPLETE or SIMPLE depending on what we need

//We make the list of the Entity Types accepted by Query in a Collection (much simpler than an array)
$colOK2Use:=New collection("long"; "string"; "number"; "date"; "duration"; "bool"; "long64"; "float"; "variant")
// Other types, like image, blob, or objects, cannot be use directly for searching

For each ($property; $dataClass)  //For each property in the DataClass ($property is the property name)
	If ($property#"_@")  //Until we have the getInfo() on Fields, I use the prefix the Field Name with "_" in order to know if it's supposed to be invisible...
		$zeProperty:=$dataClass[$property]  //Access the property from it's name
		Case of 
			: ($zeProperty.kind="storage")
				$x:=Type($zeProperty)
				Case of 
					: (($zeProperty.type="object") & ($case="COMPLETE"))  //If it's an object field, we will get the different contents
						//Until the member function .distinctPaths will be available, please use:
						
						$zePaths:=wrap_distinctPaths($dataClass.all(); $zeProperty.name)  //Equivalent to DISTINCT ATTRIBUTE PATHS
						
						//As soon as available, replace the line above by the following one:
						//$zePaths:=$currentSelection.distinctPaths($zeProperty.name)
						
						For each ($path; $zePaths)
							Case of 
								: ($path="@[]")
									$object:=$qryPropertyList.pop()  //Returns the last object while removing it
									$object.type:="object"
									//$qryPropertyList.push($object)  //Can also be written : $formData.propertyList[$formData.propertyList.length-1].type:="object"
									$qryPropertyList.push(New object("name"; $zeProperty.name+"."+$path; "type"; "array"; "localName"; Util_Get_LocalizedMessage($zeProperty.name)+"."+$path))
									
								: ($path="@.length")  //This the number of elements of an array
									//$qryPropertyList.push(New object("name";$zeProperty.name+"."+$path;"type";"long"))
									//Here you can define other exclusions if needed
									
								Else 
									$qryPropertyList.push(New object("name"; $zeProperty.name+"."+$path; "type"; "variant"; "localName"; Util_Get_LocalizedMessage($zeProperty.name)+"."+$path))
									//We use Variant for the type, for we can't know the type of an object's property
							End case 
						End for each 
						
					: ($colOK2Use.indexOf($zeProperty.type)>-1)  //We can use it for searching
						$qryPropertyList.push(New object("name"; $zeProperty.name; "type"; $zeProperty.type; "localName"; Util_Get_LocalizedMessage($zeProperty.name)))
						
					Else 
						
				End case 
				
			: ($zeProperty.kind="relatedEntities")  //do nothing in simple queries
				
			: (($zeProperty.kind="relatedEntity") & ($case="COMPLETE"))  //We are going to get the related One table's fields
				$zeRelatedDataclass:=ds[$zeProperty.relatedDataClass]
				For each ($relatedProperty; $zeRelatedDataclass)
					$zeRelatedProperty:=$zeRelatedDataclass[$relatedProperty]
					If ($zeRelatedProperty.kind="storage")
						If ($colOK2Use.indexOf($zeProperty.type)>-1)
							$qryPropertyList.push(New object("name"; $zeProperty.name+"."+$zeRelatedProperty.name; "type"; $zeRelatedProperty.type; "localName"; Util_Get_LocalizedMessage($zeProperty.name)+"."+Util_Get_LocalizedMessage($zeRelatedProperty.name)))
						End if 
					End if 
				End for each 
				
			Else 
				
		End case 
	End if 
End for each 

If ($qryPropertyList.length=0)
	DELETE FROM ARRAY($popupPtr->; 1; Size of array($popupPtr->))
Else 
	COLLECTION TO ARRAY($qryPropertyList; $popupPtr->; "localName")
	INSERT IN ARRAY($popupPtr->; 1; 2)
	$popupPtr->{1}:=Localized string("Anywhere")
	$popupPtr->{2}:="(-"
	$popupPtr->:=1
End if 