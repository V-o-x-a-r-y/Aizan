extends Control

func _ready():
	$PlayerHealth.value = get_parent().get_parent().health

func _on_KinematicBody2D_health_changed(amount): #receiving the signal from the player.
	$PlayerHealth.value = amount

func _on_KinematicBody2D_score_changed(amount):
	$PlayerScore.text = str(amount)
