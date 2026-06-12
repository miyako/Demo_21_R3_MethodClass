//%attributes = {"folder":"OldCode","lang":"en"}
var $status : Object

Form.editEntity:=Form.clickedEntity
Form.recordCanBeSaved:=False
$status:=Form.editEntity.lock()

Case of 
	: ($status.success)
		Form.recordCanBeSaved:=True
		
	: ($status.status=dk status locked)
		ALERT(Util_Get_LocalizedMessage("Record in use by"; $status.lockInfo.user_name))
		
		
		//All the following cases are here for information only, for it will happen only if you save an entity
	: ($status.status=dk status entity does not exist anymore)  //This case cannot happen with a new entity
	: ($status.status=dk status stamp has changed)  //Means that the record has been modified
	: ($status.success & $status.autoMerged)  //Saved & automerged
	: ($status.status=dk status automerge failed)  //Automerge failed,
	: ($status.status=dk status wrong permission)  //Nothing to do :-( You don't have the right to save it, period!
	: ($status.status=dk status serious error)
		
End case 
OBJECT SET ENTERABLE(*; "@_FIELD_@"; Form.recordCanBeSaved)
FORM GOTO PAGE(2)

