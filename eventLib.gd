extends Node

static func test_function():
	print("Library has been imported sucessfully.")

static func handle_response(request_string): # Takes in a JSON request and 
	# calls library specific functions accordingly
	var json = JSON.new()
	var err = json.parse(request_string) # Parse and validate JSON
	if err == OK: # If JSON is valid...
		var data = json.data
		if "type" in data.keys(): # Type is needed in the JSON request.
			match data["type"]: # Case statement matching different response types.
				"lobby_welcome": _lobby_welcome()
				"client_already_in_lobby_error": _client_already_in_lobby()
				_: print("Error") # Default.

# ----------- SERVER REQUEST METHODS -----------#		
static func create_lobby(): # Send lobby create request to server.
	Server.socket.send_text(JSON.stringify({"type":"lobby_create"}))

# ----------- SERVER RESPONSE METHODS -----------#	

static func _lobby_welcome(): # Called when lobby_welcome response is recieved.
	print("Welcome to the lobby")
static func _client_already_in_lobby():
	print("Client already in lobby")
	
