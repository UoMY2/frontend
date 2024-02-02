extends Node2D

@export var bullet_scn : PackedScene
@export var bullet_speed : float =  600.0 
@export var fps : float = 5.0
@export var dmg : float = 30.0

var fire_rate : float
var time_till_fire : float = 0.0


func _ready() -> void:
	fire_rate = 1 / fps
	


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space") and time_till_fire > fire_rate:	
		fire.rpc()
	else:
		time_till_fire += delta

@rpc("any_peer", "call_local")
func fire():
		var bullet : RigidBody2D = bullet_scn.instantiate()
		bullet.rotation = global_rotation
		bullet.global_position = global_position
		bullet.linear_velocity = bullet.transform.x.normalized() * bullet_speed
		
		get_tree().root.add_child(bullet)

		time_till_fire = 0.0





