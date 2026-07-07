var $object : Text

$event:=Form event code

Case of 
	: ($event=On Load)
		//General
		Form.queryString:=""
		Form.inSelection:=False
		Form.dataClass:=ds.PRODUCTS
		Form.dataClassName:="PRODUCTS"  //To be replaced by :=$dataClass.getInfo().name  //The Table (DataClass) name
		Form.dataClassPtr:=->[PRODUCTS]  //To be replaced when it will be possible to get a pointer on a DataClass...
		Form.objectsNames:=New collection("Optional_Data")  //Names ob Object Fields containing Multiple Values
		
		//Page 1
		Form.qryPropertyList:=New collection
		Form.popupPtr:=OBJECT Get pointer(Object named; "_PROPERTIES_POPUP_")
		Util_GetSimplePropertyList(Form.popupPtr; Form.dataClass; Form.qryPropertyList; "COMPLETE")  //Creates the list of properties for the QuickSearch pop-up menu
		If (Form.displayMode="PAGE")
			Form.displayedSelection:=Form.openSelection
			Form.selectedSubset:=Form.openSubset
			Form.clickedEntity:=Form.openEntity
			Form.clickedEntityPosition:=0
		Else 
			Form.displayedSelection:=Form.dataClass.all()
			Form.selectedSubset:=Form.dataClass.newSelection()
			Form.clickedEntity:=New object
			Form.clickedEntityPosition:=0
		End if 
		//OBJECT SET RGB COLORS(*; "@Header@"; 0x00212121; 0x00E0E5EE)
		
		//Page 2
		Form.editEntity:=Form.clickedEntity
		Form.pictureName:="Picture"
		For each ($object; Form.objectsNames)
			Form["data_"+$object]:=New collection
			Form["cur_"+$object]:=New object
			Form["pos_"+$object]:=0
			Form["sel_"+$object]:=New collection
		End for each 
		Form.recordCanBeSaved:=False
		
		Settings_ApplyToListBox(Form.settings; "_LB_Optional_Data"; True)
		
	: ($event=On Close Box)
		Case of 
			: (FORM Get current page=1)
				CANCEL
				
			: (FORM Get current page=2)
				action_Cancel
		End case 
		
End case 

If (($event=On Load) | ($event=On Selection Change) | ($event=On Clicked) | ($event=On Drop) | ($event=On Data Change) | ($event=On After Edit))
	Util_UpdateOnContext
End if 

