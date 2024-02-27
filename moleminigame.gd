extends Node

# Declare the Timer variable
var timer : Timer

func _ready():

	pass


func _on_timer_timeout():
	queue_free()
	get_tree().quit()
	
func _process(delta):
	$TimeRemaining.text = "Timer: "+ ( "%s" % int($Timer.time_left))
