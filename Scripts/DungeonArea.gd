@tool
extends Node2D

class_name DungeonArea

@export var area_coord1: Vector2 = Vector2(100,0):
	set(val):
		area_coord1 = val
		queue_redraw()
	get:
		return area_coord1
@export var area_coord2: Vector2 = Vector2(500,400):
	set(val):
		area_coord2 = val
		queue_redraw()
	get:
		return area_coord2
@export var num_of_vertexes: int = 25:
	set(val):
		num_of_vertexes = val
		queue_redraw()
	get:
		return num_of_vertexes

@export_category("Aesthetic Categories")
@export_color_no_alpha var border_color: Color:
	set(val):
		border_color = val
		queue_redraw()
	get:
		return border_color
@export var border_width: int = 2:
	set(val):
		border_width = val
		queue_redraw()
	get:
		return border_width

var dungeon_gen:DungeonGenerator


func _ready():
	dungeon_gen = DungeonGenerator.new(area_coord1,area_coord2,num_of_vertexes)
	add_child(dungeon_gen)
	
	call_deferred("new_graph")


func new_graph():
	var temp_children = get_children()
	if temp_children.size() > 0:
		for tmp_chld in temp_children:
			tmp_chld.call_deferred("queue_free")
	dungeon_gen = DungeonGenerator.new(area_coord1,area_coord2,num_of_vertexes)
	add_child(dungeon_gen)
	
	dungeon_gen.generate_dungeon()


#func _draw():
	#var rect_points = \
			#[area_coord1,
			#Vector2(area_coord1.x, area_coord2.y),
			#area_coord2,
			#Vector2(area_coord2.x, area_coord1.y),
			#area_coord1]
	#
	#draw_polyline(rect_points, border_color, border_width)
