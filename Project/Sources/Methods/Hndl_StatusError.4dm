//%attributes = {"folder":"OldCode","lang":"en"}
var $status : Object

$status:=$1

If ($status.success)
	$ok:=True
Else 
	$ok:=False
	If ($status.status=dk status serious error)
		ALERT(Util_Get_LocalizedMessage("followingProblem"; $status.statusText))
	Else 
		ALERT(Util_Get_LocalizedMessage("RecordIs"; $status.statusText; $status.lockKindText))
	End if 
End if 

$0:=$ok

//dk status locked, dk status stamp has changed, dk status success, dk status wrong permission