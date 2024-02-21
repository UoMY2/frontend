extends CharacterBody2D

@export var speed :float = 2
@onready var original = position.y
var up = true

func _process(delta):
	if GlobalVar.stop == false:
		if up == true and position.y >= original - 200:
			position.y -= speed
		else:
			up = false
		
		if up == false and position.y <= original + 200:
			position.y += speed
		else:
			up = true
