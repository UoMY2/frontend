extends RigidBody2D

class_name Bird2
signal bird2_died

func _physics_process(delta):
	if Input.is_action_pressed("fly2"):
		linear_velocity = Vector2.UP*500
		angular_velocity = -3.0
	if rotation_degrees < -30:
		rotation_degrees = -30
		angular_velocity = 0
	if linear_velocity.y > 0.0:
		angular_velocity = 1.5

func bird2died():
	bird2_died.emit()
