extends Node2D

#instantiate the characters
@onready var alien_scene = load("res://Players/alien.tscn")
@onready var astronaught_scene = load("res://Players/astronaught.tscn")
@onready var light_texture = load("res://art/Textures/light.png")
@onready var timer
@onready var font = load("res://Fonts/VT323_font/VT323-Regular.ttf")

var alienbar: ProgressBar
var time_label
var countdown_seconds = 600
var minutes
var seconds

## The current minigame scene, if there is one.
var _current_minigame: MinigameBase = null

## Maps each minigame ID to the path for the scene that implements the minigame.
##
## This should be treated as a constant.
var _minigame_scenes: Dictionary = {
	# All three demo variants use the same scene.
	"demo_minigame_sp": "res://Scenes/demo_minigame/demo.tscn",
	"demo_minigame_1v1": "res://Scenes/demo_minigame/demo.tscn",
	"demo_minigame_2v2": "res://Scenes/demo_minigame/demo.tscn",

	# The minigame IDs below are intentionally mapped to invalid paths so that attempting to start
	# them will cause a crash.

	"card_match_sp": "???",
	"whack_a_mole": "???",
}

## Maps flag IDs to the IDs for the minigames they represent.
##
## **This is a TEMPORARY solution ONLY. I have done this because I don't want to mess up too much
## frontend stuff, so I'm leaving it to someone else to decide how this mapping should be done at
## runtime.** - Alex
var _flag_minigames: Dictionary = {
	"flag0": "demo_minigame_1v1",
	"flag1": "demo_minigame_2v2",
	"flag2": "card_match_sp",
	"auto_win": "demo_minigame_sp",
}

func _ready():
	EventLib.data_ready.connect(_on_any_data)
	#var player_interaction = get_node("./Area2D")
	#player_interaction.display_instruction_text.connect(_on_display_instruction_text)

func update_progress_bar(score, team):
	if team == "alien":
		alienbar.max_value += score
		alienbar.value += score

	elif team == "human":
		alienbar.max_value += score

	if alienbar.max_value == 0:
		var stylebox_flat = StyleBoxFlat.new()
		var stylebox_flat1 = StyleBoxFlat.new()
		stylebox_flat.bg_color = Color(1, 1, 1)
		stylebox_flat1.bg_color = Color(1, 1, 1)
		#stylebox_flat.bg_color = Color(225,91,102) # Set the background color to red
		#stylebox_flat1.bg_color = Color(91, 110, 225) # Set the border color to blue

	else:
		var stylebox_flat = StyleBoxFlat.new()

		var stylebox_flat1 = StyleBoxFlat.new()
		stylebox_flat.bg_color = Color(225, 91, 102) # Set the background color to red
		stylebox_flat1.bg_color = Color(91, 110, 225) # Set the border color to blue

		# Apply the StyleBoxFlat to the ProgressBar's fill
		alienbar.add_theme_stylebox_override("fill", stylebox_flat)

		alienbar.add_theme_stylebox_override("background", stylebox_flat1)

		# Apply the StyleBoxFlat to the ProgressBar's fill
		alienbar.add_theme_stylebox_override("fill", stylebox_flat)

		alienbar.add_theme_stylebox_override("background", stylebox_flat1)

## == Managing minigame state ==

## Disables all processing for the ship scene and hides it from view.
func _pause_ship():
	propagate_call("set_process", [false])
	propagate_call("set_physics_process", [false])
	hide()

## Re-enables normal processing for the ship scene and shows it.
func _resume_ship():
	propagate_call("set_process", [true])
	propagate_call("set_physics_process", [true])
	show()

## Returns the camera attached to the local player.
func _player_camera() -> Camera2D:
	for node in get_node(EventLib.client_uname).get_children():
		if node is Camera2D:
			return node

	assert(false, "no player camera")

	# Unreachable
	return null

## Creates an instance of the minigame associated with the given flag ID and starts it. The
## minigame will be given `peerNames` so that it knows which other players are in the game.
##
## This method will panic if there is already an ongoing minigame.
func _enter_minigame_for_flag(flagID: String, peerNames: Array[String]):
	assert(!_in_minigame())

	# TEMPORARY ONLY - see comment above `_flag_minigames`.
	var minigameID = _flag_minigames[flagID]

	# Get the path to the scene for the minigame.
	var path = _minigame_scenes[minigameID]

	# Load the scene and set up the minigame.
	_current_minigame = load(path).instantiate()
	_current_minigame.init_peer_names(peerNames)

	# Add the scene so that the player can interact with the minigame.
	get_tree().root.add_child(_current_minigame)

	# Disable the player's camera so that the minigame is forced to use its own. We have to do this
	# because the camera attached to the player tracks their movement, which can create a confusing
	# offset in the rendering for the minigame.
	_player_camera().enabled = false

	# Disable processing for the ship, because we'll be in the background until the minigame ends.
	_pause_ship()

## Returns `true` if there is an ongoing minigame.
func _in_minigame() -> bool:
	return _current_minigame != null

## Removes the current minigame from the tree. Panics if there is no ongoing minigame.
func _exit_minigame():
	assert(_in_minigame())

	# Let the minigame do any cleanup.
	_current_minigame.on_minigame_end()

	# Re-enable the player's camera. (See `_enter_minigame_for_flag` for why we disabled it.)
	_player_camera().enabled = true

	# Hide the minigame.
	get_tree().root.remove_child(_current_minigame)

	# Make sure the resources are freed.
	_current_minigame.queue_free()

	# Zero the reference so that `_in_minigame` returns `false`.
	_current_minigame = null

	# Start updating the ship scene again.
	_resume_ship()

## == Specific message handling ==

## Called when a player disconnects from the server.
func _on_player_left(theirName: String):
	if _in_minigame():
		_current_minigame.on_player_left_ship(theirName)

	# todo: Remove the player from our local state.
	var player_node = get_node("/root/game_level/"+theirName)
	player_node.queue_free()
	
	####### switch scene to minigame?? #######
	pass

## Called when the server sends a `ship_welcome_back` message.
func _on_welcome_back(_msg: Dictionary):
	assert(_in_minigame())
	
	#spawn the local player
	var local_player = get_node("/root/game_level/"+EventLib.client_uname)
	local_player.position = Vector2(float(_msg["your_spawn"]["x"]),float(_msg["your_spawn"]["y"]))

	# todo: Use the data in `_msg` to update what's going on in the ship scene before we remove the
	# minigame scene.
	#print("length:"+str(_msg["peer_positions"].size()))
	
	for key in _msg["peer_positions"]:
		
		var current_player = get_node("/root/game_level/"+key)
		current_player.position = Vector2(float(_msg["peer_positions"][key]["x"]),float(_msg["peer_positions"][key]["y"]))
		################## current_player.show() ################## might not need these
	
	for key in _flag_minigames:
		var flag = get_node("/root/game_level/"+key)
		if(_msg["flag_states"].has(key)):
			if (_msg["flag_states"][key].has("capture_team")):
				var winning_team = _msg["flag_states"][key]["capture_team"]
				print("has winning team")
				var score_pb = Globalvar.flags_copy[key]["worth"]  #this is the score to add to the progress bar
				#print("score_pb:"+str(score_pb))
				if (winning_team == 1):
					#blue team won
					Globalvar.add_portal_tiles_gl.emit("blue", flag)
					#update the progress bar
					update_progress_bar(score_pb,"human")
					#### add the indiviual scores for each player ###
				else:
					#red team won
					Globalvar.add_portal_tiles_gl.emit("red", flag)
					update_progress_bar(score_pb,"alien")
				#start cooldown timer for the flag
				var cooldown_timer = flag.get_node("Timer")
				Globalvar.flag_cooldown_dict[key] = true  #make sure this minigame cannot be entered until cooldown has finished
				print(_msg)
				if(_msg["flag_states"][key].has("cooldown_left")):
					cooldown_timer.set("wait_time",_msg["flag_states"][key]["cooldown_left"])
					cooldown_timer.start()
				if(!cooldown_timer.timeout.is_connected(_stop_cooldown)):
					cooldown_timer.timeout.connect(_stop_cooldown.bind(key))
				
			elif(_msg["flag_states"][key].has("ongoing_players")):
				#ongoing players
				############### maybe add a new flag colour to show a game is ongoing ###############
				Globalvar.ongoing_players = _msg["flag_states"][key]["ongoing_players"]
				
			elif(_msg["flag_states"][key].has("locked_players")):
				#locked players
				Globalvar.locked_players = _msg["flag_states"][key]["locked_players"]
				############### store capture team?? ####################
		
		else:
			#no change, just spawn regular portal
			Globalvar.add_portal_tiles_gl.emit("purple", flag)
		
		
	_exit_minigame()

## Called when another player returns to the ship.
func _on_peer_welcome_back(_msg: Dictionary):
	assert(!_in_minigame())

	var player_rejoin = get_node("/root/game_level/"+_msg["their_name"])
	player_rejoin.position = Vector2(_msg["spawn"]["x"],_msg["spawn"]["y"])  #set remote player spawn
	player_rejoin.show() #show remote player

## Called when the local player is put into a minigame.
func _on_minigame_join(msg: Dictionary):
	var peerNames: Array[String] = []

	# Force the peer names array to an `Array[String]` (or crash if not possible).
	peerNames.assign(msg["peers"])

	_enter_minigame_for_flag(msg["flag_id"], peerNames)

## Called when another player enters a minigame.
func _on_peer_minigame_join(_msg: Dictionary):
	assert(!_in_minigame())

	# hide the player which just joined a minigame
	print(_msg["their_name"])
	var player = get_node("/root/game_level/"+_msg["their_name"])
	player.hide()
	
	pass

## Called when the server sends a message telling us how many seconds are left in the ship.
func _on_tick(_msg: Dictionary):
	assert(!_in_minigame())
	
	# todo: Handle game time update.
	var wait_time = _msg["seconds_left"]
	print(wait_time)
	var game_timer = get_node("/root/game_level/"+EventLib.client_uname+"/Sprite2D/game_timer")
	game_timer.start(wait_time)
	############### need to check if this actually works ###############

## Called when the local player is in the ship (that is, when they are *not* in a minigame
## themselves) and some other minigame ends.
func _on_other_minigame_finished(msg: Dictionary):
	assert(!_in_minigame())

	var flagID = msg["flag_id"]
	var portal = get_node("/root/game_level/"+flagID)
	if (msg.has("winning_team")):
		var winning_team = msg["winning_team"]
		print("has winning team")
		if (winning_team == 1):
			#blue team won
			Globalvar.add_portal_tiles_gl.emit("blue", portal)
		else:
			#red team won
			Globalvar.add_portal_tiles_gl.emit("red", portal)
	else:
		print("no winnign team")
		Globalvar.add_portal_tiles_gl.emit("purple", portal)

## Called when the server reports that there are no flags in reach of the player after they try to
## activate one.
func _on_no_flags_in_reach():
	# No assertion here in case the player has been moved into a (different) minigame since they
	# tried to activate the flag.

	# todo: Handle

	print("no flags nearby")

## Called when the server reports that the player is already locked to a flag when they try to
## activate one.
func _on_flag_player_locked():
	# No assertion, as above.
	# change label
	var pressFlbl = get_node("/root/game_level/"+EventLib.client_uname+"/pressFBtn")
	pressFlbl.text = "You are already queued up to another game"
	await get_tree().create_timer(3.0).timeout
	pressFlbl.text = "Press F to join game"
	pressFlbl.hide()
	
	print("you are already locked to a flag")

## Called when the server reports that the flag that was nearest the player is already owned by
## their team.
func _on_flag_already_captured(_flagID: String):
	# No assertion, as above.
	# change label
	var pressFlbl = get_node("/root/game_level/"+EventLib.client_uname+"/pressFBtn")
	pressFlbl.text = "Your team already own this flag"
	await get_tree().create_timer(3.0).timeout
	pressFlbl.text = "Press F to join game"
	pressFlbl.hide()

	print("your team already owns this flag")

## Called when the server reports that the flag nearest the player is already in use.
func _on_flag_already_in_use(_flagID: String):
	# No assertion, as above.
	# change label
	var pressFlbl = get_node("/root/game_level/"+EventLib.client_uname+"/pressFBtn")
	pressFlbl.text = "Players are already capturing this flag"
	await get_tree().create_timer(3.0).timeout
	pressFlbl.text = "Press F to join game"
	pressFlbl.hide()
	################# check if this actaully works ###############
	print("the nearest flag is already in use")

## Called when the server reports that the flag nearest the player is cooling down.
func _on_flag_cooling_down(_flagID: String):
	# No assertion, as above.
	# change label
	var pressFlbl = get_node("/root/game_level/"+EventLib.client_uname+"/pressFBtn")
	pressFlbl.text = "This flag is still cooling down"
	await get_tree().create_timer(3.0).timeout
	pressFlbl.text = "Press F to join game"
	pressFlbl.hide()

	print("the nearest flag is currently cooling down")

## Called when the server reports that the flag nearest the player is already active.
func _on_flag_already_activated(_flagID: String):
	# No assertion, as above.
	var pressFlbl = get_node("/root/game_level/"+EventLib.client_uname+"/pressFBtn")
	pressFlbl.text = "This flag has been activated by someone else"
	await get_tree().create_timer(3.0).timeout
	pressFlbl.text = "Press F to join game"
	pressFlbl.hide()

	print("someone has already activated the nearest flag")

## Called when the server reports an update to the time remaining for a flag's cooldown.
func _on_cooldown_tick(_msg: Dictionary):
	assert(!_in_minigame())
	
	# todo: Handle
	var cooldown_timer = get_node("/root/game_level/"+_msg["flag_id"]+"/Timer")
	cooldown_timer.start(_msg["time_left"])
	
	pass

## Called when the local player becomes locked to a flag.
func _on_local_player_lock_set(_flagID: String):
	assert(!_in_minigame())

	# todo: Handle
	var lockedLbl = get_node("/root/game_level/"+EventLib.client_uname+"/lockedLbl")
	lockedLbl.text = lockedLbl.text+_flagID
	lockedLbl.show()
	await get_tree().create_timer(3.0).timeout
	lockedLbl.hide()
	lockedLbl.text = "You've been queued up to play: "
	print("you have been locked to a flag")

## Called when a peer becomes locked to a flag.
func _on_peer_lock_set(_msg: Dictionary):
	assert(!_in_minigame())

	# todo: Handle
	############# could implement a list of players with locked status ###############
	pass
	
func _on_ship_endgame():
	#stop all players from entering minigames until current ongoing minigames finish
	pass
	
func _no_flags_in_endgame():
	#is displayed if players try to enter a minigame after the game has ended
	pass
	
func _on_game_end():
	#switch back to lobby temporarily to produce a full timeline in the game
	pass

## == End specific message handling ==

## Called when we receive some data from the event library.
func _on_any_data(data):
	assert(
		EventLib.is_valid_message(data),
		"ship expects only valid message data, but got " + str(data)
	)

	match data["type"]:
		"ship_peer_left":
			_on_player_left(data["their_name"])
			return

		"ship_welcome_back":
			_on_welcome_back(data)
			return

		"ship_welcome_back_peer":
			_on_peer_welcome_back(data)
			return

		"ship_minigame_finished":
			_on_other_minigame_finished(data)
			return

		"ship_minigame_join":
			_on_minigame_join(data)
			return

		"ship_peer_minigame_join":
			_on_peer_minigame_join(data)
			return

		"ship_tick":
			_on_tick(data)
			return

		"ship_no_flags_in_reach":
			_on_no_flags_in_reach()
			return

		"ship_player_locked":
			_on_flag_player_locked()
			return

		"ship_flag_already_captured":
			_on_flag_already_captured(data["flag_id"])
			return

		"ship_flag_in_use":
			_on_flag_already_in_use(data["flag_id"])
			return

		"ship_flag_cooling_down":
			_on_flag_cooling_down(data["flag_id"])
			return

		"ship_flag_already_activated":
			_on_flag_already_activated(data["flag_id"])
			return

		"ship_flag_cooldown_tick":
			_on_cooldown_tick(data)
			return

		"ship_player_lock_set":
			_on_local_player_lock_set(data["flag_id"])
			return

		"ship_peer_lock_set":
			_on_peer_lock_set(data)
			return
			
		"ship_no_flags_in_endgame":
			_no_flags_in_endgame()
			return
		
		"ship_endgame":
			_on_ship_endgame()
			return
			
		"ship_game_end":
			_on_game_end()
			return
	# Getting here is OK if we're in a minigame, because it probably just means that the message
	# is intended for the minigame and not us. But if we get here when we're not in a minigame,
	# it means the server has sent us a message that we're expected to understand but that we do
	# not. That's a fatal error.
	assert(_in_minigame(), "ship has no explicit handler for message " + str(data))

	var handled = _current_minigame.on_message(data)

	# We know the ship doesn't understand the message, so if the minigame didn't either then we've
	# got a serious issue.
	assert(handled, "minigame did not handle " + str(data))

func _process(_delta):
	var yourPos = null
	var data = null
	var player_instance = null

	if (Globalvar.add_player):
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
		Globalvar.playerNodes.merge({"you": player_instance.get_instance_id()})
		# Set ID to the username for the player
		#print(player_instance.get_instance_id())

		#add camera to the player
		var camera = Camera2D.new()
		player_instance.add_child(camera)
		#add movement script to the player
		player_instance.set_script(load("res://Players/player.gd"))
		player_instance.name = EventLib.client_uname

		#change name label
		var nameLbl = player_instance.get_node("nameLbl")
		nameLbl.text = EventLib.client_uname

		var PlayerSprite = player_instance.get_node("Sprite2D")

		#add progress bar for alien
		alienbar = ProgressBar.new()
		alienbar.name = "progress_bar"
		PlayerSprite.add_child(alienbar)
		

		alienbar.show_percentage = false

		var stylebox_flat = StyleBoxFlat.new()

		var stylebox_flat1 = StyleBoxFlat.new()
		stylebox_flat.bg_color = Color(1, 1, 1)
		stylebox_flat1.bg_color = Color(1, 1, 1)
		#stylebox_flat.bg_color = Color(225,91,102) # Set the background color to red
		#stylebox_flat1.bg_color = Color(91, 110, 225) # Set the border color to blue

		# Apply the StyleBoxFlat to the ProgressBar's fill
		alienbar.add_theme_stylebox_override("fill", stylebox_flat)

		alienbar.add_theme_stylebox_override("background", stylebox_flat1)

		alienbar.min_value = 0 # Set the minimum value for the progress bar
		alienbar.max_value = 0 # Set the maximum value for the progress bar
		alienbar.value = 0 # Set the initial value for the progress bar

		alienbar.position.y = PlayerSprite.position.y - 85
		alienbar.position.x = PlayerSprite.position.x - 50
		#alienbar.set("theme_override_colors/font_outline_color","000000")
		#alienbar.set("theme_override_constants/outline_size",2)

		alienbar.size.x = 100
		alienbar.size.y = 10

		update_progress_bar(0, "None") # Show white at the begining

		timer = Timer.new()
		timer.wait_time = 600
		timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
		timer.autostart = true
		timer.name = "game_timer"
		PlayerSprite.add_child(timer)

		time_label = Label.new()
		time_label.text = "600" # Initial displa"y for 10 minutes
		time_label.set("theme_override_fonts/font", font)
		time_label.set("theme_override_colors/font_outline_color", "000000")
		time_label.set("theme_override_colors/font_shadow_color", "000000")
		time_label.set("theme_override_constants/shadow_offset_y", 1)
		time_label.set("theme_override_constants/shadow_outline_size", 1)
		time_label.set("theme_override_constants/outline_size", 2)
		PlayerSprite.add_child(time_label)

		time_label.position.y = PlayerSprite.position.y - 90
		time_label.position.x = PlayerSprite.position.x - 10
		time_label.add_theme_font_size_override("font_size", 12)

		#add player interaciton script to the player
		var area2d = player_instance.get_node("./Area2D")
		area2d.set_script(load("res://Players/player_interaction.gd"))

		player_instance.name = EventLib.client_uname
		add_child(player_instance)

		#add point light node onto player
		var lightNode = PointLight2D.new()
		player_instance.add_child(lightNode)

		lightNode.set_texture(light_texture)
		lightNode.set_texture_scale(5)
		lightNode.set("energy", 0.2)
		lightNode.set("shadow_enabled", true)

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

			# To set the player's position we have to set both `position` and `new_position`. If we
			# just set `position`, the value of `new_position` will override it; if we just set
			# `new_position`, the remote player script will see that there is a difference between
			# `position` and `new_position` and infer that the player must have moved, so will turn
			# it to face the direction it "moved". Setting both prevents this.
			player_instance.position = pos
			player_instance.new_position = pos

			player_instance.name = EventLib.the_lobby.playerTeam[EventLib.the_lobby.search_player(player)][0]
			Globalvar.playerNodes.merge({player: player_instance.get_instance_id()})

			#change name label
			var nameLbl = player_instance.get_node("nameLbl")
			nameLbl.text = player_name

		Globalvar.add_remote_players = false

	#Update the timer
	if timer.time_left > 0:
		var minutes = int(timer.time_left) / 60
		var seconds = int(timer.time_left) % 60
		time_label.text = "%d:%02d" % [minutes, seconds]

	#Place a condition here to update the progress bar

func _on_Timer_timeout():
	#switch to leaderboard
	pass
	
func _stop_cooldown(flagID):
	Globalvar.flag_cooldown_dict[flagID] = false  #make sure this minigame can be entered
	
