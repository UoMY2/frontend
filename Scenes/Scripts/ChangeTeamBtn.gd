extends Button

var player_position = 0

#called when the node enters the scene tree for the first time
func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	pass

#runs when the button is pressed
func _on_pressed():
	print("asdasdasd")
	find_player_pos()
	
	#unready the player
	Globalvar.remove_ready = true
	
	
	############################# update the server so the other players know they switched teams  ##############################
	
	await EventLib.client_team_change()
	
	pass
	
#find the player position in the array
func find_player_pos():
	for i in range(len(EventLib.the_lobby.playerTeam)):
		if(EventLib.the_lobby.playerTeam[i]!=[]):
			if(EventLib.the_lobby.playerTeam[i][0]==EventLib.client_uname):
				print("chaning position")
				player_position = i
