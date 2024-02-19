extends Control


@onready var itemListBlue = get_node("BlueTeamContainer/ItemListBlue")
@onready var itemListRed = get_node("RedTeamContainer/ItemListRed")
@onready var code_lbl = get_node("GameCode")

@onready var temp_server = Globalvar.serverObj

func _ready():
	EventLib.go_to_main.connect(_on_go_to_main)
	EventLib.update_player_tables.connect(_on_update_player_tables)
	EventLib.update_lobby_code.connect(_on_update_lobby_code)
	
	# Initial update
	_on_update_lobby_code()
	_on_update_player_tables()
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	pass
		
func _on_go_to_main(data):
	print("going to main game")
	
	#Add player into game (goes to game_level scene)
	Globalvar.add_player = true
	Globalvar.ship_init_data = data
	#add the rest of the players as remote players ie. different script and detach player interaction script
	Globalvar.add_remote_players = true
	############################################
	
	# Transition to the game scene
	get_tree().change_scene_to_file("res://Scenes/game_level.tscn")
	
func _on_update_lobby_code():
	code_lbl.text = (Globalvar.lobby_code)

func _on_update_player_tables():
	print("updating tables")
	itemListBlue.clear()
	itemListRed.clear()
	print("")
	for n in range(len(EventLib.the_lobby.playerTeam)):   #6 is the size of the player array
		if(EventLib.the_lobby.playerTeam[n]!=[]):
			print(EventLib.the_lobby.playerTeam)
			if(EventLib.the_lobby.playerTeam[n][1]==0):
				#on blue team
				if(EventLib.the_lobby.playerTeam[n][2]==false):
					#player ready
					itemListBlue.add_item(EventLib.the_lobby.playerTeam[n][0], null, false)
				else:
					#player ready
					itemListBlue.add_item(EventLib.the_lobby.playerTeam[n][0]+"(ready)", null, false)
			else:
				if(EventLib.the_lobby.playerTeam[n][2]==false):
					#player ready
					itemListRed.add_item(EventLib.the_lobby.playerTeam[n][0], null, false)
				else:
					#player ready
					itemListRed.add_item(EventLib.the_lobby.playerTeam[n][0]+"(ready)", null, false)
