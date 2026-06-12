//%attributes = {"folder":"OldCode","lang":"en"}
var $colFound; $collection_Main; $collection_Sel : Collection
var $collection_Cur : Object
var $collection_Pos : Integer
var $LBName : Text

$LBName:=$1
//Instead of passing parameters like ;Form.data_Numbers;Form.cur_Numbers;Form.sel_Numbers;Form.pos_Numbers)...
//..We can get the different collections from the name of the Listbox
//For instance, if the name is _LB_Numbers, we can extract "Numbers", and then (thanks to the Bracket Notation)...
//..get the Collections themselves:

$fieldName:=Substring($LBName; Length("_LB_")+1)

$collection_Main:=Form["data_"+$fieldName]  //This is exactly the same than Form.data_Numbers or Form.data_Optional_Data
$collection_Cur:=Form["cur_"+$fieldName]
$collection_Sel:=Form["sel_"+$fieldName]
$collection_Pos:=Form["pos_"+$fieldName]

$event:=Form event code

If (($event=On Clicked) | ($event=On Double Clicked))
	
	$vAddMenu:=Create menu
	If (Form.recordCanBeSaved)
		APPEND MENU ITEM($vAddMenu; Localized string("Add Text"))
		SET MENU ITEM PARAMETER($vAddMenu; -1; "ADD_Text")
		APPEND MENU ITEM($vAddMenu; Localized string("Add Numeric"))
		SET MENU ITEM PARAMETER($vAddMenu; -1; "ADD_Num")
		APPEND MENU ITEM($vAddMenu; Localized string("Add Date"))
		SET MENU ITEM PARAMETER($vAddMenu; -1; "ADD_Date")
		APPEND MENU ITEM($vAddMenu; Localized string("Add Boolean"))
		SET MENU ITEM PARAMETER($vAddMenu; -1; "ADD_Bool")
		APPEND MENU ITEM($vAddMenu; Localized string("Add List"))
		SET MENU ITEM PARAMETER($vAddMenu; -1; "ADD_Col")
		If ($collection_Sel.length>0)
			APPEND MENU ITEM($vAddMenu; "-")
			APPEND MENU ITEM($vAddMenu; Util_Get_LocalizedMessage("Modify Property"; $collection_Cur.Property))
			SET MENU ITEM PARAMETER($vAddMenu; -1; "MOD")
		End if 
	Else 
		APPEND MENU ITEM($vAddMenu; Localized string("No_Click"))
		SET MENU ITEM PARAMETER($vAddMenu; -1; "NOCLICK")
		DISABLE MENU ITEM($vAddMenu; -1)
	End if 
	
	$choice:=Dynamic pop up menu($vAddMenu)  //Displays the popup menu
	RELEASE MENU($vAddMenu)  //Never forget to release every menus...
	
	If (($choice#"") & ($choice#"NOCLICK"))
		$form:=New object
		If ($choice="MOD")  //We want to modify the selected property
			$form.case:="MOD"
			$form.title:=Util_Get_LocalizedMessage("Modifying Property"; $collection_Cur.Property)
			$form.type:=Util_ConvertTypeToText($collection_Cur.Type)
			$form.propertyValueText:=""
			$form.propertyValueNum:=0
			$form.propertyValueDate:=Current date
			$form.propertyValueBool:=False
			$form.propertyValueCol:=""
			If ($form.type="Col")
				$form.propertyValueCol:=Replace string($collection_Cur.Value; ", "; ",")
				$form.propertyValueCol:=Replace string($form.propertyValueCol; ","; Char(Carriage return))
			Else 
				$form["propertyValue"+$form.type]:=$collection_Cur.Value
			End if 
			$form.propertyName:=$collection_Cur.Property
			
		Else   //We want to add a proprty
			$form.case:="ADD"
			$form.title:=Localized string("New Property")
			$form.type:=Replace string($choice; "ADD_"; "")
			$form.propertyValueText:=""
			$form.propertyValueNum:=0
			$form.propertyValueDate:=Current date
			$form.propertyValueBool:=False
			$form.propertyValueCol:=""
			$form.propertyName:=""
		End if 
		
		$w:=Open form window("Generic_EditProperty"; Sheet form window)
		DIALOG("Generic_EditProperty"; $form)
		CLOSE WINDOW($w)
		
		If (OK=1)
			If ($form.case="MOD")
				$newObject:=$collection_Cur
				$valueType:=$collection_Cur.Type
				$index:=$collection_Pos
			Else 
				$newObject:=New object
				$valueType:=Util_ConvertText2Type($form.type)
				$index:=-5
			End if 
			
			Case of 
				: ($form.type="Text")
					$newObject.Value:=$form.propertyValueText
				: ($form.type="Num")
					$newObject.Value:=$form.propertyValueNum
				: ($form.type="Date")
					$newObject.Value:=$form.propertyValueDate
				: ($form.type="Bool")
					$newObject.Value:=$form.propertyValueBool
				: ($form.type="Col")
					$text:=Replace string($form.propertyValueCol; ", "; ",")
					$text:=Replace string($text; Char(Carriage return); ",")
					$text:=Replace string($text; ","; ", ")
					$newObject.Value:=$text
			End case 
			$name:=Util_FilterPropertyName($form.propertyName)
			If ($form.case="ADD")
				Repeat 
					$colFound:=$collection_Main.indices("Property = :1"; $name)  //We search if the property name already exists
					If ($colFound.length=0)  //If it does't exist
						$flOK:=True
					Else   //It exists, we look if it's the same element
						$flOK:=($colFound[0]=$index)
					End if 
					If (Not($flOK))  //It exists, so we modify the name
						$name:=$name+"_"+String($index)
					End if 
				Until ($flOK)
			End if 
			$newObject.Property:=$name
			$newObject.Type:=Util_ConvertText2Type($form.type)
			If ($form.case="ADD")
				$collection_Main.push($newObject)
			End if 
		End if 
		$collection_Main:=$collection_Main
		Form["data_"+$fieldName]:=Form["data_"+$fieldName]
	End if 
End if 







