//%attributes = {"lang":"en"}
$sel:=ds.CLIENTS.all()
For each ($editEntity; $sel)
	$editEntity.Total_Sales:=$editEntity.Invoice_List.sum("Total")
	$editEntity.save()
End for each 