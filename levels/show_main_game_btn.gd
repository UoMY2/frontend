extends Control

#called when the node enters the scene tree for the first time
func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	pass

#runs when the button is pressed
func _on_pressed():
	# Transition to the game scene
	get_tree().change_scene_to_file("res://levels/game_level.tscn")
	pass
