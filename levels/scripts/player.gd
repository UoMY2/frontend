extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var vitality = 5
var dead = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var bullet :PackedScene

func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		if dead == false:
			if not is_on_floor():
				velocity.y += gravity * delta
			
			$GunRotation.look_at(get_viewport().get_mouse_position())
			update_health.rpc()
			if vitality <= 0:
				#var dead = multiplayer.get_unique_id()
				await get_tree().create_timer(0.01).timeout
				dead = true
				$Icon.visible = false
				$GunRotation/gun.visible = false
				$ProgressBar.visible = false
				#GameManager.death.append(dead)
				#queue_free()
			# Handle jump.
			if Input.is_action_just_pressed("up") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			if Input.is_action_just_pressed("shoot"):
				fire.rpc()
			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction = Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			move_and_slide()

@rpc("any_peer", "call_local")
func fire():
	var b = bullet.instantiate()
	b.global_position = $GunRotation/bulletSpawn.global_position
	b.rotation_degrees = $ GunRotation.rotation_degrees
	get_tree().root.add_child(b)

@rpc("any_peer", "call_local")
func update_health():
	var health = $ProgressBar
	health.value = vitality

func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet"):
		vitality -= 1
		body.queue_free()
		print("something")
