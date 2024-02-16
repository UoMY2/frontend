extends Button

func _on_pressed():
	#get code from line edit node
	var tf = get_node("/root/JoinLobby/BackBtn/CodeTF")
	print(tf.text)
	
	var lobby_data = await EventLib.join_lobby(tf.text)
	
	#used for updating
	Globalvar.serverObj = EventLib.the_lobby
	
	print(EventLib.the_lobby.playerTeam)
	var player_arr = EventLib.the_lobby.playerTeam
	Globalvar.lobby_code  = EventLib.the_lobby.lobbyId
	
	#add 1 player to the blue team for the initial lobby creation
	#find the index of the current player
	var index = find_index(player_arr)
	var currentPlayer = player_arr[index]     
	
	#EventLib.client_uname = currentPlayer[0]
	Globalvar.current_player_team = currentPlayer[1]
	Globalvar.current_player_ready = currentPlayer[2]
	
	#change scene
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	
	pass # Replace with function body.

func find_index(player_arr):
	var index = 0
	for i in range(len(player_arr)):
		if(EventLib.client_uname==player_arr[i][0]):
			index = i
	return index
		
