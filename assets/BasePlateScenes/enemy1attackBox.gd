extends Area2D

var playerScript
var made_contact:bool = false
func _ready():
	#            = wandererattck.enemy(kine).enemy(node2D).baseplate.Player.KinematicBody2D
	playerScript = get_parent().get_parent().get_parent().get_parent().get_node("Player/KinematicBody2D")

func _process(delta):
	if get_overlapping_bodies().find(playerScript)>=1 and playerScript.health>=1:
		pass
