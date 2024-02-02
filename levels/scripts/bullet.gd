extends RigidBody2D

@export var damage : float = 10.0
@export var speed = 600
var direction

func _ready() -> void:
	var timer : Timer = $Timer
	timer.connect("timeout", _on_timer_timeout)
	var direction = Vector2(1,0).rotated(rotation)
	
func _physics_process(delta):
	#var velocity = speed * direction
	pass

func OnBodyEntered(body : Node2D):
	if body.is_in_group("player"):
		
		body.get_node("health").damage(damage)
		queue_free()

	if body.is_in_group("wall"):
		queue_free()
		#
#func rebound(body : Node2D) -> void:
	#var bullet_scene : PackedScene = preload("res://scenes/character_body_2d.tscn")
	#
	## Instantiate the scene
	#var gun : Node = bullet_scene.
	#var temp : float = gun.bullet_speed
	#var velocity : Vector2
	#velocity.x = temp
	#velocity.y = temp
	##var normal : Vector2 = body.transform.x.normalized()
	##print("somwthinf")
	##var new_velocity : Vector2 = velocity - 2 * velocity.dot(normal) * normal 
	#var collision_info = move_and_collide(velocity)
	#if collision_info:
		#velocity = velocity.bounce(collision_info.normal)

	
	

func _on_timer_timeout() -> void:
	queue_free()
