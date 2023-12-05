extends Control

var itemDict: Dictionary = { # a dictionary of dictionaries
	"item0":{
		"name":"item0",
		"description":"a debug item",
		"rarity":"common",
		"type": "ressource",
	},
	"item1":{
		"name":"item1",
		"description":"a different debug item",
		"rarity":"rare",
		"type": "quest",
		"linkedQuest":"debugQuest",
	},
	"item2":{
		"name":"item2",
		"description":"the third debug item",
		"rarity":"legendary",
		"type": "weapon",
		"stats": {
			"attackDamage":1,
			"attackSpeed":1,
			"attackKnockback":1,
		},
	},
}

onready var playerScript = get_parent().get_parent()
onready var playerInventory = playerScript.inventoryComplete

func _ready():
	$scrollInventory/HBoxContainer/ressourceTabButton.connect("pressed",self,"_on_ressButton_pressed")
	$scrollInventory/HBoxContainer/questTabButton.connect("pressed",self,"_on_questButton_pressed")
	$scrollInventory/HBoxContainer/weaponTabButton.connect("pressed",self,"_on_weaponButton_pressed")
	$scrollInventory/HBoxContainer/allTabButton.connect("pressed",self,"_on_allButton_pressed")

func _slot_logic(i):
	var slot = $scrollInventory/slot.duplicate()
	slot.get_node("name").get_node("Label").text=itemDict[i[0]]["name"]
	slot.get_node("description").get_node("Label").text=itemDict[i[0]]["description"]
	slot.get_node("quantity").get_node("Label").text=str(i[1])
	slot.get_node("button")
	slot.visible=true
	$scrollInventory/ScrollContainer/VBoxContainer.add_child(slot)

func _on_KinematicBody2D_callInventory():
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	playerInventory = playerScript.inventoryComplete
	for i in playerInventory:
		_slot_logic(i)

func _on_ressButton_pressed():
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		if itemDict[i[0]]["type"]=="ressource":
			_slot_logic(i)

func _on_questButton_pressed():
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		if itemDict[i[0]]["type"]=="quest":
			_slot_logic(i)

func _on_weaponButton_pressed():
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		if itemDict[i[0]]["type"]=="weapon":
			_slot_logic(i)

func _on_allButton_pressed():
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		_slot_logic(i)

