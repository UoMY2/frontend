extends Control


@onready var itemListBlue = get_node("BlueTeamContainer/ItemListBlue")
@onready var itemListRed = get_node("RedTeamContainer/ItemListRed")
@onready var code_lbl = get_node("GameCode")


@onready var temp_server = Globalvar.serverObj

func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	if(Globalvar.update_tables):
		update_tables()
	if(Globalvar.update_code):
		update_lobby_code()
		
	#print("waiting for update")
	var the_signal = await EventLib.data_ready
	#print("updated")
	Globalvar.update_tables = true
	Globalvar.update_code = true
	
	print("EventLib.player_ready:"+str(EventLib.player_ready))
	if(EventLib.player_ready==true):
		#get_tree().change_scene_to_file("res://Scenes/game_level.tscn")
		#generate a character for the player
		#var astronaught_instance = astronaunt.instantiate()
		#add_child(instance)
		
		############################################
		print("going to main game")
		
		#Add player into game (goes to game_level scene)
		Globalvar.add_player = true

		#add the rest of the players as remote players ie. different script and detach player interaction script
		Globalvar.add_remote_players = true
		############################################
		
		print("Current Scene:" + str(get_tree()))
		print("##################################")
		
		#if get_tree().current_scene.name == "res://Scenes/game_level.tscn":
		
			
		# Transition to the game scene
		get_tree().change_scene_to_file("res://Scenes/game_level.tscn")
		
		EventLib.player_ready=false
		
	pass
	
func update_lobby_code():
	code_lbl.text = (Globalvar.lobby_code)
	Globalvar.update_code = false

func update_tables():
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
	Globalvar.update_tables = false
