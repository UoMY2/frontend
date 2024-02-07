extends Node
class Lobby:
	var playerTeam:Array
	var lobbyId:String
	func _init(p, l):
		playerTeam = p
		lobbyId = l
	func search_player(name):
		for index in range(len(playerTeam)):
			print(len(playerTeam))
			if playerTeam[index][0] == name:
				return index
		push_error("[EventLib] Player {p} doesn't exist.".format({"p":name}))
		return -1
				
	func addPlayer(name, team):
		playerTeam.append([name, team, false])
	func removePlayer(name): # Find player and delete it.
		var index = search_player(name)
		if index !=-1:
			playerTeam.pop_at(index)
	func setReady (name, ready):
		var index = search_player(name)
		if index !=-1:
			playerTeam[search_player(name)][2] = ready
	func changeTeam (name):
		var index = search_player(name)
		if index !=-1: # Change team from 0 -> 1,or 1->0
			playerTeam[search_player(name)][1] = 1 - playerTeam[search_player(name)][1] 
		
	
	
var the_lobby = Lobby.new([],"") # Make new lobby object which is stored
var client_uname = "" # Used to idenify the client.


signal data_ready(the_data)  # A signal which is emited after a response is sent 
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
				"lobby_peer_team_change": _lobby_peer_team_change(data)
				"lobby_peer_left": _lobby_peer_left(data)      
				"lobby_peer_ready_change": _lobby_peer_ready_change(data)         
				"client_already_in_lobby_error": _client_already_in_lobby()
				"lobby_not_found": _lobby_not_found()
				"lobby_full": _lobby_full()
				_: return data # Default.
# ----------- LOBBY METHODS --------------------#

# ----------- CLIENT REQUEST METHODS -----------#		

func create_lobby(): # Send lobby create request to server.
	Server.socket.send_text(JSON.stringify({"type":"lobby_create"}))
	var response = await data_ready
	return response 

func join_lobby(code):
	Server.socket.send_text(JSON.stringify({"type":"lobby_join", "lobby_id":code}))
	var response = await data_ready 
	# Wait for response to be received and variables updated
	return response # Return class if sucessful, else return error.

func leave_lobby():
	Server.socket.send_text(JSON.stringify({"type":"lobby_bye"}))
	var the_lobby = Lobby.new([],"") # Overwrite old lobby object

func client_team_change():
	var new_team = 1 - the_lobby.playerTeam[the_lobby.search_player(client_uname)][1] 
	# Get client index in list and switch team from 0 -> 1 or 1 -> 0
	Server.socket.send_text(JSON.stringify({"type":"lobby_team_change", "team": new_team}))
	# Change team on the backend side.
	the_lobby.changeTeam(client_uname) 
	# Change team on the frontend side.
func client_ready_change(new_ready):
	Server.socket.send_text(JSON.stringify({"type": "lobby_ready_change","ready": new_ready}))
	the_lobby.setReady(client_uname, new_ready) # Update ready on the frontend.
	
	
# ----------- SERVER RESPONSE METHODS -----------#	
func _lobby_welcome(data): # Called when lobby_welcome response is recieved.
	# I.e. the user joins the lobby
	the_lobby.addPlayer(data["your_name"], data['your_team'])
	client_uname = data["your_name"] # Store the client's username.s
	# Add current player & lobby id to the_lobby object
	the_lobby.lobbyId = data["lobby_id"]
	if "peer_teams" in data.keys(): # Are other players already in lobby?
		for key in data["peer_teams"]:
			the_lobby.addPlayer(key, data["peer_teams"][key])
			# E.g. {"peer_teams": {{"user": 0}}} will add ["user",0, false] to
			# playerTeam.
	push_warning("[EventLib] Joined lobby with code: "+data["lobby_id"])
	data_ready.emit(the_lobby)
	# Emit the updated lobby class.

func _lobby_peer_joined(data): # Peer joined so add their name to the lobby obj
	the_lobby.addPlayer(data["their_name"],data["their_team"])

func _lobby_peer_team_change(data): # Peer joined so update their team stored in the lobby obj.
	the_lobby.changeTeam(data["their_name"])

func _lobby_peer_ready_change(data): # Peer changed ready so update ready in lobby obj.
	the_lobby.setReady(data["their_name"], data["ready"])
	
func _lobby_peer_left(data):  # Peer left, so  remove them from the lobby obj.
	the_lobby.removePlayer(data["their_name"],data["team"])

# Various error responses for the lobby
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

