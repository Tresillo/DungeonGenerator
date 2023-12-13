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


func _init(vertex_position):
	pos = vertex_position
	queue_redraw()


func get_connected_verticies() -> Array:
	return connected_edges.map(func(edge) -> DungeonVert: return edge.get_other_vertex(self))


func _draw():
	draw_circle(pos, circle_radius, fill_color)
	draw_arc(pos, circle_radius, 0, 2*PI, 20, border_color, border_width)


func _to_string():
	return "GraphVertex-" + str(pos)
