$evt:=Form event code
Case of 
	: ($evt=On Clicked)
		$n:=Size of array(qry_ar_Properties)
		Form.criteriaList.clear()
		If ($n>0)
			For ($i; 1; $n)
				$criteria:=New object
				If (qry_ar_Logicals{$i}.valueType="text")
					$criteria.logicalOperator:=qry_ar_Logicals{$i}.value
				End if 
				$criteria.propertyName:=qry_ar_Properties{$i}
				$criteria.propertyLocalName:=qry_ar_PropertyName{$i}
				$criteria.comparison:=qry_ar_Operators{$i}
				$criteria.value:=qry_ar_Values{$i}.value
				$criteria.valueType:=qry_ar_Values{$i}.valueType
				$criteria.condition:=qry_ar_Values{$i}.condition
				Form.criteriaList.push($criteria)
			End for 
		End if 
End case 