extends Panel

var is_expanded: bool = false

var last_size = Vector2.ZERO

var show_tex_rec

@export var lerp_to: float = 215.0

func _ready():
	show_tex_rec = get_child(0).get_child(0).get_child(0)
	get_child(0).get_child(0).pressed.connect(func():
			is_expanded = not is_expanded
			show_tex_rec.flip_v = is_expanded)

func _process(delta):
	
	#snap to end
	if abs(size.y-custom_minimum_size.y) < 1:
		size.y = custom_minimum_size.y
	
	if is_expanded:
		size.y = lerp(size.y, lerp_to, 0.1)
	else:
		size.y = lerp(size.y, custom_minimum_size.y, 0.1)
	
	#update layout
	if last_size != size:
		get_parent().queue_redraw()
		last_size = size
