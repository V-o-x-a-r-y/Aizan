extends Node2D

signal showtip(tip)
onready var playerScript=get_parent().get_node("Player/KinematicBody2D")
onready var quicktip = playerScript.get_node("Camera2D/quicktips")
export (String) var tipname = "tip"

func _ready():
	$Area2D.connect("body_entered",self,"_on_Area2D_body_entered")

func _on_Area2D_body_entered(body):
	if body==playerScript:
		emit_signal("showtip",tipname)
		$Area2D.disconnect("body_entered",self,"_on_Area2D_body_entered")
