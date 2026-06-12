//%attributes = {"folder":"OldCode","lang":"en"}
var $objectPtr : Pointer
var $object1; $object2 : Object

$objectPtr:=$1
$name:=$2

$pos:=Position("("; $name)
If ($pos<1)
	$text:=$name
	$color:=""
Else 
	$text:=Substring($name; 1; $pos-2)
	$color:=Replace string(Replace string(Substring($name; $pos+1); "Deco:"; ""); ")"; "")
End if 

OB SET($object1; "Description"; $text)

$random:=((Random*100)\32767)+1
OB SET($object1; "Weight"; $random)

ARRAY TEXT($arColors; 16)
$arColors{1}:="White"
$arColors{2}:="Light grey"
$arColors{3}:="Dotted grey"
$arColors{4}:="Dark grey"
$arColors{5}:="Dotted black"
$arColors{6}:="Light blue"
$arColors{7}:="Dotted blue"
$arColors{8}:="Dark blue"
$arColors{9}:="Light orange"
$arColors{10}:="Dark orange"
$arColors{11}:="Orange"
$arColors{12}:="Purple"
$arColors{13}:="Magenta"
$arColors{14}:="Cyan"
$arColors{15}:="Crimson red"
$arColors{16}:="Sky blue"
ARRAY TEXT($arMaterial; 16)
$arMaterial{1}:="Silk"
$arMaterial{2}:="Leather"
$arMaterial{3}:="Velour"
$arMaterial{4}:="Corduroy"
$arMaterial{5}:="Velvet"
$arMaterial{6}:="Balsa wood"
$arMaterial{7}:="Mahogany"
$arMaterial{8}:="Steel"
$arMaterial{9}:="Aluminium"
$arMaterial{10}:="Silver"
$arMaterial{11}:="Gold"
$arMaterial{12}:="Plastic"
$arMaterial{13}:="Celluloid"
$arMaterial{14}:="Soft plastic"
$arMaterial{15}:="Lemon wood"
$arMaterial{16}:="Buckskin"
ARRAY TEXT($arPackaging; 8)
$arPackaging{1}:="Soft case"
$arPackaging{2}:="Hard case"
$arPackaging{3}:="Tube"
$arPackaging{4}:="Pocket"
$arPackaging{5}:="Sheath"
$arPackaging{6}:="Holder"
$arPackaging{7}:="Bag"
$arPackaging{8}:="None"
ARRAY TEXT($arDecos; 8)
$arDecos{1}:="Knot"
$arDecos{2}:="Line"
$arDecos{3}:="Stripes"
$arDecos{4}:="Ribbon"
$arDecos{5}:="Passepoil"
$arDecos{6}:="Lace"
$arDecos{7}:="Serpentine"
$arDecos{8}:="Bolduc"
ARRAY TEXT($arUnits; 4)
$arUnits{1}:="Cardboard box 12 units"
$arUnits{2}:="Cardboard box 144 units"
$arUnits{3}:="Wooden box 12 units"
$arUnits{4}:="Wooden box 144 units"

$random:=Random
ARRAY TEXT($arThisColors; 0)
If ($color#"")
	APPEND TO ARRAY($arThisColors; $color)
End if 
For ($i; 1; Size of array($arColors))
	If ($random ?? ($i-1))
		APPEND TO ARRAY($arThisColors; $arColors{$i})
	End if 
End for 
OB SET ARRAY($object1; "Colors"; $arThisColors)

ARRAY OBJECT($arObjects; 0)
$howMany:=($random%4)+1
ARRAY OBJECT($arObjects; $howMany)
For ($i; 1; $howMany)
	$random:=(Random%16)+1
	OB SET($arObjects{$i}; "Case"; $arMaterial{$random})
	$random:=(Random%8)+1
	OB SET($arObjects{$i}; "Deco"; $arPackaging{$random})
	$random:=(Random%16)+1
	$color:=$arColors{$random}
	$random:=(Random%8)+1
	OB SET($arObjects{$i}; "External_Deco"; $color+" "+$arDecos{$random})
End for 
OB SET ARRAY($object1; "Options"; $arObjects)

If ((Random%3)=0)
	OB SET($object1; "Sales_Unit"; $arUnits{(Random%4)+1})
End if 

$objectPtr->:=OB Copy($object1)

