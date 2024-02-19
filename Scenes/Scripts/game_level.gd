extends Node2D

#instantiate the characters
@onready var alien_scene = load("res://Players/alien.tscn")
@onready var astronaught_scene = load("res://Players/astronaught.tscn")
func _ready():
	#print("Current Scene:" + str(get_tree_string()))
	pass
		
func _process(_delta):
	var yourPos = null
	var data = null
	var player_instance = null
	if(Globalvar.add_player):
		var json = JSON.new()
		var err = json.parse(str(Globalvar.ship_init_data)) # Parse and validate JSON
		if err == OK: # If JSON is valid...
			data = json.data
			yourPos = Vector2(data["your_spawn"]["x"], data["your_spawn"]["y"])
			print(yourPos)
			 
		#insert logic to choose a character
		var team = EventLib.the_lobby.playerTeam[EventLib.the_lobby.search_player(EventLib.client_uname)][1]
		if team == 0:
			player_instance = alien_scene.instantiate().get_node(".")
		else:
			player_instance = astronaught_scene.instantiate().get_node(".")
			
		
		
		#give it a postion given by the server
		player_instance.position = yourPos 
		Globalvar.playerNodes.merge({"you":player_instance.get_instance_id()})
		# Set ID to the username for the player
		#print(player_instance.get_instance_id())
		
		#add camera to the player
		var camera = Camera2D.new()
		player_instance.add_child(camera)
		
		#add movement script to the player
		player_instance.set_script(load("res://Players/player.gd"))
		
		#add player interaciton script to the player
		var area2d = null
		if team == 0:
			area2d = player_instance.get_node("./Area2D")
			add_child(player_instance)
		else:
			area2d = player_instance.get_node("./Area2D")
			add_child(player_instance)
		area2d.set_script(load("res://Players/player_interaction.gd"))
		Globalvar.add_player = false
	if (Globalvar.add_remote_players):
		var peer_spawns = data["peer_spawns"]
		for player in peer_spawns.keys():
			var pos = Vector2(peer_spawns[player]["x"], peer_spawns[player]["y"])
			var team = EventLib.the_lobby.playerTeam[EventLib.the_lobby.search_player(player)][1]
			var area2d = null
			if team == 0:
				player_instance = alien_scene.instantiate().get_node(".")
				area2d = player_instance.get_node("./Area2D")
				player_instance.set_script(load("res://Players/player_remote.gd"))
				add_child(player_instance)
			else:
				player_instance = astronaught_scene.instantiate().get_node(".")
				area2d = player_instance.get_node("./Area2D")
				player_instance.set_script(load("res://Players/player_remote.gd"))
				add_child(player_instance)
			Globalvar.playerNodes.merge({player:player_instance.get_instance_id()})
			
		Globalvar.add_remote_players = false
			
			
			
			
