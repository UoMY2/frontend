extends Node2D

const SPEED: int = 500
@onready var score_area = %score_area
@onready var pipe_area = %pipe_area
@onready var timer = %Timer

var bird1: Bird1
var bird2: Bird2
# Called when the node enters the scene tree for the first time.
func _ready():
	pipe_area.body_entered.connect(_on_pipe_area_entered)
	score_area.body_exited.connect(_on_score_area_exited)
	timer.timeout.connect(_on_time_timeout)
	bird1 = get_tree().get_first_node_in_group("bird1")
	bird2 = get_tree().get_first_node_in_group("bird2")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= SPEED * delta
	pass

func _on_pipe_area_entered(body: Node2D):
	bird1.bird1died()
	bird2.bird2died()
	print("yeah")

func _on_score_area_exited(body: Node2D):
	print("damn")

func _on_time_timeout():
	queue_free()
