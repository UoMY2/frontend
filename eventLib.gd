extends Node
class Lobby:
	var playerTeam:Array
	var lobbyId:String
	var ready:bool
	func _init(p, l):
		playerTeam = p
		lobbyId = l
	func get_playerTeam():
		return playerTeam
	func get_lobbyId():
		return lobbyId
	func set_lobbyId(l):
		lobbyId = l
	func addPlayer(name, team):
		playerTeam.append([name, team, false])
var the_lobby = Lobby.new([],"") # Make new lobby object which is stored
signal data_ready(status)  # A signal which is emited after a response is sent 
# to the server and the data has been processed

static func test_function():
	print("Library has been imported sucessfully.")

func handle_response(request_string): # Takes in a JSON request and 
	# calls library specific functions accordingly
	var json = JSON.new()
	var err = json.parse(request_string) # Parse and validate JSON
	if err == OK: # If JSON is valid...
		var data = json.data
		if "type" in data.keys(): # Type is needed in the JSON request.
			match data["type"]: # Case statement matching different response types.
				"lobby_welcome": _lobby_welcome(data)
				"lobby_peer_joined": _lobby_peer_joined(data)                                                       
				"client_already_in_lobby_error": _client_already_in_lobby()
				"lobby_not_found": _lobby_not_found()
				"lobby_full": _lobby_full()
				_: return data # Default.

# ----------- SERVER REQUEST METHODS -----------#		
func create_lobby(): # Send lobby create request to server.
	Server.socket.send_text(JSON.stringify({"type":"lobby_create"}))
	var response = await data_ready
	return response 

func join_lobby(code):
	Server.socket.send_text(JSON.stringify({"type":"lobby_join", "lobby_id":code}))
	var response = await data_ready 
	# Wait for response to be received and variables updated
	return response # Return class if sucessful, else return error.
# ----------- SERVER RESPONSE METHODS -----------#	
func _lobby_welcome(data): # Called when lobby_welcome response is recieved.
	print(data)
	# I.e. the user joins the lobby
	the_lobby.addPlayer(data["your_name"], data['your_team'])
	# Add current player & lobby id to the_lobby object
	the_lobby.set_lobbyId(data["lobby_id"])
	if "peer_teams" in data.keys(): # Are other players already in lobby?
		for user in data["peer_teams"]: # peer_teams stores other players
			# and their respective teams
			the_lobby.addPlayer(user.keys(), user[user.keys()])
			# E.g. {"peer_teams": [{"user": 0}]} will add ["user",0, false] to
			# playerTeam.
	push_warning("[EventLib] Joined lobby with code: "+data["lobby_id"])
	print(the_lobby.get_playerTeam())
	data_ready.emit(the_lobby)
	# Emit the updated lobby class.

func _lobby_peer_joined(data):
	the_lobby.addPlayer(data["your_name"],data['your_team'])
	data_ready.emit(the_lobby)
	# Emit the updated lobby class.

func _client_already_in_lobby():
	data_ready.emit("client_already_in_lobby")
	push_warning("[EventLib] client_already_in_lobby")	
	# Emit error.
func _lobby_not_found():
	data_ready.emit("lobby_not_found")
	push_warning("[EventLib] lobby_not_found")		
func _lobby_full():
	data_ready.emit("lobby_full")
	push_warning("[EventLib] lobby_full")	
