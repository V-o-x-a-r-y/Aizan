extends Control

signal weaponSelected(weapon)
signal modSelected(mod,modSlot)
signal itemSelected(item, itemSlot)

var itemDict: Dictionary = { # a dictionary of dictionaries
	"item0":{
		"name":"item0",
		"description":"a debug ressource",
		"rarity":"common",
		"type": "ressource",
	},
	"item1":{
		"name":"item1",
		"description":"a debug quest item",
		"rarity":"rare",
		"type": "quest",
		"linkedQuest":"debugQuest",
	},
	"item2":{
		"name":"item2",
		"description":"a debug weapon",
		"rarity":"legendary",
		"type": "weapon",
		"stats": {
			"attackDamage":1,
			"attackSpeed":1,
			"attackKnockback":1,
		},
	},
	"item3":{
		"name":"item3",
		"description":"the first debug mod",
		"rarity":"legendary",
		"type": "mod",
		"stats": {
			"attackDamage":1,
			"attackSpeed":1,
			"attackKnockback":1,
		},
	},
	"item4":{
		"name":"item4",
		"description":"the first debug item",
		"rarity":"legendary",
		"type": "item",
		"stats": {
			"attackDamage":1,
			"attackSpeed":1,
			"attackKnockback":1,
		},
	},
}

onready var playerScript = get_parent().get_parent()
onready var playerInventory = playerScript.inventoryComplete
var typeFromSignal
var modSlot
var itemSlot

func _ready():
	$EquipementTab.connect("weaponChange",self,"_on_weaponChange")
	$EquipementTab.connect("modChange",self,"_on_modChange")
	$EquipementTab.connect("itemChange",self,"_on_itemChange")

func _slot_logic(i, typeFromSignal):
	var slot = $scrollInventory/slot.duplicate()
	slot.get_node("name").get_node("Label").text=itemDict[i[0]]["name"]
	slot.get_node("description").get_node("Label").text=itemDict[i[0]]["description"]
	slot.get_node("quantity").get_node("Label").text=str(i[1])
	slot.get_node("button")
	slot.visible=true
	slot.item = i[0]
	$scrollInventory/ScrollContainer/VBoxContainer.add_child(slot)
	slot.get_node("button").connect("pressed",self,"_on_slotPressed", [i[0]])

func _on_slotPressed(i):
	match typeFromSignal:
		"weapon":
			emit_signal("weaponSelected",i)
		"mod":
			emit_signal("modSelected",i,modSlot)
		"item":
			emit_signal("itemSelected",i,itemSlot)
		_:
			return
	
func _on_KinematicBody2D_callInventory():
	typeFromSignal = "all"
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	playerInventory = playerScript.inventoryComplete
	for i in playerInventory:
		_slot_logic(i,typeFromSignal)

func _on_weaponChange():
	typeFromSignal = "weapon"
	$scrollInventory.visible = !$scrollInventory.visible
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		if itemDict[i[0]]["type"]=="weapon":
			_slot_logic(i,typeFromSignal)

func _on_modChange(targetSlot):
	modSlot = targetSlot
	typeFromSignal = "mod"
	$scrollInventory.visible = !$scrollInventory.visible
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		if itemDict[i[0]]["type"]=="mod":
			_slot_logic(i,typeFromSignal)

func _on_itemChange(targetSlot):
	itemSlot = targetSlot
	typeFromSignal = "item"
	$scrollInventory.visible = !$scrollInventory.visible
	for i in $scrollInventory/ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	for i in playerInventory:
		if itemDict[i[0]]["type"]=="item":
			_slot_logic(i,typeFromSignal)
