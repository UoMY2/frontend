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
	#EventLib.create_lobby()       #create lobby library
	
	#add 1 player to the blue team for the initial lobby creation
	var currentPlayerName = "Player1"     #placeholder until the libraries can return a name
	Globalvar.playerArray[0]=(currentPlayerName)
	
	#update table
	Globalvar.update_tables = true
	
	#change scene
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	pass #enter code to create a lobby 
	
