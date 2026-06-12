//%attributes = {"folder":"OldCode","lang":"en"}
var $colFound; $selection_Main; $selection_Sel; $status : Object
var $selection_Cur : Object
var $selection_Pos : Integer
var $LBName : Text

$LBName:=$1  //Name of the Listbox
$relation:=$2  //Name of the Relational Attribute One-to-Many

$fieldName:=$relation

If (Form.recordCanBeSaved)
	$selection_Main:=Form.editEntity[$relation]  //returns Form.editEntity.Lines_Fm_Invoices
	$selection_Cur:=Form["cur_"+$fieldName]
	$selection_Sel:=Form["sel_"+$fieldName]
	$selection_Pos:=Form["pos_"+$fieldName]
	
	$event:=Form event code
	
	If (Right click | ($event=On Double Clicked))
		
		$vAddMenu:=Create menu
		If (Form.recordCanBeSaved)
			APPEND MENU ITEM($vAddMenu; Localized string("Add Line"))
			SET MENU ITEM PARAMETER($vAddMenu; -1; "ADD_Line")
			If ($selection_Sel.length>0)
				APPEND MENU ITEM($vAddMenu; "-")
				APPEND MENU ITEM($vAddMenu; Util_Get_LocalizedMessage("Modify Line"; String($selection_Cur.Line_Number)))
				SET MENU ITEM PARAMETER($vAddMenu; -1; "MOD")
			End if 
		Else 
			APPEND MENU ITEM($vAddMenu; Localized string("No_Click"))
			SET MENU ITEM PARAMETER($vAddMenu; -1; "NOCLICK")
			DISABLE MENU ITEM($vAddMenu; -1)
		End if 
		$choice:=Dynamic pop up menu($vAddMenu)  //Displays the popup menu
		RELEASE MENU($vAddMenu)  //Never forget to release every menus...
		
		If (($choice#"") & ($choice#"NOCLICK"))
			$form:=New object
			If ($choice="MOD")  //We want to modify the selected property
				$form.case:="MOD"
				$form.title:=Util_Get_LocalizedMessage("Modifying Line"; String($selection_Cur.Line_Number))
				$form.Line_Number:=$selection_Cur.Line_Number
				$form.Invoice_ID:=$selection_Cur.Invoice_ID
				$form.Product_ID:=$selection_Cur.Product_ID
				$form.Product_Reference:=$selection_Cur.Product.Reference
				$form.Product_Name:=$selection_Cur.Product.Name
				$form.Quantity:=$selection_Cur.Quantity
				$form.Unit_Price:=$selection_Cur.Unit_Price
				$form.Discount_Rate:=$selection_Cur.Discount_Rate
				$form.Tax_Rate:=$selection_Cur.Tax_Rate
				$form.Total:=$selection_Cur.Total
				$form.Total_Tax:=$selection_Cur.Total_Tax
				$form.Product_Picture:=$selection_Cur.Product.Picture
				
			Else   //We want to add a proprty
				$form.case:="ADD"
				$form.title:=Localized string("Adding Line")
				$form.Line_Number:=$selection_Main.max("Line_Number")+1
				$form.Invoice_ID:=Form.editEntity.ID
				$form.Product_ID:=0
				$form.Product_Reference:=""
				$form.Product_Name:=""
				$form.Quantity:=0
				$form.Unit_Price:=0
				$form.Discount_Rate:=0
				$form.Tax_Rate:=0
				$form.Total:=0
				$form.Total_Tax:=0
				var $pict : Picture
				$form.Product_Picture:=$pict
				
			End if 
			
			$w:=Open form window("Invoice_Lines"; Sheet form window)
			DIALOG("Invoice_Lines"; $form)
			CLOSE WINDOW($w)
			
			If (OK=1)
				If ($form.case="MOD")
					$entity:=$selection_Cur
					$index:=$selection_Pos
				Else 
					$entity:=Form.relatedDataClass.new()
					$entity.Line_Number:=$form.Line_Number
				End if 
				
				$entity.Invoice_ID:=$form.Invoice_ID
				$entity.Product_ID:=$form.Product_ID
				$entity.Product.Reference:=$form.Product_Reference
				$entity.Product.Name:=$form.Product_Name
				$entity.Quantity:=$form.Quantity
				$entity.Unit_Price:=$form.Unit_Price
				$entity.Discount_Rate:=$form.Discount_Rate
				$entity.Tax_Rate:=$form.Tax_Rate
				$entity.Total:=$form.Total
				$entity.Total_Tax:=$form.Total_Tax
				$status:=$entity.save()
				If ($status.success)
					If ($form.case="ADD")
						$selection_Main.add($entity)
					End if 
					Form.editEntity.reload()
					//$selection_Main.refresh()
				End if 
				Util_EntityLoad_Specific($form.case="ADD")
				
				$selection_Main:=Form.editEntity.Lines_Fm_Invoices
				
			Else   //This case should very unlikely happen, for the Record has been locked
				ALERT(Util_Get_LocalizedMessage("Recordnotbeensaved"; $status.statusText))
				
			End if 
		End if 
	End if 
	
End if 





