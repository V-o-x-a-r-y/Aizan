extends Control

signal menubuttonclicked(level_name, doorPos)

func _ready():
	$menuButton.connect("pressed", self, "_on_menubutton_pressed")

func _on_menubutton_pressed():
	var doorPos="null"
	emit_signal("menubuttonclicked","backTomenu", doorPos)
