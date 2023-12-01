extends Control

signal level_changed(level_name)
export (String) var level_name = "level"
var doorPos="null"

func _ready(): # the $ is equivalent to get_node(), I just remembered that when looking up smthn' but I'm too lazy to go use it everywhere, gl Isaac, rewriting is your job not mine. Damn that's a long comment.
# warning-ignore:return_value_discarded
	$PlayButton.connect("pressed", self, "_on_playbutton_pressed")
# warning-ignore:return_value_discarded
	$SettingsButton.connect("pressed", self, "_on_settingsbutton_pressed")
# warning-ignore:return_value_discarded
	$QuitButton.connect("pressed", self, "_on_quitbutton_pressed")

func _on_playbutton_pressed():
	emit_signal("level_changed",level_name, doorPos)
# warning-ignore:return_value_discarded

func _on_settingsbutton_pressed():
	pass
	
func _on_quitbutton_pressed():
	get_tree().quit()
