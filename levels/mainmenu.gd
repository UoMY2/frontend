extends Control

@onready var itemList = get_node("BlueTeamContainer/ItemListBlue")

func _ready():
	pass
	
#called every frame. 'delta' is elapsed time since the previous frame
func _process(_delta):
	
	for n in range(len(Globalvar.blueArray)):
		itemList.add_item(Globalvar.blueArray[n], null, false)
		

