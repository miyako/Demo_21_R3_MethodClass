var $0; $response : Object
var $1; $request : Object

$request:=$1  // Informations provided by mobile application
$response:=New object  // Informations returned to mobile application

// Check user email
If ($request.email=Null)
	// No email means Guest mode - Allow connection
	$response.success:=True
Else 
	// Authenticated mode - Allow or not the connection according to email or other device property
	$response.success:=True
End if 

// Optional message to display on mobile App.
If ($response.success)
	$response.statusText:="You are successfully authenticated"
Else 
	$response.statusText:="Sorry, you are not authorized to use this application."
End if 

$0:=$response