$event:=FORM Event
If ($event.code=On Header Click)
	If (Right click)
		$popup:="Delete Column;Add Formula;Save;Clear Saved;-;"
		$table:=Form.listbox.getDataClass()
		$ds:=$table.getDataStore()
		$tablename:=$table.getInfo().name
		
		// build list of missing fields...
		// first existing fields
		LISTBOX GET ARRAYS(*; $event.objectName; $arrSpaNamen; $arrKopfNamen; $arrSpaVars; $arrKopfVars; $arrSpaSichtbar; $arrStile)
		For each ($field; $table)
			$pos:=Find in array($arrSpaNamen; $field)
			If ($pos<0)
				$popup:=$popup+$field+";"
			End if 
		End for each 
		
		
		$select:=Pop up menu($popup)
		
		Case of 
			: ($select=1)
				LISTBOX DELETE COLUMN(*; $event.objectName; $event.column)
				
			: ($select=2)
				$formula:=Request("Formula (this.field)")
				If (OK=1)
					var $nullpointer : Pointer
					If ($formula="this.@")
						$title:=Substring($formula; 6)
					Else 
						$title:=$formula
					End if 
					LISTBOX INSERT COLUMN FORMULA(*; "List Box"; $event.column+1; $title; $formula; Is text; $title; $nullpointer)
					OBJECT SET TITLE(*; $title; $title)
				End if 
				
				
			: ($select=3)  // save
				$object:=New object("table"; $tablename)
				$col:=New collection
				LISTBOX GET ARRAYS(*; $event.objectName; $arrSpaNamen; $arrKopfNamen; $arrSpaVars; $arrKopfVars; $arrSpaSichtbar; $arrStile)
				For ($i; 1; Size of array($arrSpaNamen))
					$formula:=LISTBOX Get column formula(*; $arrSpaNamen{$i})
					$width:=LISTBOX Get column width(*; $arrSpaNamen{$i})
					$col.push(New object("pos"; $i; "formula"; $formula; "width"; $width; "title"; $arrKopfNamen{$i}))
				End for 
				$object.columns:=$col
				$created:=File("/PACKAGE/Databrowser/"+$tablename+".myPrefs").setText(JSON Stringify($object))
				
			: ($select=4)  // clear
				File("/PACKAGE/Databrowser/"+$tablename+".myPrefs").delete()
				
			: ($select>5)
				$col:=Split string($popup; ";")
				$title:=$col[$select-1]
				var $nullpointer : Pointer
				LISTBOX INSERT COLUMN FORMULA(*; "List Box"; $event.column+1; $title; "this."+$title; Is text; $title; $nullpointer)
				OBJECT SET TITLE(*; $title; $title)
		End case 
	End if 
End if 