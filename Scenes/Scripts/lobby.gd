extends Control


@onready var itemListBlue = get_node("BlueTeamContainer/ItemListBlue")
@onready var itemListRed = get_node("RedTeamContainer/ItemListRed")
@onready var code_lbl = get_node("GameCode")

func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	if(Globalvar.update_tables):
		update_tables()
	if(Globalvar.update_code):
		update_lobby_code()
	pass
	
func update_lobby_code():
	code_lbl.text = (Globalvar.lobby_code)
	Globalvar.update_code = false

func update_tables():
	print("updating tables")
	itemListBlue.clear()
	itemListRed.clear()
	for n in range(len(Globalvar.serverObj.playerTeam)):   #6 is the size of the player array
		if(Globalvar.serverObj.playerTeam[n]!=[]):
			print(Globalvar.serverObj.playerTeam)
			if(Globalvar.serverObj.playerTeam[n][1]==0):
				#on blue team
				itemListBlue.add_item(Globalvar.serverObj.playerTeam[n][0], null, false)
			else:
				itemListRed.add_item(Globalvar.serverObj.playerTeam[n][0], null, false)
	Globalvar.update_tables = false
