extends Node2D


var card_position : Array = []
var cards : Array = []
var time = 60.0

func _ready():
	$Timer.start()
	for i in get_children():
		if i is TextureButton:
			card_position.append(i.position)
			cards.append(i)
	card_position.shuffle()
	for i in len(card_position):
		cards[i].position = card_position[i]
	
func _process(delta):
	var check = get_children()
	if time > 0:
		time -= delta
	else:
		$Label.visible = false
	$Label.text = "%02d" %time
	if len(check) == 5:
		$win.visible = true
		$Timer.stop()
		$Label.visible = false
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
