extends Control

#https://forum.godotengine.org/t/how-to-make-folding-menu/24416

@export var spacing: int = 10

func _draw():
	var last_end_anchor = Vector2.ZERO
	for child in get_children():
		child.position = last_end_anchor
		last_end_anchor.y = child.position.y + child.size.y
		last_end_anchor.y += spacing
	
	custom_minimum_size.y = last_end_anchor.y
