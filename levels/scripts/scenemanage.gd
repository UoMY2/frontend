extends Node2D

@export var PlayerScene : PackedScene
var players
func _ready():
	var index = 0
	players = len(GameManager.players)
	for i in GameManager.players:
		var currentplayer = PlayerScene.instantiate()
		currentplayer.name = str(GameManager.players[i].id)
		add_child(currentplayer)
		for spawn in get_tree().get_nodes_in_group("playerspawn"):
			if spawn.name == str(index):
				currentplayer.global_position = spawn.global_position
		index += 1

#func _process(delta):
	#if len(GameManager.death) > 0:
		#for i in len(GameManager.death):
			#get_node(str(GameManager.death[i])).queue_free()
			#if i == len(GameManager.death):
				#break
