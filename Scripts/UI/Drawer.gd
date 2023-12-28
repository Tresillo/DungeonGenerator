extends Panel

var is_expanded: bool = false

var last_size = Vector2.ZERO

func _ready():
	$VBoxContainer/Show.connect("pressed", func(): is_expanded = not is_expanded)


func _process(delta):
	
	#snap to end
	if abs(size.y-custom_minimum_size.y) < 1:
		size.y = custom_minimum_size.y
	
	if is_expanded:
		size.y = lerp(size.y, 150.0, 0.1)
	else:
		size.y = lerp(size.y, custom_minimum_size.y, 0.1)
	
	#update layout
	if last_size != size:
		get_parent().queue_redraw()
		last_size = size
