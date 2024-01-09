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
@export var region: DungeonRegion:
	set(val):
		region = val
	get:
		return region

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
		if region != null:
			region.fill_color = val
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


func _init(vertex_position: Vector2, dimensions = null):
	pos = vertex_position
	position = pos
	
	if dimensions == null:
		region = null
	else:
		var coord1 = dimensions * -0.5
		var region_rect = Rect2(coord1, dimensions)
		region = DungeonRegion.new(region_rect)
		add_child(region)
	
	z_index = 2
	
	queue_redraw()


func is_equal_to(other: DungeonVert) -> bool:
	if other == self:
		return true
	elif pos == other.pos and connected_edges == other.connected_edges:
		return true
	else:
		return false


func is_colliding_with(other: DungeonVert) -> bool:
	if region == null and other.region == null:
		#no collisions can occur with no regions
		return false
	elif other.region == null:
		var tp = other.pos
		if tp.x < (pos.x + region.coord2.x) and tp.x > (pos.x + region.coord1.x) and\
				tp.y < (pos.y + region.coord2.y) and tp.y > (pos.y + region.coord1.y):
			return true
		else:
			return false
	elif region == null:
		var tp = other.pos
		if pos.x < (tp.x + other.region.coord2.x) and pos.x > (tp.x + other.region.coord1.x) and\
				pos.y < (tp.y + other.region.coord2.y) and pos.y > (tp.y + other.region.coord1.y):
			return true
		else:
			return false
	else:
		#both rooms have regions
		var tp = other.pos
		if (pos.x + region.coord1.x) > (tp.x + other.region.coord2.x) or \
				(tp.x + other.region.coord1.x) > (pos.x + region.coord2.x):
			return false
		elif (pos.y + region.coord1.y) > (tp.y + other.region.coord2.y) or \
				(tp.y + other.region.coord1.y) > (pos.y + region.coord2.y):
			return false
		else:
			return true


func get_connected_verticies() -> Array:
	return connected_edges.map(func(edge) -> DungeonVert: return edge.get_other_vertex(self))


func _draw():
	draw_circle(Vector2(0,0), circle_radius, fill_color)
	draw_arc(Vector2(0,0), circle_radius, 0, 2*PI, 20, border_color, border_width)


func _to_string():
	return "GraphVertex-" + str(pos)
