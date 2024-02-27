extends Node2D

#instantiate the characters
@onready var alien_scene = load("res://Players/alien.tscn")
@onready var astronaught_scene = load("res://Players/astronaught.tscn")
@onready var light_texture = load("res://art/Textures/light.png")

var alienbar: ProgressBar
var timer = Timer.new()  # Create a new Timer instance
var time_label = Label.new()  # Create a new Label instance




func update_progress_bar(score,team,alienbar):
	alienbar.max_value += score
	
	if team =="alien":
		alienbar.value+=score

#func on_data(data):
	##print("game_level::on_data(" + str(data) + ")")
##
	#if !EventLib.is_valid_message(data):
		#print("not valid message: ", data)
		#return
#
	##if data["type"] == "ship_minigame_join":
		### For now, we don't use any of this information.
		##var flagID = data["flag_id"]
		##var _peerNames = data["peers"]
##
		##start_minigame(flagID)
		#
	#if data["type"] == "ship_minigame_join":
		### For now, we don't use any of this information.
		#var flagID = data["flag_id"]
		#var _peerNames = data["peers"]
##
		#start_minigame(flagID)

func _ready():
	#print("Current Scene:" + str(get_tree_string()))
	pass
		
func _process(_delta):
	var yourPos = null
	var data = null
	var player_instance = null
	if(Globalvar.add_player):
		EventLib.portal_ready_to_spawn.emit() # Portals need to spawn AFTER
		# the scene is added.
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
		
		#change name label
		var nameLbl = player_instance.get_node("nameLbl")
		nameLbl.text = EventLib.client_uname
		
		var PlayerSprite = player_instance.get_node("Sprite2D")
		
		#add progress bar for alien
		var alienbar = ProgressBar.new()
	
		PlayerSprite.add_child(alienbar)
	

		alienbar.show_percentage = false
		
		var stylebox_flat = StyleBoxFlat.new()
		
		var stylebox_flat1 = StyleBoxFlat.new()
		stylebox_flat.bg_color = Color(1, 0, 0) # Set the background color to red
		stylebox_flat1.bg_color = Color(0, 0, 1) # Set the border color to blue

		# Apply the StyleBoxFlat to the ProgressBar's fill
		alienbar.add_theme_stylebox_override("fill", stylebox_flat)
		
		alienbar.add_theme_stylebox_override("background", stylebox_flat1)
		

		alienbar.min_value = 0  # Set the minimum value for the progress bar
		alienbar.max_value = 0  # Set the maximum value for the progress bar
		alienbar.value = 0  # Set the initial value for the progress bar
		
		alienbar.position.y = PlayerSprite.position.y - 75
		alienbar.position.x = PlayerSprite.position.x - 50
		
		alienbar.size.x = 100
		alienbar.size.y = 10
	
		update_progress_bar(5,"alien",alienbar)
		update_progress_bar(2,"as",alienbar)

		
		#add player interaciton script to the player
		var area2d = player_instance.get_node("./Area2D")
		area2d.set_script(load("res://Players/player_interaction.gd"))
		
		add_child(player_instance)
		
		#add point light node onto player
		var lightNode = PointLight2D.new()
		player_instance.add_child(lightNode)
		
		lightNode.set_texture(light_texture)
		lightNode.set_texture_scale(5)
		lightNode.set("energy",0.3)
		lightNode.set("shadow_enabled",true)
		
		Globalvar.add_player = false
	if (Globalvar.add_remote_players):
		var peer_spawns = data["peer_spawns"]
		for player in peer_spawns.keys():
			var pos = Vector2(peer_spawns[player]["x"], peer_spawns[player]["y"])
			var team = EventLib.the_lobby.playerTeam[EventLib.the_lobby.search_player(player)][1]
			var player_name = EventLib.the_lobby.playerTeam[EventLib.the_lobby.search_player(player)][0]
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
			#player_instance.position = pos
			Globalvar.playerNodes.merge({player:player_instance.get_instance_id()})
			
			#change name label
			var nameLbl = player_instance.get_node("nameLbl")
			nameLbl.text = player_name
				
		Globalvar.add_remote_players = false
			


