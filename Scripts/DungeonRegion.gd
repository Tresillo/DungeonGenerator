extends Node2D

class_name DungeonRegion

@export var coord1: Vector2 = Vector2(100,0):
	set(val):
		coord1 = val
		draw_coord1 = coord1
	get:
		return coord1
@export var coord2: Vector2 = Vector2(100,0):
	set(val):
		coord2 = val
		draw_coord2 = coord2
	get:
		return coord2
@export var dim: Vector2 = Vector2(100,0):
	set(val):
		dim = val
	get:
		return dim

@export var draw_coord1: Vector2 = Vector2(100,0):
	set(val):
		draw_coord1 = val
		queue_redraw()
	get:
		return draw_coord1
@export var draw_coord2: Vector2 = Vector2(100,0):
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


func _init(dimensions: Vector2):
	dim = dimensions
	
	#calc coord points of the region to be centered on 0,0
	var half_dim = dim / 2
	coord1 = half_dim * -1
	coord2 = half_dim


func _draw():
	var margin_vector = Vector2(margin, margin)
	var draw_rect:Rect2 = Rect2(coord1 + margin_vector, dim - margin_vector)
	
	draw_rect(draw_rect, border_color, false, border_width)
	draw_rect(draw_rect, fill_color, true)
	
