extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	wait_time= 5.1
	start()
	if timeout:
		print("Timeout!!!!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
