extends Node2D

class_name DungeonVert

@export var pos: Vector2:
	set(val):
		pos = val
		queue_redraw()
	get:
		return pos
@export var connected_edges: Array[DungeonEdge]:
	set(val):
		connected_edges = val
	get:
		return connected_edges

@export_category("Visibility Porperties")
@export var circle_radius: float = 8.0:
	set(val):
		circle_radius = val
		queue_redraw()
	get:
		return circle_radius
@export var border_width: float = 2.0:
	set(val):
		border_width = val
		queue_redraw()
	get:
		return border_width
@export_color_no_alpha var fill_color: Color = Color.GRAY:
	set(val):
		fill_color = val
		queue_redraw()
	get:
		return fill_color
@export_color_no_alpha var border_color: Color = Color.DARK_BLUE:
	set(val):
		border_color = val
		queue_redraw()
	get:
		return border_color

#Default Visibility Properties
const default_circle_radius: float = 8.0
const default_border_width: float = 2.0
const default_fill_color: Color = Color.GRAY
const default_border_color: Color = Color.DARK_BLUE

func _init(vertex_position):
	pos = vertex_position
	position = pos
	queue_redraw()


func is_equal_to(other: DungeonVert) -> bool:
	if other == self:
		return true
	elif pos == other.pos and connected_edges == other.connected_edges:
		return true
	else:
		return false


func get_connected_verticies() -> Array:
	return connected_edges.map(func(edge) -> DungeonVert: return edge.get_other_vertex(self))


func _draw():
	draw_circle(Vector2(0,0), circle_radius, fill_color)
	draw_arc(Vector2(0,0), circle_radius, 0, 2*PI, 20, border_color, border_width)


func _to_string():
	return "GraphVertex-" + str(pos)
