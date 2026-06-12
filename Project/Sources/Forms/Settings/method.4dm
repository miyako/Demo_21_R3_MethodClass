$event:=Form event code

Case of 
	: ($event=On Load)
		ARRAY TEXT(ar_TablesList; 0)
		Form.title:=Localized string("SETTINGS")
		
		Form.settings:=Settings_GetCurrent
		
		Form.popupPtr:=OBJECT Get pointer(Object named; "_TABLES_LIST_")
		APPEND TO ARRAY(Form.popupPtr->; Localized string("PRODUCTS"))
		APPEND TO ARRAY(Form.popupPtr->; Localized string("CLIENTS"))
		APPEND TO ARRAY(Form.popupPtr->; Localized string("INVOICES"))
		Form.popupPtr->:=1
		
		OBJECT SET RGB COLORS(*; "_COLOR_VIEW_"; 0x00DDDDDD; Form.settings.Display.AlternateColorRGB)
		OBJECT SET ENABLED(*; "_VALUE_BOOL_4"; False)
		
	Else 
		
		
End case 
OBJECT SET VISIBLE(*; "@_NOPIC_@"; Picture size(Form.settings.Company.Logo)<1)
OBJECT SET VISIBLE(*; "@_TABLE_@"; False)
$choice:=(Form.popupPtr)->
$selectedDataClass:=(Form.popupPtr)->{$choice}
OBJECT SET VISIBLE(*; "@_"+$selectedDataClass+"_@"; True)
