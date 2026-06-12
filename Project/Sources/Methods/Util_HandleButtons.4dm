//%attributes = {"folder":"OldCode","lang":"en"}
var $entity : Object

$entity:=$1

OBJECT SET ENTERABLE(*; "@_FIELD_@"; Form.recordCanBeSaved)
OBJECT SET ENABLED(*; "@_FIELD_@"; Form.recordCanBeSaved)
OBJECT SET ENTERABLE(*; "_FIELD_Value_"; Form.settings.Display.enterInList & Form.recordCanBeSaved)
OBJECT SET VISIBLE(*; "@_ADDPIC_@"; Form.recordCanBeSaved)
OBJECT SET ENABLED(*; "@_SAVE_@"; Form.recordCanBeSaved)
OBJECT SET ENABLED(*; "@_RW_DELETE_@"; (Form.recordCanBeSaved & Not($entity.isNew())))
OBJECT SET ENABLED(*; "@_RW_CALL_@"; (Form.recordCanBeSaved | $entity.isNew()))

OBJECT SET ENABLED(*; "@_UNLOCK_@"; Not($entity.isNew()))
If (Form.recordCanBeSaved)
	If ($entity.isNew())
		OBJECT SET TITLE(*; "@_UNLOCK_@"; ":xliff:New")
	Else 
		OBJECT SET TITLE(*; "@_UNLOCK_@"; ":xliff:Lock")
	End if 
Else 
	OBJECT SET TITLE(*; "@_UNLOCK_@"; ":xliff:Unlock")
End if 
OBJECT SET DRAG AND DROP OPTIONS(*; "@_Picture_@"; True; True; Form.recordCanBeSaved; Form.recordCanBeSaved)  //draggable ; automaticDrag ; droppable ; automaticDrop )
For each ($object; Form.objectsNames)
	OBJECT SET VISIBLE(*; "@_LIST_DEL_"+$object; (Form["data_"+$object].length>0) & (Form["sel_"+$object].length>0))  //If at least a Property has been selected
End for each 
Case of   //For Forms displaying related entities
	: (Form.dataClassName="INVOICES")
		OBJECT SET VISIBLE(*; "@_LIST_DEL_INVOICE_LINES"; Form.recordCanBeSaved & (Form.sel_Lines_Fm_Invoices.length>0))  //If at least an Entity has been selected
End case 
OBJECT SET ENABLED(*; "@_LIST_@"; Form.recordCanBeSaved)  //
OBJECT SET ENABLED(*; "@_FRST_@"; ($entity.indexOf(Form.displayedSelection)>0) & Not($entity.isNew()))  //...if the Entity is the first one
OBJECT SET ENABLED(*; "@_LAST_@"; ($entity.indexOf(Form.displayedSelection)<(Form.displayedSelection.length-1)) & Not($entity.isNew()))  //...or the last one
If (Form.pictureName#"")
	OBJECT SET VISIBLE(*; "@_NOPIC_@"; (Picture size($entity[Form.pictureName])=0))
End if 
OBJECT SET VISIBLE(*; "@_NEWINV_@"; Form.editEntity.isNew())