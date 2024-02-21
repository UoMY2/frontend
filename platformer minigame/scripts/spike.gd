extends StaticBody2D

@onready var end = $"../Flag".position
var start = false

func _ready():
	await get_tree().create_timer(1).timeout
	start = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start == true:
		if GlobalVar.stop == false:
			if position.x <= end.x + 300:
				position.x = position.x + 3
