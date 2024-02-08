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
	find_player_pos()
	#change team of player
	if(Globalvar.serverObj.playerTeam[player_position][1] == 0):
		Globalvar.serverObj.playerTeam[player_position][1] = 1
	else:
		Globalvar.serverObj.playerTeam[player_position][1] = 0
	
	#update table
	Globalvar.update_tables = true
	#unready the player
	Globalvar.remove_ready = true
	
	
	############################# update the server so the other players know they switched teams  ##############################
	pass
	
#find the player position in the array
func find_player_pos():
	for i in range(len(Globalvar.serverObj.playerTeam)):
		if(Globalvar.serverObj.playerTeam[i]!=[]):
			if(Globalvar.serverObj.playerTeam[i][0]==EventLib.client_uname):
				print("chaning position")
				player_position = i
