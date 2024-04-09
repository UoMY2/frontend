extends CanvasLayer

@onready var exit_button = %exitbutton




# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.pressed.connect(_on_exit_button_pressed)
	get_tree().paused = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_button_pressed():
	get_tree().quit()
