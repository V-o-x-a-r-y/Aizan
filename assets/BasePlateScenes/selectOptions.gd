extends TextureRect

var itemID : String = "item0"

func _ready():
	for i in get_parent().get_node("ScrollContainer/VBoxContainer").get_children():
		i.connect("sendItemID", self, "_on_sendItemID")
	$VBoxContainer/Equip.connect("pressed",self,"_on_pressed")

func _on_sendItemID(id):
	itemID = id

func _on_pressed():
	
	pass
