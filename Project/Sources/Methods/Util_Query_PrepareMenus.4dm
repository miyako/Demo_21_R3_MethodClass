//%attributes = {"folder":"OldCode","lang":"en"}
$col_menusItems:=New collection

$col_MenuText:=New collection  //  index 0
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsEqual"); "condition"; "T="))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsNotEqual"); "condition"; "T#"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextContains"); "condition"; "T[=]"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextDoesNotContain"); "condition"; "T[#]"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextStartsWith"); "condition"; "T=]"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextEndsWith"); "condition"; "T[="))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsBigger"); "condition"; "T>"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsBiggerOrEqual"); "condition"; "T>="))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsLower"); "condition"; "T<"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsLowerOrEqual"); "condition"; "T<="))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsEmpty"); "condition"; "T=0"))
$col_MenuText.push(New object("menu"; Localized string("criteria_TextIsNotEmpty"); "condition"; "T#0"))

$col_MenuNum:=New collection  //  index 1
$col_MenuNum.push(New object("menu"; Localized string("criteria_NumIsEqual"); "condition"; "N="))
$col_MenuNum.push(New object("menu"; Localized string("criteria_NumIsNotEqual"); "condition"; "N#"))
$col_MenuNum.push(New object("menu"; Localized string("criteria_NumIsBigger"); "condition"; "N>"))
$col_MenuNum.push(New object("menu"; Localized string("criteria_NumIsBiggerOrEqual"); "condition"; "N>="))
$col_MenuNum.push(New object("menu"; Localized string("criteria_NumIsLower"); "condition"; "N<"))
$col_MenuNum.push(New object("menu"; Localized string("criteria_NumIsLowerOrEqual"); "condition"; "N<="))

$col_MenuBool:=New collection  //  index 2
$col_MenuBool.push(New object("menu"; Localized string("criteria_BoolIsTrue"); "condition"; "B="; "value"; "none"))
$col_MenuBool.push(New object("menu"; Localized string("criteria_BoolIsFalse"); "condition"; "B#"; "value"; "none"))
$col_MenuBool.push(New object("menu"; Localized string("criteria_BoolIsUndefined"); "condition"; "B=?"; "value"; "none"))
$col_MenuBool.push(New object("menu"; Localized string("criteria_BoolIsNotUndefined"); "condition"; "B#?"; "value"; "none"))

$col_MenuDate:=New collection  //  index 3
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsEqual"); "condition"; "D="))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsNotEqual"); "condition"; "D#"))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsBigger"); "condition"; "D>"))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsBiggerOrEqual"); "condition"; "D>="))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsLower"); "condition"; "D<"))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsLowerOrEqual"); "condition"; "D<="))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsToday"); "condition"; "D=D"; "value"; "none"))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsTomorrow"); "condition"; "D=D+"; "value"; "none"))
$col_MenuDate.push(New object("menu"; Localized string("criteria_DateIsYesterday"); "condition"; "D=D-"; "value"; "none"))

$col_MenuPict:=New collection  //  index 4
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictIsEmpty"); "condition"; "I="; "value"; "none"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictIsNotEmpty"); "condition"; "I#"; "value"; "none"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictIsBigger"); "condition"; "I>"; "value"; "long"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictIsLower"); "condition"; "I<"; "value"; "long"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictContainsWords"); "condition"; "I=W"; "value"; "text"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictDoesNotContainWords"); "condition"; "I#W"; "value"; "text"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictIsUndefined"); "condition"; "I=?"; "value"; "none"))
$col_MenuPict.push(New object("menu"; Localized string("criteria_PictIsNotUndefined"); "condition"; "I#?"; "value"; "none"))

$col_MenuBlob:=New collection  //  index 5
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsNotEmpty"); "condition"; "O="; "value"; "none"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsEmpty"); "condition"; "O#"; "value"; "none"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsBigger"); "condition"; "O>"; "value"; "long"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsBiggerOrEqual"); "condition"; "O>="; "value"; "long"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsLower"); "condition"; "O<"; "value"; "long"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsLowerOrEqual"); "condition"; "O<="; "value"; "long"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_NumIsUndefined"); "condition"; "O=?"; "value"; "none"))
$col_MenuBlob.push(New object("menu"; Localized string("criteria_BlobIsNotUndefined"); "condition"; "O#?"; "value"; "none"))

$col_MenuProp:=New collection  //  index 6
$col_MenuProp.push(New object("menu"; Localized string("PropertyExists"); "condition"; "P="; "value"; "none"))
$col_MenuProp.push(New object("menu"; Localized string("PropertyNotExist"); "condition"; "P#"; "value"; "none"))

$col_MenuArray:=New collection  //  index 7
$col_MenuArray.push(New object("menu"; Localized string("criteria_TextContains"); "condition"; "T="))
$col_MenuArray.push(New object("menu"; Localized string("criteria_TextDoesNotContain"); "condition"; "T#"))
$col_MenuArray.push(New object("menu"; Localized string("PropertyExists"); "condition"; "P="; "value"; "none"))
$col_MenuArray.push(New object("menu"; Localized string("PropertyNotExist"); "condition"; "P#"; "value"; "none"))

$obj_MenuObj:=New object  //Not used rignt now
$obj_MenuObj.text:=Localized string("KindText")
$obj_MenuObj.num:=Localized string("KindNum")
$obj_MenuObj.Boolean:=Localized string("KindBoolean")
$obj_MenuObj.date:=Localized string("KindDate")
$obj_MenuObj.property:=Localized string("KindProperty")

$col_menusItems.push($col_MenuText).push($col_MenuNum).push($col_MenuBool).push($col_MenuDate).push($col_MenuPict).push($col_MenuBlob)
$col_menusItems.push($col_MenuProp).push($col_MenuArray).push($obj_MenuObj)

$0:=$col_menusItems

