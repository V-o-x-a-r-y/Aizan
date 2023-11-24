extends Area2D

export(PackedScene) var target_scene
var playerScript
func _ready():
	playerScript = get_parent().get_parent().get_node("Player/KinematicBody2D")
	self.connect("body_entered", self, "_on_door_body_entered")

func _on_door_body_entered(body):
	if body == playerScript:
		var ERR = get_tree().change_scene_to(target_scene)
		if ERR != OK:
			print("smthn went wrong w/ that door.")
