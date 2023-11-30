extends Area2D

export(String) var level_name
var playerScript
signal playerContact(level_name,doorPos)

func _ready():
	playerScript = get_parent().get_parent().get_node("Player/KinematicBody2D")
	self.connect("body_entered", self, "_on_door_body_entered")

func _on_door_body_entered(body):
	if body == playerScript:
		emit_signal("playerContact",level_name,"right")
