extends TextureRect

export (String) var item = "sourceItemSlot"
signal sendItemID(item)
var selectOptions
func _ready():
	if item != "sourceItemSlot":
		selectOptions =get_parent().get_parent().get_parent().get_node("selectOptions")
		get_node("button").connect("pressed",self,"_on_button_pressed")

func _on_button_pressed():
	selectOptions.visible = true
	emit_signal("sendItemID", item)
