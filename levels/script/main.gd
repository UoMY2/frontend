extends Node2D


var card_position : Array = []
var cards : Array = []


func _ready():
	$Timer.start()
	for i in get_children():
		if i is TextureButton:
			card_position.append(i.position)
			cards.append(i)
	card_position.shuffle()
	for i in len(card_position):
		cards[i].position = card_position[i]
	
func _process(_delta):
	var check = get_children()
	if len(check) == 3:
		$win.visible = true
		$Timer.stop()
		await get_tree().create_timer(4).timeout
		get_tree().quit()




func _on_timer_timeout():
	$lose.visible = true
	$win.queue_free()
	print("you lose")
	for i in get_children():
		if i is TextureButton:
			i.queue_free()
	await get_tree().create_timer(4).timeout
	get_tree().quit()
