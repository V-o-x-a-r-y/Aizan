extends Control

func _ready():
	get_parent().get_parent().connect("callChestInventory",self,"_on_callChestInventory")
	$closeButton.connect("pressed",self,"_on_closeButton_pressed")

func _on_closeButton_pressed():
	self.visible=false

func _on_callChestInventory():
	self.visible=false
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.queue_free()
	get_parent().get_parent().chestContent
	for i in get_parent().get_parent().chestContent:
		_slot_logic(i)
	self.visible=true

func _slot_logic(i):
	var slot = $slot.duplicate()
	slot.get_node("name").get_node("Label").text=get_parent().get_node("Inventory").itemDict[i[0]]["name"]
	slot.get_node("description").get_node("Label").text=get_parent().get_node("Inventory").itemDict[i[0]]["description"]
	slot.get_node("quantity").get_node("Label").text=str(i[1])
	slot.get_node("button")
	slot.visible=true
	slot.item = i[0]
	$ScrollContainer/VBoxContainer.add_child(slot)
	slot.get_node("button").connect("pressed",self,"_on_slotPressed", [i[0], slot.get_node("quantity").get_node("Label").text, slot])

func _on_slotPressed(item, quantity, pressedSlot):
	get_parent().get_parent()._on_itemPickup(item)
	pressedSlot.get_node("quantity").get_node("Label").text=str(int(pressedSlot.get_node("quantity").get_node("Label").text)-1)
	for i in get_parent().get_parent().chestContent:
		if i[0] == item:
			i[1]-=1
	if int(pressedSlot.get_node("quantity").get_node("Label").text)==0:
		for i in get_parent().get_parent().chestContent:
			if i[0] == item:
				get_parent().get_parent().chestContent.erase(i)
				print(get_parent().get_parent().chestContent)
		pressedSlot.queue_free()
	for i in get_parent().get_parent().get_parent().get_parent().chestList:
		if get_parent().get_parent().get_parent().get_parent().get_node(i).ID == get_parent().get_parent().chestID:
			get_parent().get_parent().get_parent().get_parent().get_node(i).content=get_parent().get_parent().chestContent
