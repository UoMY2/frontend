extends CharacterBody2D

@export var speed : float = 300.0   #movement

#health
#@export var max_health : float = 90.0
#var health : float

#gun
@export var bullet_scn : PackedScene
@export var bullet_speed : float =  600.0 
@export var fps : float = 5.0
@export var dmg : float = 30.0
var fire_rate : float
var time_till_fire : float = 0.0

func _ready():
	#health = max_health
	fire_rate = 1 / fps
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	

func _process(delta: float) -> void:
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		look_at(get_global_mouse_position())
		$gun.look_at(get_viewport().get_mouse_position())
		var move_input : Vector2 = Input.get_vector("left", "right", "up", "down")
		velocity = move_input * speed
		move_and_slide()
		
		if Input.is_action_just_pressed("space") and time_till_fire > fire_rate:	
			fire.rpc()
		else:
			time_till_fire += delta

@rpc("any_peer", "call_local")
func fire():
		#if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
			var mouse = $gun.get_viewport().get_mouse_position()
			var direction = mouse - global_position
			var bullet : RigidBody2D = bullet_scn.instantiate()
			bullet.rotation = $gun.rotation
			bullet.global_position = $gun.global_position
			bullet.linear_velocity = direction.normalized() * bullet_speed
			get_tree().root.add_child(bullet)

			time_till_fire = 0.0
		
		
#func damage(damage : float) -> void:
	#health -= damage
	#
	#if health <= 0:
		#self.queue_free()
