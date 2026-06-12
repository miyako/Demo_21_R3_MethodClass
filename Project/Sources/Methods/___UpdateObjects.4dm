//%attributes = {"folder":"OldCode","lang":"en"}
var $entity; $selection; $subselection; $status; $line : Object

$selection:=ds.PRODUCTS.all()
ARRAY OBJECT($arObjects; 0)

If (False)
	For each ($entity; $selection)
		OB GET ARRAY($entity.Optional_Data; "Options"; $arObjects)
		If (Size of array($arObjects)>0)
			$colCase:=New collection
			$colDeco:=New collection
			$colExt:=New collection
			For ($i; 1; Size of array($arObjects))
				$colCase.push($arObjects{$i}.Case)
				$colDeco.push($arObjects{$i}.Deco)
				$colExt.push($arObjects{$i}.External_Deco)
			End for 
			OB REMOVE($entity.Optional_Data; "Options")
			$entity.Optional_Data.Deco:=$colDeco
			$entity.Optional_Data.Case:=$colCase
			$entity.Optional_Data.External_Deco:=$colExt
		End if 
		$status:=$entity.save()
	End for each 
	
End if 

If (False)
	$selection:=ds.CLIENTS.all()
	ARRAY OBJECT($arObjects; 0)
	
	For each ($entity; $selection)
		$entity.Numbers:=New object
		$entity.Numbers.Phone:=$entity.Phone
		$entity.Numbers.Mobile:=$entity.Mobile
		$entity.Numbers.Fax:=$entity.Fax
		
		$entity.eAddress:=New object
		$entity.eAddress.eMail:=$entity.Email
		$entity.eAddress.WebSite:=$entity.Web_Site
		
		$entity.Phone:=""
		$entity.Mobile:=""
		$entity.Fax:=""
		$entity.Email:=""
		$entity.Web_Site:=""
		
		$status:=$entity.save()
	End for each 
	
End if 

If (True)
	$selection:=ds.INVOICES.all()
	ARRAY OBJECT($arObjects; 0)
	
	For each ($entity; $selection)
		$subselection:=$entity.Lines_Fm_Invoices
		$index:=0
		For each ($line; $subselection)
			$index:=$index+1
			$line.Line_Number:=$index
			$status:=$line.save()
		End for each 
	End for each 
End if 




