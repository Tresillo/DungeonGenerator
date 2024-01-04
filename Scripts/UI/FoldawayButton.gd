extends Control

var is_expanded: bool = true

var last_size = Vector2.ZERO
var foldaway_container_node

var button_init_pos

func _ready():
	foldaway_container_node = $"Foldaway Container"
	button_init_pos = get_node("../Foldaway Button").position
	%"Foldaway Button".flip_h = is_expanded


func _process(delta):
	#snap to end
	if abs(foldaway_container_node.size.x-foldaway_container_node.custom_minimum_size.x) < 1:
		foldaway_container_node.size.x = foldaway_container_node.custom_minimum_size.x
	
	if is_expanded:
		foldaway_container_node.size.x = lerp(foldaway_container_node.size.x, 300.0, 0.25)
	else:
		foldaway_container_node.size.x = lerp(foldaway_container_node.size.x, foldaway_container_node.custom_minimum_size.x, 0.25)
	
	get_node("../Foldaway Button").position.x = button_init_pos.x +\
			foldaway_container_node.size.x + 15.0
	
	#update layout
	if last_size != foldaway_container_node.size:
		queue_redraw()
		last_size = foldaway_container_node.size


func _on_foldaway_button_pressed():
	is_expanded = not is_expanded
	%"Foldaway Button".flip_h = is_expanded
