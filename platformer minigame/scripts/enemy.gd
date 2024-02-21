extends CharacterBody2D

@export var speed:float = 2
@export var offset = 150
@onready var original = position.x
var left = false

func _process(delta):
	if GlobalVar.stop == false:
		#if left == true and position.x >= original - offset:
			#position.x = position.x - speed
		#else:
			#left = false
		#
		#if left == false and position.x <= original + offset :
			#position.x = position.x + speed
		#else:
			#left = true
			
		if speed > 0 and position.x >= original - offset:
			position.x -= speed
		elif speed > 0 and position.x <= (original- offset):
			speed = -speed
		if speed < 0 and position.x <= original + offset:
			position.x -= speed
		elif speed < 0 and position.x >= (original + offset):
			speed = -speed
