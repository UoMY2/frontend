extends Control

var lvl = randi_range(1,4)
	
func _on_timer_timeout():
	if lvl == 1:
		get_tree().change_scene_to_file("res://scene/lvl1.tscn")
	elif lvl == 2:
		get_tree().change_scene_to_file("res://scene/lvl2.tscn")
	elif lvl == 3:
		get_tree().change_scene_to_file("res://scene/lvl3.tscn")
	elif lvl == 4:
		get_tree().change_scene_to_file("res://scene/lvl4.tscn")
