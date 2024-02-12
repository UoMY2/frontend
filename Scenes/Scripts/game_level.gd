extends Node2D

#instantiate the characters
@onready var alien_scene = load("res://Players/alien.tscn")
@onready var alien_instance = alien_scene.instantiate()
@onready var astronaught_scene = load("res://Players/astronaught.tscn")
@onready var astronaught_instance = astronaught_scene.instantiate()

func _ready():
	pass
		
func _process(_delta):
	if(Globalvar.add_player):
		
		#insert logic to choose a character
		var Alien = alien_instance.get_node(".")
		
		#give it a postion given by the server
		Alien.position = Vector2(50, 10)   
		
		#add camera to the player
		var camera = Camera2D.new()
		Alien.add_child(camera)
		
		#add movement script to the player
		Alien.set_script(load("res://Players/player.gd"))
		
		#add player interaciton script to the player
		var area2d = alien_instance.get_node("./Area2D")
		area2d.set_script(load("res://Players/player_interaction.gd"))
		
		#add Alien to the scene
		add_child(alien_instance)
	
		Globalvar.add_player = false
		
	if(Globalvar.add_remote_players):
		
		#insert logic to choose a character
		var Astronaught = astronaught_instance.get_node(".")
		
		#give it a postion given by the server
		Astronaught.position = Vector2(-7, 5)   
		
		#add remote player script to the character
		Astronaught.set_script(load("res://Players/player_remote.gd"))
		
		#Add astronaught to the scene
		add_child(astronaught_instance)
		
		Globalvar.add_remote_players = false
