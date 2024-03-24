extends Node2D
@onready var car_scence = preload("res://car_character.tscn")

var startIsActive = false
var othercheckpointIsActive = true
var lapCount=-1
var car
var lap
var charscript

# Called when the node enters the scene tree for the first time.
func _ready():
	var car_position = 	Vector2(150, 290)
	var newcar = instance_car(car_position)
	car = newcar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lapCount >=3 and not car.stop:
		car.stop=true


func instance_car(car_position):
	var car = car_scence.instantiate()
	add_child(car)
	car.position = car_position
	return car



func _on_start_checkpoint_body_entered(body):
	if startIsActive:
		othercheckpointIsActive=!othercheckpointIsActive
		startIsActive = !startIsActive
		lapCount+=1
		lap =  car.get_child(2)
		lap.text = "Lap Count: " +str(lapCount) + str("/3")




func _on_start_checkpoint_2_body_entered(body):
	if othercheckpointIsActive:
		othercheckpointIsActive=!othercheckpointIsActive
		startIsActive = !startIsActive
		
