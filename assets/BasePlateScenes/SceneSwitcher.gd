extends Node

var next_level = null

onready var current_level = $main_menu

func _ready():
	current_level.connect("level_changed", self, "_on_level_changed")

func _on_level_changed(current_level_name: String):
	var next_level_name: String

	match current_level_name:
		"main_menu":
			next_level_name = "BasePlate"
		"BasePlate":
			next_level_name = "Grass"
		_:
			return

	next_level = load("res://" + next_level_name + ".tscn").instance()
	next_level.layer = -1
	add_child(next_level)
	current_level.cleanup()
	current_level = next_level
	current_level.layer = 1
	next_level = null
	next_level.connect("level_changed", self, "handle_level_changed")
