## This script implements the frontend for the demo minigame. This minigame is won by the first
## player to move beyond a certain x coordinate. This frontend supports any number of peers.

# This line is extremely important. Without it, the ship will fail to load your minigame.
extends MinigameBase

## The number of units the local player can travel per second.
const MOVEMENT_SPEED: float = 100

# Note that these variables are left uninitialised until the server gives us the information we
# need for them.

## The node we use to represent the local player.
var localPlayer: ColorRect

## The position of the local player when we last reported their position to the server.
var lastReportedPosition: Vector2

## The nodes we use to represent the remote players. Keys are player names; values are `ColorRect`
## objects.
var remotePlayers: Dictionary

## The scenes we use for players from different teams. Team number should be used as index.
@onready var playerBaseScenes = [
	load("res://Scenes/demo_minigame/player_team0.tscn"),
	load("res://Scenes/demo_minigame/player_team1.tscn"),
]

## Creates and returns a new child node for a player on the given team.
func new_player(team: int) -> ColorRect:
	var player = playerBaseScenes[team].instantiate()

	add_child(player)

	return player

## Called when we receive a message telling us where the local player has been spawned.
func on_spawn(pos: Vector2):
	localPlayer = new_player(local_team())
	localPlayer.position = pos

	# The server already knows this position, so we don't need to report it.
	lastReportedPosition = pos

## Called when we receive a message telling us where a peer has been spawned.
func on_peer_spawn(theName: String, pos: Vector2):
	var remotePlayer = new_player(player_team(theName))
	remotePlayer.position = pos

	remotePlayers[theName] = remotePlayer

## Called when we receive a message telling us that a peer has changed position.
func on_position_change(theName: String, pos: Vector2):
	remotePlayers[theName].position = pos

## Returns the direction of movement input as a unit vector.
func input_direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down").normalized()

func _process(delta):
	var direction = input_direction()

	if direction == Vector2.ZERO:
		# Nothing to do.
		return

	localPlayer.position += direction * delta * MOVEMENT_SPEED

	# Tell the server.
	send_position_update(localPlayer.position)

## Sends a position update to the server.
func send_position_update(pos: Vector2):
	# Update the last reported position so we don't send another update until the position changes.
	lastReportedPosition = pos

	var serverPos = local_pos_to_server(pos)

	EventLib.message_send({
		"type": "demo_mov_position_update",
		"x": serverPos.x,
		"y": serverPos.y,
	})

## == Begin required functions ==
## You MUST implement these. See `Scenes/Scripts/minigame_base.gd` for more info on what each
## function should do.

func on_message(data: Dictionary) -> bool:
	match data["type"]:
		"demo_mov_spawn": on_spawn(
			server_pos_to_local(Vector2(data["x"], data["y"])),
		)

		"demo_mov_peer_spawn": on_peer_spawn(
			data["their_name"],
			server_pos_to_local(Vector2(data["x"], data["y"])),
		)

		"demo_mov_peer_position_update": on_position_change(
			data["their_name"],
			server_pos_to_local(Vector2(data["x"], data["y"])),
		)

		# We have to return `false` if we didn't handle the message.
		_: return false

	return true

func on_minigame_end():
	# In this method you should do anything that you need to do before your minigame ends. For
	# example, if we had something running in the background, we'd want to stop it.

	print("demo minigame is ending")

func on_peer_left(theirName: String):
	# Most minigames won't need to implement this method beyond `pass`, because the server will
	# automatically end the minigame when one of its participants leaves. (So there won't be much
	# time to tell the player what's happened before they get removed from the minigame anyway.)

	print("player '", theirName, "' (who was in this minigame) has disconnected")

## == End required functions ==

# For the following two methods, you might want to show the user a notification, because the game
# will not necessarily end immediately. (Here we just print, because this is just the demo
# minigame.)

func on_ship_endgame():
	print("ship is entering endgame state")

func on_non_peer_left(theirName: String):
	print("player '", theirName, "' (who was not in this minigame) has disconnected")

# The following pair of functions implement conversions to and from server coordinates. The server
# uses a system where `(0, 0)` is treated as the centre, rather than the top left corner (which is
# what Godot uses).

## Applies an offset to the given Godot position vector so that it fits in the server's coordinate
## system.
func server_pos_to_local(pos: Vector2) -> Vector2:
	return pos + get_viewport_rect().size / 2

## Applies an offset to the given server position vector so that it fits in Godot's coordinate
## system.
func local_pos_to_server(pos: Vector2) -> Vector2:
	return pos - get_viewport_rect().size / 2

# The following functions might be useful as methods on the Lobby class, but we'll just define them
# here for now.

## Returns the team number of the player with the given name.
func player_team(theName: String) -> int:
	# Based on code from `game_level.gd`.
	var index = EventLib.the_lobby.search_player(theName)
	return EventLib.the_lobby.playerTeam[index][1]

## Returns the team number of the local player.
func local_team() -> int:
	return player_team(EventLib.client_uname)
