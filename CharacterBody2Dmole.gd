extends CharacterBody2D


var speed = 200

func _ready():
	# Hide the mole initially
	_hide()

func _physics_process(delta):
	move_and_slide()

func _on_CollisionShape2D_area_entered(area):
	# Show the mole when it is clicked
	_show()

func _hide():
	# Hide the mole by setting its position below the screen
	position.y = 1000

func _show():
	# Show the mole by setting its position on the screen
	position.y = 0

func _on_Mole_hidden():
	# Free the mole object from memory when it is hidden
	queue_free()
