extends Node2D

var playerScript
var timer
var timer2
signal applyEffect(effectType,effectDuration,effectStrenght)
signal removeEffect(effectType)

export (Array) var effectProperties
#effectType = effectProperties[0] # poison, radiation...
#effectDuration = effectProperties[1] # in seconds
#effectStrenght = effectProperties[2] # multiplier for effect damage and such

func _ready():
	playerScript = get_parent().get_node("Player/KinematicBody2D")
	$Area2D.connect("body_entered", self, "_on_Area2D_body_entered")
	$Area2D.connect("body_exited", self, "_on_Area2D_body_exited")
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer2 = Timer.new()
	timer2.one_shot = true
	add_child(timer2)

func _on_Area2D_body_entered(body):
	if body == playerScript:
		while $Area2D.get_overlapping_bodies().count(playerScript)>=1:
			emit_signal("applyEffect",effectProperties[0],effectProperties[1],effectProperties[2])
			timer.start(0.5)
			yield(timer,"timeout")

func _on_Area2D_body_exited(body):
	if body == playerScript:
		playerScript.is_poisonclimbing=false
		timer2.start(1)
		yield(timer2,"timeout")
		emit_signal("removeEffect",effectProperties[0])
