Class constructor
	
Function escape($in : Text)->$out : Text
	
	$out:=$in
	
	var $i; $len : Integer
	
	Case of 
		: (Is Windows)
			
/*
argument escape for cmd.exe; other programs may be incompatible
*/
			
			$shoudQuote:=False
			
			$metacharacters:="&|<>()%^\" "
			
			$len:=Length($metacharacters)
			
			For ($i; 1; $len)
				$metacharacter:=Substring($metacharacters; $i; 1)
				$shoudQuote:=$shoudQuote | (Position($metacharacter; $out; *)#0)
				If ($shoudQuote)
					$i:=$len
				End if 
			End for 
			
			If ($shoudQuote)
				If (Substring($out; Length($out))="\\")
					$out:="\""+$out+"\\\""
				Else 
					$out:="\""+$out+"\""
				End if 
			End if 
			
		: (Is macOS)
			
/*
argument escape for bash or zsh; other programs may be incompatible
*/
			
			$metacharacters:="\\!\"#$%&'()=~|<>?;*`[] "
			
			For ($i; 1; Length($metacharacters))
				$metacharacter:=Substring($metacharacters; $i; 1)
				$out:=Replace string($out; $metacharacter; "\\"+$metacharacter; *)
			End for 
			
	End case 
	
Function quote($in : Text)->$out : Text
	
	$out:="\""+$in+"\""
	
Function _chmod($file : 4D.File)
	
	If ($file=Null) || (Not(OB Instance of($file; 4D.File))) || (Not($file.exists))
		return 
	End if 
	
	If (Is macOS)
		SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY"; $file.parent.platformPath)
		SET ENVIRONMENT VARIABLE("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "true")
		LAUNCH EXTERNAL PROCESS("chmod +x "+This.escape($file.fullName))
	End if 
	
Function claude($claude : 4D.File)
	
	If ($claude=Null) || (Not(OB Instance of($claude; 4D.File))) || (Not($claude.exists))
		return 
	End if 
	
	var $folder : 4D.Folder
	$folder:=Folder("/PACKAGE/")
	$folder:=OB Class($folder).new($folder.platformPath; fk platform path)
	
	If (Is macOS)
		
		SET ENVIRONMENT VARIABLE("ANTHROPIC_API_KEY"; Try(cs.AIKit.OpenAIProviders.new().get("Anthropic").apiKey))
		SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY"; $folder.platformPath)
		$command:="cd "+This.escape($folder.path)+"\n"
		
		$folder:=Folder(Temporary folder; fk platform path).folder(Generate UUID)
		//$folder:=Folder(fk desktop folder)
		$folder.create()
		
		$command+="claude\n"
		$command:="/usr/bin/osascript"+" -e 'tell application \"Terminal\" to activate\r' -e 'tell application \"Terminal\" to do script \""+Replace string($command; "\\"; "\\\\"; *)+"\"'"
		
		$file:=$folder.file("claude.sh")
		$file.setText($command; "utf-8-no-bom")
		
		This._chmod($file)
		
		var $in; $out; $err : Text
		$in:=This.escape($file.path)
		
		LAUNCH EXTERNAL PROCESS("/bin/zsh"; $in; $out; $err)
		
	End if 
	