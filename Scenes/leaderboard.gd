extends Control

@onready var itemListBlue = get_node("BlueTeamContainerLB/ItemListBlueLB")
@onready var itemListRed = get_node("RedTeamContainerLB/ItemListRedLB")
@onready var mvp_label = get_node("mvpLbl")
@onready var highest_score = [0,0,0] #score, team, index on list 

func _ready():
	#Globalvar.populate_leaderboard.connect(_on_populate_table)
	_on_populate_table()
	
func _on_populate_table():
	print("populating leaderboard")
	for n in range(len(EventLib.the_lobby.playerTeam)): # 6 is the size of the player array
		if (EventLib.the_lobby.playerTeam[n] != []):
			if (EventLib.the_lobby.playerTeam[n][1] == 0):
				#on blue team
				itemListBlue.add_item(str(EventLib.the_lobby.playerTeam[n][0])+":  "+str(EventLib.the_lobby.playerTeam[n][3]), null, false)
				if highest_score[2]<EventLib.the_lobby.playerTeam[n][3]:
					highest_score = [EventLib.the_lobby.playerTeam[n][3],0,get_index_list(str(EventLib.the_lobby.playerTeam[n][0])+":  "+str(EventLib.the_lobby.playerTeam[n][3]),itemListBlue)]
			else:
				#on red team
				itemListRed.add_item(str(EventLib.the_lobby.playerTeam[n][0])+":  "+str(EventLib.the_lobby.playerTeam[n][3]), null, false)
				if highest_score[2]<EventLib.the_lobby.playerTeam[n][3]:
					highest_score = [EventLib.the_lobby.playerTeam[n][3],1,get_index_list(str(EventLib.the_lobby.playerTeam[n][0])+":  "+str(EventLib.the_lobby.playerTeam[n][3]),itemListRed)]
	match highest_score:
		[_,0,0]:
			#first index on blue list
			mvp_label.set("position",Vector2(633,361))
		[_,0,1]:
			#first index on blue list
			mvp_label.set("position",Vector2(633,371))
		[_,0,2]:
			#first index on blue list
			mvp_label.set("position",Vector2(633,381))
		[_,1,0]:
			#first index on red list
			mvp_label.set("position",Vector2(788,361))
		[_,1,1]:
			#first index on red list
			mvp_label.set("position",Vector2(788,371))
		[_,1,2]:
			#first index on red list
			mvp_label.set("position",Vector2(788,381))
		
	
func get_index_list(pname, list):
	var index = 0 
	while index<6:
		if list.get_item_text(index) == pname:
			return index
		index+=1
	return -1
