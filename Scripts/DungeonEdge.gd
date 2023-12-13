extends Node2D

class_name DungeonEdge

var room1: DungeonVert:
	set(val):
		room1 = val
		draw_pos1 = room1.pos
	get:
		return room1
var room2: DungeonVert:
	set(val):
		room2 = val
		draw_pos2 = room2.pos
	get:
		return room2

var draw_pos1: Vector2:
	set(val):
		draw_pos1 = val
		queue_redraw()
	get:
		return draw_pos1
var draw_pos2: Vector2:
	set(val):
		draw_pos2 = val
		queue_redraw()
	get:
		return draw_pos2

@export_category("Visibility Porperties")
@export var line_width: float = 4.0:
	set(val):
		line_width = val
		queue_redraw()
	get:
		return line_width
@export var border_width: float = 2.0:
	set(val):
		border_width = val
		queue_redraw()
	get:
		return border_width
@export_color_no_alpha var fill_color: Color = Color.DIM_GRAY:
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

func _init(room_1: DungeonVert, room_2: DungeonVert):
	room1 = room_1
	room2 = room_2
	
	draw_pos1 = room1.pos
	draw_pos2 = room2.pos


func get_length() -> float:
	return room1.pos.distance_to(room2.pos)


func is_equal_to(other: DungeonEdge) -> bool:
	if room1 == other.room1 and room2 == other.room2:
		return true
	elif room1.pos == other.room1.pos and room2.pos == other.room2.pos:
		return true
	elif room1 == other.room2 and room2 == other.room1:
		return true
	elif room1.pos == other.room2.pos and room2.pos == other.room1.pos:
		return true
	else:
		return false


func _to_string():
	return "GraphEdge-[" + str(room1) + "]->[" + str(room2) + "]"


func get_other_vertex(other: DungeonVert) -> DungeonVert:
	if other == room1:
		return room2
	elif other == room2:
		return room1
	else:
		push_warning("Vertex - " + str(other) + ", is not found within " + _to_string())
		return null


func _draw():
	draw_line(draw_pos1,draw_pos2,fill_color,line_width)
