extends Control

func _ready():
	$restartButton.connect("pressed", self, "_on_restartbutton_pressed")
	$menuButton.connect("pressed", self, "_on_menubutton_pressed")

func _on_restartbutton_pressed():
	get_tree().reload_current_scene() # change that later?
	
func _on_menubutton_pressed():
	get_tree().change_scene("res://assets/BasePlateScenes/main_menu.tscn")
