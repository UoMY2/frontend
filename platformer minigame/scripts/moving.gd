extends CharacterBody2D

@export var speed:float = 2
@export var offset = 150
@onready var original = position.x
	
func _process(delta):
	if GlobalVar.stop == false:
		if speed > 0 and position.x >= original - offset:
			position.x -= speed
		elif speed > 0 and position.x <= (original- offset):
			speed = -speed
		if speed < 0 and position.x <= original + offset:
			position.x -= speed
		elif speed < 0 and position.x >= (original + offset):
			speed = -speed
