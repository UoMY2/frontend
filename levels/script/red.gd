extends TextureButton

var flipped = false

func _ready():
	texture_normal = preload("res://img/white back.jpg")
	scale = Vector2(0.1,0.1)

func _process(_delta):
	if checker.redClear == true and flipped == true:
		checker.can_click = false
		await get_tree().create_timer(0.75).timeout
		checker.can_click = true
		queue_free()
		checker.redClear = false

	if flipped == true and checker.flipBack == true:
		checker.can_click = false
		await get_tree().create_timer(0.75).timeout
		checker.can_click = true
		texture_normal = preload("res://img/white back.jpg")
		flipped = false
		checker.flag = true


func _on_pressed():
	if flipped == false and checker.can_click == true:
		flipped = true
		texture_normal = preload("res://img/red.jpg")
		checker.cards.append("red")

