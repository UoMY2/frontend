extends RigidBody2D

# Movement parameters
var horizontal_speed = 200  # Adjust the horizontal speed to your liking
var vertical_speed = 200  # Adjust the vertical speed to your liking
var stop=false

func _ready():
	# Set the linear damping for smoother movement directly
	self.linear_damp = 5.0  # Adjust the damping to make the movement smoother

func _process(delta):
	var velocity = Vector2()
	if stop==false:
		# Handling left and right movement
		if Input.is_action_pressed("ui_right"):
			velocity.x += horizontal_speed
		if Input.is_action_pressed("ui_left"):
			velocity.x -= horizontal_speed

		# Handling up and down movement
		if Input.is_action_pressed("ui_down"):
			velocity.y += vertical_speed
		if Input.is_action_pressed("ui_up"):
			velocity.y -= vertical_speed

		# Apply the movement using move_and_collide
		var result = move_and_collide(velocity * delta)
		if result:
			set_linear_velocity(Vector2.ZERO)  # Stop the rigid body on collision

