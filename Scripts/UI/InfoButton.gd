extends Control

var cur_visible: bool = false

func _ready():
	$InfoContainer.visible = cur_visible


func _on_info_button_pressed():
	cur_visible = not cur_visible
	$InfoContainer.visible = cur_visible
