extends Control


#@onready 
#@onready var itemList = lobby_scene.get_node("BlueTeamContainer/ItemListBlue")

#called when the node enters the scene tree for the first time
func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	pass

#runs when the button is pressed
func _on_pressed():
	print("creating lobby")
	Globalvar.serverObj = await EventLib.create_lobby()       #create lobby library
	print(Globalvar.serverObj.playerTeam)
	var player_arr = Globalvar.serverObj.playerTeam
	Globalvar.lobby_code  = Globalvar.serverObj.lobbyId
	
	#add 1 player to the blue team for the initial lobby creation
	var currentPlayer = player_arr[0]     
	#Globalvar.playerArray[0]=(currentPlayer)
	#test players
	#Globalvar.serverObj.playerTeam.append(["test1",0,false])  
	#Globalvar.serverObj.playerTeam.append(["test2",0,false])
	#Globalvar.serverObj.playerTeam.append(["test3",1,false])
	#Globalvar.serverObj.playerTeam.append(["test4",1,false])
	#Globalvar.serverObj.playerTeam.append(["test5",1,false])
	EventLib.client_uname = currentPlayer[0]
	Globalvar.current_player_team = currentPlayer[1]
	Globalvar.current_player_ready = currentPlayer[2]
	
	#update table
	Globalvar.update_tables = true
	Globalvar.update_code = true
	
	#change scene
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	pass #enter code to create a lobby 
	
