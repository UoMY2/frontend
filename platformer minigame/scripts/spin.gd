extends CharacterBody2D

@export var speed = 0.03

func _process(delta):
	if GlobalVar.stop == false:
		rotation = rotation + speed
