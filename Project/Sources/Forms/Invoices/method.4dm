var $object : Text

$event:=Form event code

Case of 
	: ($event=On Load)
		//General
		Form.queryString:=""
		Form.inSelection:=False
		Form.dataClass:=ds.INVOICES
		Form.dataClassName:="INVOICES"  //To be replaced by :=$dataClass.getInfo().name  //The Table (DataClass) name
		Form.dataClassPtr:=->[INVOICES]  //To be replaced when it will be possible to get a pointer on a DataClass...
		Form.objectsNames:=New collection("")  //Names ob Object Fields containing Multiple Values
		Form.relatedDataClass:=ds.INVOICE_LINES
		
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
		OBJECT SET RGB COLORS(*; "@Header@"; 0x00212121; 0x00E0E5EE)
		
		//Page 2
		Form.editEntity:=Form.clickedEntity
		Form.pictureName:=""
		//Now we define the necessary elements for the Invoice_Lines included form
		Form.cur_Lines_Fm_Invoices:=New object
		Form.pos_Lines_Fm_Invoices:=0
		Form.sel_Lines_Fm_Invoices:=New collection
		Form.recordCanBeSaved:=False
		
		Settings_ApplyToListBox(Form.settings; "_LB_INVOICE_LINES")
		
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


