extends Node2D

signal chestOpen(content, ID)
export (Array) var content
export (String) var ID

onready var openZone = $Area2D
onready var interactIcon = $interactIcon
var playerScript
var openable = false

func _ready():
	playerScript = get_parent().get_parent().get_node("Player/KinematicBody2D")
	openZone.connect("body_entered",self,"_on_Area2D_body_entered")
	openZone.connect("body_exited",self,"_on_Area2D_body_exited")

func _on_Area2D_body_entered(body):
	if body==playerScript and content!=[]:
		interactIcon.visible=true
		openable=true

func _on_Area2D_body_exited(body):
	if body==playerScript:
		interactIcon.visible=false
		openable=false

func _process(delta):
	if openable==true:
		if Input.is_action_just_pressed("interact") and content!=[]:
					emit_signal("chestOpen", content, ID)
