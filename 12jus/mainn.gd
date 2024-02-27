# This is a single player version, for multiplayer, remove cpu components

extends Node2D

var player = false       #if true, then can press button
var choice = 0
var playerscore = 0

var cpuscore = 0

func _ready():
	$Timer.start()
	
func _process(_delta):
	if player == true:
		$paper.disabled = true
		$rock.disabled = true
		$scissors.disabled = true
	$countdown.text = str("%01d" %$Timer.time_left)
	$score.text = (str(playerscore) + " : " + str(cpuscore))



func _on_rock_pressed():
		#$AnimationPlayer.play("rock")
		choice = 1
		$paper.disabled = true
		$rock.disabled = true
		$scissors.disabled = true
		player = true

func _on_paper_pressed():
		#$AnimationPlayer.play("paper")
		choice = 2
		$paper.disabled = true
		$rock.disabled = true
		$scissors.disabled = true
		player = true

func _on_scissors_pressed():
		#$AnimationPlayer.play("scissors")
		choice = 3
		$rock.disabled = true
		$paper.disabled = true
		$scissors.disabled = true
		player = true

func _on_timer_timeout():
	if choice == 1:
		$AnimationPlayer.play("rock")
	elif choice == 2:
		$AnimationPlayer.play("paper")
	elif choice == 3:
		$AnimationPlayer.play("scissors")
	else: 
		$rock.disabled = true
		$paper.disabled = true
		$scissors.disabled = true

# This section is for cpu in single player, not too sure how to do this in multiplayer
	var cpu = randi_range(1,3)
	if cpu == 1:
		$AnimationPlayer2.play("rock2")
	elif cpu == 2:
		$AnimationPlayer2.play("paper2")
	else:
		$AnimationPlayer2.play("scissors2")
		
	if choice == 1:
		if cpu == 2:
			cpuscore += 1
		elif cpu == 3:
			playerscore += 1
	elif choice == 2:
		if cpu == 3:
			cpuscore += 1
		elif cpu == 1:
			playerscore += 1
	elif choice == 3:
		if cpu == 1:
			cpuscore += 1
		elif cpu == 2:
			playerscore += 1
	elif choice == 0: 
		cpuscore += 1 
	
	choice = 0

func _on_animation_player_animation_finished(anim_name):
	#$aniTimer.start()
	pass

func _on_animation_player_2_animation_finished(anim_name):
	$aniTimer.start()

func _on_ani_timer_timeout():
	$rock.disabled = false
	$paper.disabled = false
	$scissors.disabled = false
	$Rock.position = $spawn.position
	$Scissors.position = $spawn.position
	$Paper.position = $spawn.position
	player = false
	
	#cpu 
	$Rock2.position = $spawn2.position
	$Scissors2.position = $spawn2.position
	$Paper2.position = $spawn2.position
	
	if playerscore == 3:
		$countdown.visible = false
		$winner.text = "player wins"
		await get_tree().create_timer(3).timeout
		get_tree().quit()
	
	#cpu
	if cpuscore == 3:
		$countdown.visible = false
		$winner.text = "cpu wins"
		await get_tree().create_timer(3).timeout
		get_tree().quit()
	$Timer.start()
	
	
