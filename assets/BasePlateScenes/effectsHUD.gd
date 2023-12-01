extends Control


onready var poisonbar = $Poison

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_effect_changed(effect, amount):
	match effect:
		"poison":
			poisonbar.visible=true
			poisonbar.value=amount
			if poisonbar.value<=0:
				poisonbar.visible=false
		"radiation":
			pass
		_:
			return
