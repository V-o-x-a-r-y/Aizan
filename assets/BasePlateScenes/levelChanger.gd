extends Node2D

signal level_changed(level_name)
var playerScript

export (Array) var doorList
export (Array) var itemList
export (Array) var enemyList
export (Array) var zoneList # zone are Areas that give the player Effects, like poison or fire.

func _ready():
	if len(doorList)!=null:
		for i in doorList:
			get_node(i).get_node("Area2D").connect("playerContact",self,"_on_playerContact")
		$Player/KinematicBody2D/Camera2D/pauseMenu.connect("menubuttonclicked",self,"_on_menubuttonclicked")
		$Player/KinematicBody2D/Camera2D/deathScreen.connect("menubuttonclicked",self,"_on_menubuttonclicked")

func _on_playerContact(level_name, doorPos):
	emit_signal("level_changed",level_name, doorPos)
func _on_menubuttonclicked(level_name, doorPos):
	emit_signal("level_changed",level_name, doorPos)
