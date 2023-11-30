extends Node2D

var playerScript

signal applyEffect(effectType,effectDuration,effectStrenght)

export (Array) var effectProperties
#effectType = effectProperties[0] # poison, fire, radiation...
#effectDuration = effectProperties[1] # in seconds
#effectStrenght = effectProperties[2] # multiplier for effect damage and such

func _ready():
	playerScript = get_parent().get_node("Player/KinematicBody2D")
	$Area2D.connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	if body == playerScript:
		emit_signal("applyEffect",effectProperties[0],effectProperties[1],effectProperties[2])
