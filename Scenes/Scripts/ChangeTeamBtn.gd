extends Button

#called when the node enters the scene tree for the first time
func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	pass

#runs when the button is pressed
func _on_pressed():
	#change team of player
	
	var current_player = "Player1"   #placeholder for player
	
	#i will wait for players to get implemented before allowing change of team so i know what the best way to store data about the player is. (using a dictionary -inc readyness??)
	pass
	
