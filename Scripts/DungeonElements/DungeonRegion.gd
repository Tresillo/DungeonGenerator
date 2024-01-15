extends Node2D

class_name DungeonRegion

@export var coord1: Vector2 = Vector2(0,0):
	set(val):
		coord1 = val
		draw_coord1 = coord1
		update_dimensions()
	get:
		return coord1
@export var coord2: Vector2 = Vector2(100,100):
	set(val):
		coord2 = val
		draw_coord2 = coord2
		update_dimensions()
	get:
		return coord2
@export var dim: Vector2 = Vector2(100,100):
	set(val):
		dim = val
	get:
		return dim

@export var draw_coord1: Vector2 = Vector2(0,0):
	set(val):
		draw_coord1 = val
		queue_redraw()
	get:
		return draw_coord1
@export var draw_coord2: Vector2 = Vector2(100,100):
	set(val):
		draw_coord2 = val
		queue_redraw()
	get:
		return draw_coord2

@export_category("Visibility Porperties")
@export var border_width: float = 2.0:
	set(val):
		border_width = val
		queue_redraw()
	get:
		return border_width
@export var opacity: float = 0.5:
	set(val):
		opacity = val
		fill_color = Color(fill_color, val)
		queue_redraw()
	get:
		return opacity
@export var fill_color: Color = Color(Color.GRAY, opacity):
	set(val):
		fill_color = Color(val.r, val.g, val.b, opacity)
		queue_redraw()
	get:
		return fill_color
@export_color_no_alpha var border_color: Color = Color.DARK_BLUE:
	set(val):
		border_color = val
		queue_redraw()
	get:
		return border_color
@export var margin: float = 1:
	set(val):
		margin = val
		queue_redraw()
	get:
		return margin


func _init(dimensions: Rect2):
	dim = dimensions.size
	
	coord1 = dimensions.position
	coord2 = dimensions.end
	
	z_index = 0
	
	queue_redraw()


func update_dimensions():
	dim = Vector2(coord2.x - coord1.x, coord2.y - coord1.y)


func get_margin() -> float:
	return margin + border_width * 0.5


func _draw():
	var margin_vector = Vector2(margin, margin)
	var border_width_vector = Vector2(border_width,border_width)
	var vis_rect:Rect2 = Rect2(draw_coord1 + margin_vector + border_width_vector * 0.5,\
			draw_coord2 - draw_coord1 - 2*margin_vector - border_width_vector)
	
	draw_rect(vis_rect, border_color, false, border_width)
	draw_rect(vis_rect, fill_color, true)
	
