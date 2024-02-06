extends Control


@onready var itemListBlue = get_node("BlueTeamContainer/ItemListBlue")
@onready var itemListRed = get_node("RedTeamContainer/ItemListRed")

func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	if(Globalvar.update_tables):
		update_tables()
	pass
	

func update_tables():
	itemListBlue.clear()
	itemListRed.clear()
	for n in range(6):   #6 is the size of the player array
		if(n<3):
			if(Globalvar.playerArray[n]!=""):
				itemListBlue.add_item(Globalvar.playerArray[n], null, false)
		else:
			if(Globalvar.playerArray[n]!=""):
				itemListRed.add_item(Globalvar.playerArray[n], null, false)
	Globalvar.update_tables = false
