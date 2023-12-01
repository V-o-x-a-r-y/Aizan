extends Node2D

signal textInteract(text)
export (String) var text = "text"

onready var interactZone = $Area2D
onready var interactIcon = $interactIcon
var playerScript
var interactable = false

func _ready():
	playerScript = get_parent().get_node("Player/KinematicBody2D")
	interactZone.connect("body_entered",self,"_on_Area2D_body_entered")
	interactZone.connect("body_exited",self,"_on_Area2D_body_exited")

func _on_Area2D_body_entered(body):
	if body==playerScript:
		interactIcon.visible=true
		interactable=true

func _on_Area2D_body_exited(body):
	if body==playerScript:
		interactIcon.visible=false
		interactable=false

func _process(delta):
	if interactable==true:
		if Input.is_action_just_pressed("interact"):
					emit_signal("textInteract", text)
					self.queue_free()
