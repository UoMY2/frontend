#this script defines what the banana does when the player interacts with it
extends Interactable

@onready var animation_tree = get_node("/root/game_level/Portal/AnimationTree")
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var state = 1
@onready var tilemap = get_node("/root/game_level/TileMap")

func interact(user: Node2D):
	state=state+1
	#user interacted with banana 
	print("go to random minigame")
	#need to specify who entered minigame with their ID
	
	#testing the state transitions
	if (state == 1):
		state_machine.travel("purple_portal_idle")
		tilemap.set_cell(0,Vector2i(0,8),0,Vector2i(4,1))    #this will be replaced with a for loop to change the tile around the portal posisiton after portal spawning has been implemented.
		tilemap.set_cell(0,Vector2i(1,8),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(-1,8),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(1,9),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(1,10),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(-1,9),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(-1,10),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(0,10),0,Vector2i(4,1))
		state=2
	elif (state ==2):
		state_machine.travel("red_portal_idle")
		tilemap.set_cell(0,Vector2i(0,8),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(1,8),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(-1,8),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(1,9),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(1,10),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(-1,9),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(-1,10),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(0,10),0,Vector2i(3,1))
		state=3
	else:
		state_machine.travel("blue_portal_idle")
		tilemap.set_cell(0,Vector2i(0,8),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(1,8),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(-1,8),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(1,9),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(1,10),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(-1,9),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(-1,10),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(0,10),0,Vector2i(5,1))
		state=1
	
#func stop_interaction(user: Node2D):  --- temporarily not in use as we figure out game logic
	#code for a stop interaction  --- temporarily not in use as we figure out game logic
