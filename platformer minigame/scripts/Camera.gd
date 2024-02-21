extends Camera2D

@onready var end = $"../Flag".position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVar.stop == false:
		if position.x <= end.x -300:
			position.x = position.x + 3
