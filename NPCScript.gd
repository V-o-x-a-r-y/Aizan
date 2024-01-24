extends Node2D

export (String) var dialogueID
signal dialogueChanged(currentDialogue, isLastLine)

onready var interactZone = $Area2D
onready var playerScript = get_parent().get_parent().get_node("Player/KinematicBody2D")
onready var interactIcon = $interactIcon
var dialogueIndex : int = 0
var interactable : bool = false
var maxDistance : int = 350
var currentDialogue : String = ""
var lastDialogueLine : bool = false

func _ready():
	interactZone.connect("body_entered",self,"_on_zone_bodyentered")
	interactZone.connect("body_exited",self,"_on_zone_bodyexited")
	playerScript.connect("dialogueEnd", self, "interact")

func _on_zone_bodyentered(body):
	if body == playerScript:
		interactIcon.visible = true
		interactable = true

func _on_zone_bodyexited(body):
	if body == playerScript:
		interactIcon.visible = false
		interactable = false

func _process(delta):
	if Input.is_action_just_pressed("interact") and interactable:
		pass
		interact()
	
	if global_position.distance_to(playerScript.global_position)>=maxDistance:
		pass

func interact():
	lastDialogueLine = false
	match dialogueID:
		"debugDialogue1":
			match dialogueIndex:
				0:
					currentDialogue="This is the initial debug dialogue."
				1:
					currentDialogue="This is the first debug dialogue."
				2:
					currentDialogue="This is the second debug dialogue."
				_:
					currentDialogue="This is the last (and default) debug dialogue."
					lastDialogueLine = true
			dialogueIndex+=1
		"debugDialogue2":
			pass
		_:
			return
	emit_signal("dialogueChanged",currentDialogue, lastDialogueLine)
