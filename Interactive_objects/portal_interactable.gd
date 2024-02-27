#this script defines what the banana does when the player interacts with it
extends Interactable

@onready var animation_tree = get_node("../AnimationTree")
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var state = 1
@onready var tilemap = get_node("/root/game_level/TileMap")

func ready():
	EventLib.add_portal_tiles.connect(_add_portal_tiles)
	
func interact(user: Node2D):
	state=state+1
	#user interacted with banana 
	print("go to random minigame")
	#need to specify who entered minigame with their ID
	
	#_add_portal_tiles("red", Vector2(0,0))
	
	
	
		
#func stop_interaction(user: Node2D):  --- temporarily not in use as we figure out game logic
	#code for a stop interaction  --- temporarily not in use as we figure out game logic

func _add_portal_tiles(colour, portal_pos):
	print("changing tiles")
	#testing the state transitions
	if (colour == "purple"):
		state_machine.travel("purple_portal_idle")
		tilemap.set_cell(0,Vector2i(portal_pos[0],portal_pos[1]-1),0,Vector2i(4,1))    #this will be replaced with a for loop to change the tile around the portal posisiton after portal spawning has been implemented.
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]-1),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]-1),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]+1),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]+1),0,Vector2i(4,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0],portal_pos[1]+1),0,Vector2i(4,1))
		#state=2
	elif (colour == "red"):
		state_machine.travel("red_portal_idle")
		tilemap.set_cell(0,Vector2i(portal_pos[0],portal_pos[1]-1),0,Vector2i(3,1))    #this will be replaced with a for loop to change the tile around the portal posisiton after portal spawning has been implemented.
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]-1),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]-1),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]+1),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]+1),0,Vector2i(3,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0],portal_pos[1]+1),0,Vector2i(3,1))
		#state=3
	else:
		state_machine.travel("blue_portal_idle")
		tilemap.set_cell(0,Vector2i(portal_pos[0],portal_pos[1]-1),0,Vector2i(5,1))    #this will be replaced with a for loop to change the tile around the portal posisiton after portal spawning has been implemented.
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]-1),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]-1),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]+1,portal_pos[1]+1),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0]-1,portal_pos[1]+1),0,Vector2i(5,1))
		tilemap.set_cell(0,Vector2i(portal_pos[0],portal_pos[1]+1),0,Vector2i(5,1))
		#state=1
