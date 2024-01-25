extends Control

onready var shot0 = $injectorShots/shot0/image
onready var shot1 = $injectorShots/shot1/image
onready var shot2 = $injectorShots/shot2/image

func _ready():
	$barsOverlay/health.value = get_parent().get_parent().health
	$barsOverlay/stamina.value = get_parent().get_parent().stamina

func _on_KinematicBody2D_health_changed(amount): #receiving the signal from the player.
	$barsOverlay/health.value = amount

func _on_KinematicBody2D_stamina_changed(amount):
	$barsOverlay/stamina.value = amount

func _on_KinematicBody2D_score_changed(amount):  # that'll become currency later, for now it useless
	$barsOverlay/health.text = str(amount)

func _on_KinematicBody2D_shotListChanged(shotList, shot):
	match shot:
		"heal":
			shot0.texture=load("res://assets/BasePlateScenes/BasePlateSprites/purple_box.png")
			shot1.texture=load("res://assets/BasePlateScenes/BasePlateSprites/idle_enemy.png")
			shot2.texture=load("res://assets/BasePlateScenes/BasePlateSprites/lime_box.png")
		"stamina":
			shot2.texture=load("res://assets/BasePlateScenes/BasePlateSprites/purple_box.png")
			shot0.texture=load("res://assets/BasePlateScenes/BasePlateSprites/idle_enemy.png")
			shot1.texture=load("res://assets/BasePlateScenes/BasePlateSprites/lime_box.png")
		"antidote":
			shot1.texture=load("res://assets/BasePlateScenes/BasePlateSprites/purple_box.png")
			shot2.texture=load("res://assets/BasePlateScenes/BasePlateSprites/idle_enemy.png")
			shot0.texture=load("res://assets/BasePlateScenes/BasePlateSprites/lime_box.png")

