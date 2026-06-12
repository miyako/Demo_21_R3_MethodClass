//%attributes = {"folder":"OldCode","lang":"en"}

//Thanks to Keisuke Miyako for this clever piece of code!

var $badge; $1 : Integer
var $icon; $0 : Picture

If (Count parameters>0)
	$badge:=$1
Else 
	$badge:=0
End if 

If ($badge<1)
	$badge:=1
End if 

$path:=Get 4D folder(Current resources folder)\
+"Images"+Folder separator\
+"DnD"+Folder separator\
+"drag.svg"

$dom:=DOM Parse XML source($path)

Case of 
	: ($badge>1)
		DOM SET XML ATTRIBUTE(DOM Find XML element by ID($dom; "icon"); "xlink:href"; "drag-multiple.png")
		DOM SET XML ELEMENT VALUE(DOM Find XML element by ID($dom; "badge-title"); String($badge; "&xml"))
		DOM SET XML ATTRIBUTE(DOM Find XML element by ID($dom; "badge"); "fill-opacity"; 1; "stroke-opacity"; 1)
End case 
SVG EXPORT TO PICTURE($dom; $icon; Own XML data source)

$0:=$icon