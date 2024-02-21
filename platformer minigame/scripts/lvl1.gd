extends Node2D

@export var player : PackedScene
func _ready():
	var currentPlayer = player.instantiate()
	add_child(currentPlayer)
	currentPlayer.position = $spawn.position
