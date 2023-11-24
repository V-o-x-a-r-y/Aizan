extends Area2D

onready var player = get_parent().get_parent().get_parent().get_node("Player")  # we'll need those to track the player
onready var player_script = get_parent().get_parent().get_parent().get_node("Player/KinematicBody2D")
var playerDetected : bool = false
var detect_range : int = 200

func _ready():
	pass

func _physics_process(delta):
	var distance_to_player = self.position.distance_to(player.position)
	if player_script.health > 0:
		if distance_to_player <= detect_range:
			playerDetected = true
		else:
			playerDetected = false
