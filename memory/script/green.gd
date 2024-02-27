extends TextureButton

var flipped = false

func _ready():
	texture_normal = preload("res://img/white back.jpg")
	scale = Vector2(0.1,0.1)

func _process(_delta):
	if checker.greenClear == true and flipped == true:
		checker.can_click = false
		await get_tree().create_timer(0.5).timeout
		queue_free()
		checker.greenClear = false
		checker.can_click = true

	if flipped == true and checker.flipBack == true:
		checker.can_click = false
		await get_tree().create_timer(0.5).timeout
		texture_normal = preload("res://img/white back.jpg")
		flipped = false
		checker.flag = true
		checker.can_click = true


func _on_pressed():
	if flipped == false and checker.can_click == true:
		flipped = true
		texture_normal = preload("res://img/green.jpg")
		checker.cards.append("green")
