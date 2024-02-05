#this script defines what the banana does when the player interacts with it
extends Interactable

func interact(user: Node2D):
	#user interacted with banana 
	print("go to random minigame")
	#need to specify who entered minigame with their ID
	
#func stop_interaction(user: Node2D):  --- temporarily not in use as we figure out game logic
	#code for a stop interaction  --- temporarily not in use as we figure out game logic
