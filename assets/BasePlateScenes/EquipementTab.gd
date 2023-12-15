extends Control

signal weaponChange()
signal modChange(modSlot)
signal itemChange(itemSlot)

func _ready():
	get_parent().connect("weaponSelected",self,"_on_weaponSelected")
	get_parent().connect("modSelected",self,"_on_modSelected")
	get_parent().connect("itemSelected",self,"_on_itemSelected")
	$weapon/weaponButton.connect("pressed", self, "_on_weaponButton_pressed")
	for i in $mods.get_children():
		$mods.get_node(str(i.name)).get_node(str(i.name)+"Button").connect("pressed",self,"_on_modButton_pressed", [str(i.name)])
	for i in $items.get_children():
		$items.get_node(str(i.name)).get_node(str(i.name)+"Button").connect("pressed",self,"_on_itemButton_pressed", [str(i.name)])

func _on_weaponButton_pressed():
	emit_signal("weaponChange")
	if get_parent().get_node("scrollInventory").visible:
		self.modulate = Color(1,1,1,0.9)
	else: 
		self.modulate = Color(1,1,1,1)

func _on_weaponSelected(weapon):
	$weapon.texture = load("res://assets//BasePlateScenes//BasePlateSprites//"+weapon+".png")
	get_parent().get_node("scrollInventory").visible = false
	self.modulate = Color(1,1,1,1)

func _on_modButton_pressed(i):
	emit_signal("modChange", i)
	if get_parent().get_node("scrollInventory").visible:
		self.modulate = Color(1,1,1,0.9)
	else: 
		self.modulate = Color(1,1,1,1)

func _on_modSelected(mod, targetSlot):
	get_node("mods/"+targetSlot).texture = load("res://assets//BasePlateScenes//BasePlateSprites//"+mod+".png")
	get_parent().get_node("scrollInventory").visible = false
	self.modulate = Color(1,1,1,1)

func _on_itemButton_pressed(i):
	emit_signal("itemChange", i)
	if get_parent().get_node("scrollInventory").visible:
		self.modulate = Color(1,1,1,0.9)
	else: 
		self.modulate = Color(1,1,1,1)

func _on_itemSelected(item, targetSlot):
	get_node("items/"+targetSlot).texture = load("res://assets//BasePlateScenes//BasePlateSprites//"+item+".png")
	get_node("items/"+targetSlot).item = item
	get_parent().get_node("scrollInventory").visible = false
	self.modulate = Color(1,1,1,1)
