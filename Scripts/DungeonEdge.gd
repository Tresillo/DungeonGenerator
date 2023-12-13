extends Node2D

class_name DungeonEdge

var room1: DungeonVert:
	set(val):
		room1 = val
	get:
		return room1
var room2: DungeonVert:
	set(val):
		room2 = val
	get:
		return room2

var draw_pos1: Vector2:
	set(val):
		draw_pos1 = val
	get:
		queue_redraw()
		return draw_pos1
var draw_pos2: Vector2:
	set(val):
		draw_pos2 = val
	get:
		queue_redraw()
		return draw_pos2

var draw_color: Color = Color.MIDNIGHT_BLUE:
	set(val):
		draw_color = val
	get:
		queue_redraw()
		return draw_color
var draw_width: int = 3:
	set(val):
		draw_width = val
	get:
		queue_redraw()
		return draw_width

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
	draw_line(draw_pos1,draw_pos2,draw_color,draw_width)


