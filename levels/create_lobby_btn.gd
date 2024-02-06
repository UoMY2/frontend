extends Control


@onready var lobby_scene = load("res://levels/lobby.tscn").instantiate()
@onready var itemList = lobby_scene.get_node("BlueTeamContainer/ItemListBlue")

#called when the node enters the scene tree for the first time
func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	pass

#runs when the button is pressed
func _on_pressed():
	print("creating lobby")
	#EventLib.create_lobby()
	
	var currentPlayerName = "Player1"
	#var currentTeam = 0           #team 0 is blue, team 1 is red
	Globalvar.blueArray.append(currentPlayerName)
	
	get_tree().change_scene_to_file("res://levels/lobby.tscn")
	pass #enter code to create a lobby 
	
