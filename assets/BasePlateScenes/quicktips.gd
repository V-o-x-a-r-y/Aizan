extends Control

onready var bg = $Background
onready var text = $Background/text
onready var playerScript = get_parent().get_parent()
var timer

func _ready():
	for i in playerScript.get_parent().get_parent().tipList:
		playerScript.get_parent().get_parent().get_node(i).connect("showtip",self,"_on_showtip")
	timer = Timer.new()
	timer.one_shot=true
	add_child(timer)

func _on_showtip(tip):
	match tip:
		"runtip":
			text.bbcode_text="You can press [b]SHIFT[/b] to [i]run[/i]."
			bg.visible=true
			timer.start(3)
			yield(timer,"timeout")
			bg.visible=false
		"jumptip":
			pass
		_:
			return
