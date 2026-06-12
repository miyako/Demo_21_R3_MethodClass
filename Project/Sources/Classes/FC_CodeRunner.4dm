property title : Text
property sourceCode : Text
property resultOutput : Text
property statusText : Text

Class constructor
	
	This.title:="Code Runner - 4D.Method"
	This.sourceCode:=""
	This.resultOutput:=""
	This.statusText:="Ready"
	
	
	//MARK: - Form & form objects event handlers
	
Function formEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Load)
			
		: ($formEventCode=On Unload)
			
	End case 
	
	
Function btnOpenFileEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Clicked)
			This._openFile()
	End case 
	
	
Function btnSaveFileEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Clicked)
			This._saveFile()
	End case 
	
	
Function btnCheckEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Clicked)
			This._checkSyntax()
	End case 
	
	
Function btnExecuteEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Clicked)
			This._execute()
	End case 
	
	
Function btnClearEventHandler($formEventCode : Integer)
	
	Case of 
		: ($formEventCode=On Clicked)
			This._clear()
	End case 
	
	
	//MARK: - Form actions
	
Function _openFile()
	
	var $file : 4D.File
	var $name : Text
	var $dataFolder : Text
	
	//$dataFolder:=Folder(fk desktop folder).path
	$dataFolder:=System folder(desktop)
	$name:=Select document($dataFolder; "*.4dm;*.txt"; "Select a 4D method file"; 0)
	
	If (OK=1)
		$file:=File(Document; fk platform path)
		If ($file.exists)
			This.sourceCode:=$file.getText("utf-8")
			This.statusText:="File loaded: "+$file.name
			This.resultOutput:=""
		Else 
			This.statusText:="File not found"
		End if 
	End if 
	
	
Function _saveFile()
	
	var $file : 4D.File
	var $docRef : Time
	
	If (This.sourceCode="")
		This.statusText:="No code to save"
		return 
	End if 
	
	$docRef:=Create document(""; "*.4dm;*.txt")
	
	If (OK=1)
		CLOSE DOCUMENT($docRef)
		$file:=File(Document; fk platform path)
		$file.setText(This.sourceCode; "utf-8")
		This.statusText:="File saved: "+$file.name
	End if 
	
	
Function _checkSyntax()
	
	var $method : 4D.Method
	var $check : Object
	var $errorText : Text
	
	If (This.sourceCode="")
		This.statusText:="No code to check"
		This.resultOutput:=""
		return 
	End if 
	
	$method:=4D.Method.new(This.sourceCode)
	$check:=$method.checkSyntax()
	
	If ($check.success)
		This.statusText:="Syntax OK"
		This.resultOutput:="No errors detected."
	Else 
		This.statusText:="Syntax errors found"
		$errorText:=""
		var $i : Integer
		For ($i; 0; $check.errors.length-1)
			$errorText:=$errorText+"Line "+String($check.errors[$i].lineNumber)+": "
			If ($check.errors[$i].isError)
				$errorText:=$errorText+"[ERROR] "
			Else 
				$errorText:=$errorText+"[WARNING] "
			End if 
			$errorText:=$errorText+$check.errors[$i].message+Char(13)
		End for 
		This.resultOutput:=$errorText
	End if 
	
	
Function _execute()
	
	var $method : 4D.Method
	var $check : Object
	var $result : Variant
	
	If (This.sourceCode="")
		This.statusText:="No code to execute"
		This.resultOutput:=""
		return 
	End if 
	
	$method:=4D.Method.new(This.sourceCode)
	$check:=$method.checkSyntax()
	
	If (Not($check.success))
		This.statusText:="Cannot execute: syntax errors"
		var $errorText : Text
		$errorText:=""
		var $i : Integer
		For ($i; 0; $check.errors.length-1)
			$errorText:=$errorText+"Line "+String($check.errors[$i].lineNumber)+": "
			If ($check.errors[$i].isError)
				$errorText:=$errorText+"[ERROR] "
			Else 
				$errorText:=$errorText+"[WARNING] "
			End if 
			$errorText:=$errorText+$check.errors[$i].message+Char(13)
		End for 
		This.resultOutput:=$errorText
		return 
	End if 
	
	This.statusText:="Executing..."
	
	$result:=$method.call(Null)
	
	If ($result#Null)
		This.resultOutput:="Return value: "+String($result)
	Else 
		This.resultOutput:="Execution completed (no return value)."
	End if 
	
	This.statusText:="Execution completed"
	
	
Function _clear()
	
	This.sourceCode:=""
	This.resultOutput:=""
	This.statusText:="Ready"
	