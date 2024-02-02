extends CharacterBody2D

@export var speed : float = 300.0

func _process(delta: float) -> void:
	# LookAt(get_global_mouse_position())
	var move_input : Vector2 = Input.get_vector("left2", "right2", "up2", "down2")

	velocity = move_input * speed

	move_and_slide()
