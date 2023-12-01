extends Control

onready var bg = $background
onready var textbox = $background/text
onready var playerScript = get_parent().get_parent()
var timer

func _ready():
	for i in playerScript.get_parent().get_parent().textInteractionList:
		playerScript.get_parent().get_parent().get_node(i).connect("textInteract",self,"_on_textInteract")
	timer = Timer.new()
	timer.one_shot=true
	add_child(timer)

func _on_textInteract(text):
	match text:
		"text":
			textbox.bbcode_text="You [b]interacted[/b] with something."
			bg.visible=true
			timer.start(3)
			yield(timer,"timeout")
			bg.visible=false
		"anothertext":
			pass
		_:
			return
