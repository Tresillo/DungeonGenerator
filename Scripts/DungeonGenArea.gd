extends Node2D

class_name DungeonGenArea

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
@export var min_dim_room_size: float = 50.0
@export var max_room_dim_size: float = 150.0
@export var max_room_gen_tries: int = 10

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

var dungeon_gen
var init_label: Label
var graph_animator: GraphAnimator = null
var init_run: bool

func _ready():
	init_label = get_tree().root.get_node("CanvasLayer/MarginContainer/InitLabel")
	graph_animator = $GraphAnimator
	init_run = false


func new_graph():
	var temp_children = get_children()
	if temp_children.size() > 0:
		for tmp_chld in temp_children:
			if tmp_chld != graph_animator:
				tmp_chld.call_deferred("queue_free")
	
	if not init_run:
		init_run = true
		if init_label == null:
			init_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/InitLabel")
		
		init_label.visible = false
		init_label.queue_free()


#func _draw():
	#var rect_points = \
			#[area_coord1,
			#Vector2(area_coord1.x, area_coord2.y),
			#area_coord2,
			#Vector2(area_coord2.x, area_coord1.y),
			#area_coord1]
	#
	#draw_polyline(rect_points, border_color, border_width)


func _on_run_2nn_pressed():
	new_graph()
	add_child(dungeon_gen)
	graph_animator.interupt_tween()
	
	dungeon_gen = DGen2NN.new(area_coord1,area_coord2,num_of_vertexes, min_dim_room_size, max_room_dim_size, max_room_gen_tries, graph_animator)
	dungeon_gen.generate_dungeon()
