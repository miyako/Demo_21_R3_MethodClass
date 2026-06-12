If (Form.cur_Product#Null)
	Form.Product_ID:=Form.cur_Product.ID
	Form.Product_Reference:=Form.cur_Product.Reference
	Form.Product_Name:=Form.cur_Product.Name
	Form.Quantity:=0
	Form.Unit_Price:=Form.cur_Product.Sale_Price
	Form.Discount_Rate:=0
	Form.Tax_Rate:=Form.cur_Product.Tax_Rate
	Form.Total:=0
	Form.Total_Tax:=0
	
	OBJECT SET VISIBLE(*; "_PRODUCTLIST_"; False)
	GOTO OBJECT(*; "_PROP_Quantity_")
End if 
