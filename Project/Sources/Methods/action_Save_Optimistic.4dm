//%attributes = {"folder":"OldCode","lang":"en"}
//This Method will save an Entity which has not been locked prior to modifications.
//Therefore, it uses Optimistic Locking

var $status; $entity; $dataClass; $entity2Save; $1; $2 : Object
var $attribute : Text
var $fl_IsNewRecord; $0 : Boolean

$entity:=$1
$dataClass:=$2

$saved_OK:=True

$fl_IsNewRecord:=$entity.isNew()  //A New Record cannot be locked, but others errors may occur...

$status:=$entity.save(dk auto merge)
Case of 
	: ($status.success)
		$status:=$entity.unlock()  //Just in case this method is called on a locked entity
		
	: ($status.success & $status.autoMerged)  //Saved & automerged : It means that the Entity has been modified, saved, then unlocked.
		$status:=$entity.unlock()  //Just in case this method is called on a locked entity
		BEEP
		ALERT(Util_Get_LocalizedMessage("RecordMerged"))
		
	: (($status.status=dk status automerge failed) | ($status.status=dk status stamp has changed))  //Automerge failed, or Stamp has changed
		//In both cases, you have to reload the Entity, and redo the modifications
		BEEP
		ALERT(Util_Get_LocalizedMessage("RecordNotMerged"))
		
	: ($status.status=dk status locked)  //This case should never happen in case of  Pessimistic Locking!
		ALERT(Util_Get_LocalizedMessage("Recordinusesaved"; $status.lockInfo.user_name)+Char(Carriage return)+Localized string("RetryOrCancel"))
		$saved_OK:=False
		
	: ($status.status=dk status entity does not exist anymore)  //This case may happen in case of Optimistic Locking!
		$entity2Save:=$dataClass.new()  // We can always save a new Entity
		For each ($attribute; $entity)  //We cannot use .clone(), for the copy will be too perfect ;-)
			$entity2Save[$attribute]:=$entity[$attribute]  //...so we duplicate every attributes.
		End for each 
		$entity2Save.save()  //And then we save it
		
	: ($status.status=dk status wrong permission)  //Nothing to do :-( You don't have the right to save it, period!
	: ($status.status=dk status serious error)
		ALERT(Util_Get_LocalizedMessage("Something strangesave"; $status.lockInfo.errors.text.join(Char(Carriage return))))
		
End case 

$0:=$saved_OK
