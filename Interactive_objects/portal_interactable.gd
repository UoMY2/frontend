#this script defines what the banana does when the player interacts with it
extends Interactable

@onready var animation_tree = get_node("/root/game_level/Portal/AnimationTree")
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var state = 1

func interact(user: Node2D):
	#user interacted with banana 
	print("go to random minigame")
	#need to specify who entered minigame with their ID
	
	#testing the state transitions
	if (state == 1):
		state_machine.travel("purple_portal_idle")
		state=2
	elif (state ==2):
		state_machine.travel("red_portal_idle")
		state=3
	else:
		state_machine.travel("blue_portal_idle")
		state=1
	
#func stop_interaction(user: Node2D):  --- temporarily not in use as we figure out game logic
	#code for a stop interaction  --- temporarily not in use as we figure out game logic
