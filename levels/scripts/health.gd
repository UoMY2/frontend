extends Node2D


@export var max_health : float = 90.0
var hit : float

func _ready() -> void:
	hit = max_health
	

func damage(damage : float) -> void:
	hit -= damage


	if hit <= 0:
		get_parent().queue_free()

