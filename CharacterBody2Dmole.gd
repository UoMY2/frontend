extends Node2D



var timer : Timer

func _process(delta):
	$TimerLabel.text = "Timer: "+ ( "%s" % int($Timer.time_left))


	
func _on_timer_timeout():
	queue_free()
	get_tree().quit()
