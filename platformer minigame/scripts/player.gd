extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var gravity = 1000


func _physics_process(delta):
	if GlobalVar.stop == false:
	# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		if position.y >= 770 :
			print("dead")
			GlobalVar.stop = true
			queue_free()
			
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("obstacle"):
		GlobalVar.stop = true
		queue_free()

func _on_flag_body_entered(body):
	GlobalVar.stop = true
	print("win")
	pass # Replace with function body.
