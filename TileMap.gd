extends TileMap

@onready var mole_scene = preload("res://molecharacter.tscn")


var xlist = [27.5,43.5,59.5,75.5,91.5,107.5,123.5,139.5,155.5,171.5,187.5]
var ylist=[148,212,276]
var used_positions = []
var moles = []
var molesup = [false,false,false,false,false,false,false,false,false,false]
var score=0
var last_moles = []
var my_timer: Timer


func _ready():
	my_timer = $moletimer
	for i in range(10):
		var x = xlist[randi() % xlist.size()]
		var y = ylist[randi() % ylist.size()]
		var mole_position = Vector2(x, y)
		while mole_position in used_positions:
			x = xlist[randi() % xlist.size()]
			y = ylist[randi() % ylist.size()]
			mole_position = Vector2(x, y)
		used_positions.append(mole_position)
		var mole = instance_mole(mole_position)
		moles.append(mole)
	

	move_mole()

	showmole()
	
	my_timer.start()
	

	

func instance_mole(mole_position):
	var mole = mole_scene.instantiate()
	add_child(mole)
	mole.position = mole_position
	return mole

func move_mole():
	for j in range(2):
		var i= randi_range(0,9)
		while molesup[i] or (i in last_moles) :
			i= randi_range(0,9)
		moles[i].position.y = moles[i].position.y -15 - 100
		molesup[i]= true
	last_moles = []
	showmole()
	
		

func move_down():
	
	for j in range(2):
		var i = randi_range(0,9)
		while not molesup[i]:
			i= randi_range(0,9)
		moles[i].position.y = moles[i].position.y + 15 + 100
		molesup[i]=false
		showmole()
		
# This is in TileMap.gd


func mole_clicked(mole):
	my_timer.start()
	var score_label = get_node("Label") 
	print("Mole was clicked: ", mole)
	score = score +1
	score_label.text = str("Score: "+ str(score))
	move_down()
	move_mole()
	
func showmole():
	for i in range(10):
		if molesup[i]==false:
			moles[i].visible=false
		else:
			moles[i].visible=true
			last_moles.append(i)
	

func _on_moletimer_timeout():
	move_down()
	move_mole()
	my_timer.start()
