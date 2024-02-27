extends Node

var cards = []
var redClear = false
var blueClear = false
var yellowClear = false
var pinkClear = false
var greenClear = false
var orangeClear = false
var cyanClear = false
var purpleClear = false
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
	elif cards == ["green","green"]:
		greenClear = true
		cards = []
	elif cards == ["orange","orange"]:
		orangeClear = true
		cards = []
	elif cards == ["cyan","cyan"]:
		cyanClear = true
		cards = []
	elif cards == ["purple","purple"]:
		purpleClear = true
		cards = []
	elif len(cards) >= 2:
		cards = []
		flipBack = true
	if flag == true:
		flipBack = false
		flag = false

