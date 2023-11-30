extends Node

onready var  current_level = $main_menu

func _ready():
	current_level.connect("level_changed", self, "_on_level_changed")

func _on_level_changed(current_level_name: String, doorPos):
	var next_level
	var next_level_name: String
	
	match current_level_name:
		"backTomenu":
			next_level_name = "main_menu"
		"mainmenu":
			next_level_name = "BasePlate"
			print("bye")
		"baseplate.A1":
			next_level_name = "BaseplateRoom2"
		_:
			return
	
	next_level = load("res://assets//BasePlateScenes//"+next_level_name+".tscn").instance()
	call_deferred("add_child",next_level)
	next_level.connect("level_changed",self,"_on_level_changed")
	current_level.queue_free()
	current_level=next_level
