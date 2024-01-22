extends Node2D

class_name DungeonGenArea

# info file paths
@onready var TNN_info = "res://AlgorithmInfo/2NN.txt"
@onready var BSP_info = "res://AlgorithmInfo/BSP.txt"
var loaded_path = ""

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
var info_text_label: Label
var info_title_label: Label
var graph_animator: GraphAnimator = null
var init_run: bool

var _2nn_props: Array

func _ready():
	init_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/InitLabel")
	info_text_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/Info Button/InfoContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/AlgorithmInfo")
	info_title_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/Info Button/InfoContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/AlgorithmTitle")
	graph_animator = $GraphAnimator
	init_run = false
	_2nn_props = [25, 50.0, 150.0, 10]
	


func new_graph():
	var temp_children = get_children()
	temp_children.append_array($GraphAnimator.get_children())
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


func load_info_from_file(path:String):
	var f = FileAccess.open(path,FileAccess.READ)
	var title_line = f.get_line()
	#get whole file but first line
	var info_string = f.get_as_text().substr(title_line.length())
	
	if info_text_label == null or info_title_label == null:
		info_text_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/Info Button/InfoContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/AlgorithmInfo")
		info_title_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/Info Button/InfoContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/AlgorithmTitle")
	
	
	info_title_label.text = title_line
	info_text_label.text = info_string
	
	loaded_path = path
	


func _on_canvas_layer__2_nn_properties_changed(_2nn_target_room, _2nn_min_room, _2nn_max_room, _2nn_room_gen):
	_2nn_props = [_2nn_target_room, _2nn_min_room, _2nn_max_room, _2nn_room_gen]


func _on_run_2nn_pressed():
	new_graph()
	graph_animator.interupt_tween()
	
	#read and load the Info file for this
	if loaded_path != TNN_info:
		load_info_from_file(TNN_info)
	
	dungeon_gen = DGen2NN.new(
			area_coord1,
			area_coord2,
			_2nn_props[0],
			_2nn_props[1],
			_2nn_props[2],
			_2nn_props[3],
			graph_animator
	)
	add_child(dungeon_gen)
	dungeon_gen.generate_dungeon()


func _on_run_bsp_pressed():
	new_graph()
	graph_animator.interupt_tween()
	
	#read and load the Info file for this
	if loaded_path != BSP_info:
		load_info_from_file(BSP_info)
	
	dungeon_gen = DGenBSP.new(area_coord1,area_coord2, 18, 40, 100, 0.5, 0.25, graph_animator)
	add_child(dungeon_gen)
	dungeon_gen.generate_dungeon()

