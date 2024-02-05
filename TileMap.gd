extends TileMap

@onready var mole_scene = preload("res://moleminigame.tscn")

var xlist = [32,48,64,80,96,112,128,144,160,176,192]
var ylist=[148,212,276]
var used_positions = []
var moles = []
var molesup = [false,false,false,false,false,false,false,false,false,false]
var score=0



func _ready():
	 # Replace with the path to your Label node
	# Generate random mole locations
	for i in range(10):
		var x = xlist[randi() % xlist.size()]-4.5
		var y = ylist[randi() % ylist.size()]
		var mole_position = Vector2(x, y)
		while mole_position in used_positions:
			x = xlist[randi() % xlist.size()]-4.5
			y = ylist[randi() % ylist.size()]
			mole_position = Vector2(x, y)
		used_positions.append(mole_position)
		var mole = instance_mole(mole_position)
		moles.append(mole)
	
	
	while true:
		move_mole()
		showmole()
		await get_tree().create_timer(2.5).timeout
		move_down()
		showmole()
	


func instance_mole(mole_position):
	var mole = mole_scene.instantiate()
	add_child(mole)
	mole.position = mole_position
	return mole

func move_mole():
	for j in range(2):
		var i= randi_range(0,9)
		while molesup[i]:
			i= randi_range(0,9)
		moles[i].position.y = moles[i].position.y -15 - 100
		molesup[i]= true
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
	



