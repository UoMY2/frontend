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
	var obj = await EventLib.create_lobby()       #create lobby library
	print(obj)
	var player_arr = obj.playerTeam
	Globalvar.lobby_code  = obj.lobbyId
	
	#add 1 player to the blue team for the initial lobby creation
	var currentPlayer = player_arr[0]     
	Globalvar.playerArray[0]=(currentPlayer)
	#test players
	#Globalvar.playerArray[1]=["test1",0,false]    
	#Globalvar.playerArray[2]=["test2",0,false]
	#Globalvar.playerArray[3]=["test3",1,false]
	#Globalvar.playerArray[4]=["test4",1,false]
	#Globalvar.playerArray[5]=["test5",1,false]
	Globalvar.current_player_name = currentPlayer[0]
	Globalvar.current_player_team = currentPlayer[1]
	Globalvar.current_player_ready = currentPlayer[2]
	
	#update table
	Globalvar.update_tables = true
	Globalvar.update_code = true
	
	#change scene
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	pass #enter code to create a lobby 
	
