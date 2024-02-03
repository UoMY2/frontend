extends Node

var cards = []
var redClear = false
var blueClear = false
var yellowClear = false
var pinkClear = false
var flipBack = false
var flag = false
var can_click = true



func _process(_delta):
	if cards == ["red","red"]:
		redClear = true
		cards = []
	elif cards == ["blue","blue"]:
		blueClear = true
		cards = []
	elif cards == ["yellow","yellow"]:
		yellowClear = true
		cards = []
	elif cards == ["pink","pink"]:
		pinkClear = true
		cards = []
	elif len(cards) >= 2:
		cards = []
		flipBack = true
	if flag == true:
		flipBack = false
		flag = false

