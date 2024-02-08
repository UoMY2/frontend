extends Button

var player_position = 0
var player_item_index = 0
@onready var itemListBlue = get_node("/root/LobbyControl/BlueTeamContainer/ItemListBlue")
@onready var itemListRed = get_node("/root/LobbyControl/RedTeamContainer/ItemListRed")
@onready var ready_btn = get_node("/root/LobbyControl/ReadyBtn")
@onready var error_msg = get_node("/root/LobbyControl/ErrorLbl")


#called when the node enters the scene tree for the first time
func _ready():
	error_msg.hide()
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	if(Globalvar.remove_ready):
		if(Globalvar.serverObj.playerTeam[player_position][2] == true):
			#the player was previously ready so unready them
			_on_pressed(true)
		else:
			Globalvar.remove_ready = false
	pass

#runs when the button is pressed
func _on_pressed(force_remove=false):
	#check that team sizes are even with sizes of 3v3
	if((itemListBlue.get_item_count()==3 && itemListRed.get_item_count()==3)||force_remove==true):
		#ready or unready up the player
		find_player_pos()
		print("player index:"+str(player_item_index))
		var player_name = Globalvar.serverObj.playerTeam[player_position][0]
		if(Globalvar.serverObj.playerTeam[player_position][2] == false):
			Globalvar.serverObj.playerTeam[player_position][2] = true
			#change the text of the ready button to unready or vice versa
			ready_btn.set_text("Unready")
			
			#update the name on the screen to append or remove "(ready)" next to player name
			if(Globalvar.serverObj.playerTeam[player_position][1]==0):
				#on blue team
				itemListBlue.set_item_text(player_item_index,player_name+"(ready)")
			else:
				print("changing name of red team")
				print("player_item_index"+str(player_item_index))
				#on red team
				itemListRed.set_item_text(player_item_index,player_name+"(ready)")
				
			############## update player name to server to display ready for all other players ############
			
		else:
			Globalvar.serverObj.playerTeam[player_position][2] = false
			#change the text of the ready button to unready or vice versa
			ready_btn.set_text("Ready up")
			
			#update the name on the screen to append or remove "(ready)" next to player name
			if(Globalvar.serverObj.playerTeam[player_position][1]==0):
				#on blue team
				itemListBlue.set_item_text(player_item_index,player_name)
			else:
				#on red team
				itemListRed.set_item_text(player_item_index,player_name)
			
			############## update player name to server to display ready for all other players ############
			
			
			
			#turn off remove ready 
			Globalvar.remove_ready = false
	else:
		#display a error message to user
		error_msg.show()
		await get_tree().create_timer(3.0).timeout
		error_msg.hide()
	pass
	
func find_player_pos():
	for i in range(6):
		if(Globalvar.serverObj.playerTeam[i]!=[]):
			if(Globalvar.serverObj.playerTeam[i][0]==EventLib.client_uname):
				print("chaning position")
				player_position = i
		if(Globalvar.serverObj.playerTeam[i]!=[]):
			print("i ========== "+ str(i))
			#check blue item list
			print("itemListBlue.get_item_count:"+str(itemListBlue.get_item_count()))
			if(itemListBlue.get_item_count()>0 && i<itemListBlue.get_item_count()):
				print("itemListBlue.get_item_text(i):"+itemListBlue.get_item_text(i))
				if(EventLib.client_uname==itemListBlue.get_item_text(i)):
					#found the index of where the player is
					print("found index blue, player_item_index="+str(player_item_index))
					player_item_index = i
			
			print("itemListRed.get_item_count:"+str(itemListBlue.get_item_count()))
			if(itemListRed.get_item_count()>0 && i<itemListRed.get_item_count()):
				#check red item list
				print("itemListRed.get_item_text(i):"+itemListRed.get_item_text(i))
				if(EventLib.client_uname==itemListRed.get_item_text(i)):
					#found the index of where the player is
					print("found index red, player_item_index="+str(player_item_index))
					player_item_index = i

		
