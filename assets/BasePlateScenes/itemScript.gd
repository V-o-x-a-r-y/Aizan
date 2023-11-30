extends Node2D

signal itemPickup(ID)
export (String) var ID = "item"

onready var pickupZone = $Area2D
onready var interactIcon = $interactIcon
var playerScript
var pickable = false

func _ready():
	playerScript = get_parent().get_node("Player/KinematicBody2D")
	pickupZone.connect("body_entered",self,"_on_Area2D_body_entered")
	pickupZone.connect("body_exited",self,"_on_Area2D_body_exited")

func _on_Area2D_body_entered(body):
	if body==playerScript:
		interactIcon.visible=true
		pickable=true

func _on_Area2D_body_exited(body):
	if body==playerScript:
		interactIcon.visible=false
		pickable=false

func _process(delta):
	if pickable==true:
		if Input.is_action_just_pressed("interact"):
					emit_signal("itemPickup", ID)
					self.queue_free()
