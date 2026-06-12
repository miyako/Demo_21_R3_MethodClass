//%attributes = {"folder":"OldCode","lang":"en"}
var $dataStore; $dataClass; $criteria; $displayedSelection; $lineInfos : Object
var $inSelection : Boolean

//Util_Query_Extended

//This method provides an example of what could be a generic Query Editor that you can modify and/or adapt to your own needs


var $pict : Picture
$indent:=Char(NBSP ASCII CODE)*2

$dataStore:=$1
$dataClass:=$2  //  The DataClass to Query
$displayedSelection:=$3  //  The Entity Selection of this DataClass to sort (In case of QUERY SELECTION)
$inSelection:=$4  //True if the query has to be done inside the current selection

$formData:=New object  //To prepare the data to use with the Generic_Query Form

$formData.zeDataStore:=$dataStore
$formData.zeDataClass:=$dataClass  //This is the  Table search on

$formData.propertyList:=New collection  //We can also use $dataClass.keys() if we just need the names
$formData.propertySelected:=New object  //will be the current selected element in the propertyList
$formData.propertyPosition:=0  //will be the current selected element position in the propertyList (starting from 0)
$formData.ck_CurrentSel:=$inSelection

Util_GetPropertyList("QRY"; $formData; $dataClass.all())

$formData.criteriaList:=New collection
$formData.criteriaSelected:=New object
$formData.criteriaPosition:=0
$formData.clipObject:=Null  //This object will be used by the Drag & Drop
$formData.ck_CurrentSel:=False

$w:=Open form window("Generic_Query"; Movable form dialog box; Horizontally centered; Vertically centered; *)
SET WINDOW TITLE("Query "+Form.dataClassName+" with..."; $w)  //To be replaced by $dataClass.getInfo().name

DIALOG("Generic_Query"; $formData)

If (OK=1)
	If ($formData.criteriaList.length>0)
		
		$inSelection:=$formData.ck_CurrentSel
		
		$queryString:=""
		
		$queryParams:=New object
		$queryParams.queryPlan:=False
		$queryParams.queryPath:=False
		$queryParams.parameters:=New collection
		
		$index:=0
		$parmIndex:=0
		For each ($criteria; $formData.criteriaList)
			$index:=$index+1
			If ($index=1)  //First line
				
			Else 
				$queryString:=$queryString+" "+$criteria.logicalOperator+" "
			End if 
			$lineInfos:=$criteria.comparison
			$condition:=$criteria.condition
			$fl_AtBefore:="@"*Num(Position("["; $condition)>0)
			$fl_AtAfter:="@"*Num(Position("]"; $condition)>0)
			$linePrefix:=""
			$lineSuffix:=""
			$condition:=Replace string($condition; "["; "")
			$condition:=Substring(Replace string($condition; "]"; ""); 2)
			$fl_HasParm:=False
			Case of   // Analyse of special cases (See Util_Query_PrepareMenus method)
				: (Position("0"; $condition)>0)  //Text is empty or not
					$condition:=Replace string($condition; "0"; " ''")
					
				: (Position("?"; $condition)>0)  // is defined or not
					$condition:=Replace string($condition; "?"; " null")
					
				: (Position("W"; $condition)>0)  // contains keywords
					$condition:=Replace string($condition; "W"; " % ")
					$fl_HasParm:=True
					If ($condition="#W")  //  Doesn't contain KW -> Not(contains KW)
						$linePrefix:="not("
						$lineSuffix:=")"
					End if 
					
				: ($condition="=D@")  //Today
					$condition:="="
					$criteria.value:=Current date
					$fl_HasParm:=True
					Case of 
						: ($condition="=D+")  //Tomorrow
							$criteria.value:=Current date+1
						: ($condition="=D-")  //Yesterday
							$criteria.value:=Current date-1
					End case 
					
				: ($criteria.condition="B=")  //Booleans
					$condition:=" is true"
				: ($criteria.condition="B#")
					$condition:=" is false"
					
				: ($criteria.condition="P=")  //Properties
					If (($lineInfos.originalType="object") & ($criteria.propertyName#"@[]"))
						$criteria.propertyName:=$criteria.propertyName+"[]"
					End if 
					$condition:=" is not null"
				: ($criteria.condition="P#")
					If (($lineInfos.originalType="object") & ($criteria.propertyName#"@[]"))
						$criteria.propertyName:=$criteria.propertyName+"[]"
					End if 
					$condition:=" is null"
					
				: ($criteria.condition="T@")
					$criteria.value:=$fl_AtBefore+$criteria.value+$fl_AtAfter
					$fl_HasParm:=True
					
				Else 
					$fl_HasParm:=True
			End case 
			
			$queryString:=$queryString+$linePrefix+$criteria.propertyName+" "+$condition+" "
			If ($fl_HasParm)
				$parmIndex:=$parmIndex+1
				$queryString:=$queryString+":"+String($parmIndex)
				$queryParams.parameters.push($criteria.value)
			End if 
			
			$queryString:=$queryString+$lineSuffix
			
		End for each 
		
		If ($queryParams.queryPlan)
			$qryPlan:=Last query plan(Description in text format)
		End if 
		If ($queryParams.queryPath)
			$qryPath:=Last query path(Description in text format)
		End if 
		
		If ($inSelection)
			$displayedSelection:=$displayedSelection.query($queryString; $queryParams)
		Else 
			$displayedSelection:=$dataClass.query($queryString; $queryParams)
		End if 
		
	End if 
End if 

$0:=$displayedSelection




