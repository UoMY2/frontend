extends Label


func _process(_delta):
	var time = $"../Timer".get_time_left()
	text = "Preparing Level\n       %01d" %time
