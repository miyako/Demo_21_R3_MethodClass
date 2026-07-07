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
			Form._update()
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
	
Function inputCodeEventHandler($formEventCode : Integer) : Integer
	
	Case of 
		: ($formEventCode=On Clicked) && (Contextual click)
			
			var $menu:=Create menu
			APPEND MENU ITEM($menu; "show"; *)
			SET MENU ITEM PARAMETER($menu; -1; "show-code")
			APPEND MENU ITEM($menu; "claude"; *)
			SET MENU ITEM PARAMETER($menu; -1; "launch-claude")
			APPEND MENU ITEM($menu; "-")
			APPEND MENU ITEM($menu; "clear"; *)
			SET MENU ITEM PARAMETER($menu; -1; "clear-code")
			
			var $command:=Dynamic pop up menu($menu)
			RELEASE MENU($menu)
			
			Case of 
				: ($command="")
				: ($command="launch-claude")
					This._claude()
				: ($command="show-code")
					This._show()
				: ($command="clear-code")
					This.btnClearEventHandler($formEventCode)
			End case 
			
		: ($formEventCode=On After Edit)
			
			This._update()
			
		: ($formEventCode=On Drag Over)
			
			var $path : Text
			$path:=Get file from pasteboard(1)
			
			If (Test path name($path)#Is a document)
				return -1
			End if 
			
			If (Not([".4dm"; ".txt"].includes(File($path; fk platform path).extension)))
				return -1
			End if 
			
			return 0
			
		: ($formEventCode=On Drop)
			
			$path:=Get file from pasteboard(1)
			OBJECT SET VALUE(OBJECT Get name; File($path; fk platform path).getText())
			This._update()
	End case 
	
	//MARK: - Form actions
	
Function _openFile()
	
	var $file : 4D.File
	var $name : Text
	var $dataFolder : Text
	
	//$dataFolder:=Folder(fk desktop folder).path
	$dataFolder:=System folder(Desktop)
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
	
	
Function _clear() : cs.FC_CodeRunner
	
	This.sourceCode:=""
	This.resultOutput:=""
	This.statusText:="Ready"
	
	return This
	
Function _update() : cs.FC_CodeRunner
	
	If (OBJECT Get name(Object with focus)="_CODE_INPUT_") && (FORM Event.code=On After Edit)
		$code:=Get edited text
	Else 
		$code:=OBJECT Get value("_CODE_INPUT_")
	End if 
	OBJECT SET ENABLED(*; "_BTN_CHECK_"; $code#"")
	OBJECT SET ENABLED(*; "_BTN_EXECUTE_"; $code#"")
	
	return This
	
Function _claude()
	
	SET TEXT TO PASTEBOARD(File("/RESOURCES/prompt.txt").getText())
	
	cs._CodeRunner.new().claude(File("/Users/miyako/.local/bin/claude"))
	
Function _show()
	
	METHOD OPEN PATH(METHOD Get path(Path class; "FC_CodeRunner"); 200)