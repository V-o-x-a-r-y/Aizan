extends Control

signal menubuttonclicked(level_name, doorPos)

func _ready():
	$continueButton.connect("pressed", self, "_on_continuebutton_pressed")
	$settingsButton.connect("pressed", self, "_on_settingsbutton_pressed")
	$menuButton.connect("pressed", self, "_on_menubutton_pressed")
	
func _on_continuebutton_pressed():
	visible = false
	get_parent().get_parent().set_physics_process(true)
	print("running anew")
	for friend in get_tree().get_nodes_in_group("friendly"):
		friend.set_physics_process(true)
	for enemy in get_tree().get_nodes_in_group("hostile"):
		enemy.set_physics_process(true)
func _on_settingsbutton_pressed():
	pass
func _on_menubutton_pressed():
	var doorPos="null"
	emit_signal("menubuttonclicked","backTomenu", doorPos)
