extends CharacterBody2D

@export var move_speed : float = 100

@export var starting_direction : Vector2 = Vector2(0,1)
@export var player_id : String
#@export var pos_initial: Vector2
@export var new_position: Vector2
#@export var pos_final: Vector2
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

func _ready():
	update_animation_parameters(starting_direction)
	EventLib.peer_movement.connect(_update_pos)
# Determine state of remote player.
func _process(_delta):
	if new_position == position:
		state_machine.travel("idle")
		
		return
	
	var moveDir = (new_position - position).normalized()
	
	animation_tree.set("parameters/walk/blend_position", moveDir)
	animation_tree.set("parameters/idle/blend_position", moveDir)
	
	state_machine.travel("walk")
	
	position = new_position
	
# Change movement dir on pos update.		
func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input)
# Called when position update is sent from the server.

func _update_pos(data):
	#var client_id = data["their_name"]
	print("remote player position:"+str(Vector2(data["x"],data["y"])))
	new_position = Vector2(data["x"],data["y"])
	

