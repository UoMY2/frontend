extends CharacterBody2D

@export var move_speed : float = 100

@export var starting_direction : Vector2 = Vector2(0,1)
@export var player_id : String
@export var pos_initial: Vector2
@export var pos_final: Vector2
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)
	EventLib.peer_movement.connect(_update_pos)
# Determine state of remote player.
func _process(_delta):
	pos_initial = position
	if pos_initial != pos_final:
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
# Change movement dir on pos update.		
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)
# Called when position update is sent from the server.
func _update_pos(data):
	var client_id = Globalvar.playerNodes[data["their_name"]]
	position = Vector2(data["x"],data["y"])
	pos_final = position
	var input_direction =  Vector2(
		data["x"] - pos_initial[0],
		data["y"] - pos_initial[1])
	update_animation_parameters(input_direction)
	
	move_and_slide()

