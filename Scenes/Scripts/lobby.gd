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

func update_tables():
	print("updating tables")
	itemListBlue.clear()
	itemListRed.clear()
	for n in range(6):   #6 is the size of the player array
		if(Globalvar.playerArray[n]!=[]):
			print(Globalvar.playerArray)
			if(Globalvar.playerArray[n][1]==0):
				#on blue team
				itemListBlue.add_item(Globalvar.playerArray[n][0], null, false)
			else:
				itemListRed.add_item(Globalvar.playerArray[n][0], null, false)
	Globalvar.update_tables = false
