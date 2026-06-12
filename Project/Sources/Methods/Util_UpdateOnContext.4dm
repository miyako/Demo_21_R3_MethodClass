//%attributes = {"folder":"OldCode","lang":"en"}
var $currentEntity : Object

//We will set the Window Title according to the actual content and context
//...as well as Buttons

If (Count parameters>0)
	$actualPage:=$1
Else 
	$actualPage:=FORM Get current page
End if 
If (Form.selectedSubset=Null)
	$subset:=New object
Else 
	$subset:=Form.selectedSubset
End if 
If (Form.displayedSelection=Null)
	$selection:=Form.selectedSubset
Else 
	$selection:=Form.displayedSelection
End if 
If (Form.clickedEntity=Null)
	If (Form.editEntity#Null)
		$currentEntity:=Form.editEntity
	End if 
Else 
	$currentEntity:=Form.clickedEntity
End if 

Case of 
	: (Form.displayMode="PAGE")
		If ($currentEntity=Null)
			$display:=Form.dataClassName
		Else 
			$display:="ID "+$currentEntity.getKey(dk key as string)
			$display:=Form.dataClassName+" ("+Localized string("A_Record")+" "+$display+")"
		End if 
		SET WINDOW TITLE($display; Form.windowRef)
		
	: ($actualPage=1)
		Util_SetWindowTitle($selection; $subset; Form.dataClassName; $currentEntity; $actualPage; Current form window)
		
	: ($actualPage=2)
		Util_SetWindowTitle($selection; $subset; Form.dataClassName; Form.editEntity; $actualPage; Current form window)
		//We have to disable buttons depending on the entity position
		Util_HandleButtons(Form.editEntity)
		
End case 
//We have to disable buttons which make sense only if some lines are selected
OBJECT SET ENABLED(*; "@_SEL_@"; (Form.selectedSubset.length>0))


If (Form.editEntity#Null)  //Specific for each DataClass
	Case of 
		: (Form.dataClassName="INVOICES")  //Specific for Invoices
			$proforma:=Not(OB Is empty(Form.editEntity))
			If ($proforma)
				$proforma:=Form.editEntity.ProForma
			End if 
			OBJECT SET VISIBLE(*; "@_PROF_@"; $proforma)
			
	End case 
End if 