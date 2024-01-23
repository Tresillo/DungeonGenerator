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


var dungeon_gen
var init_label: Label
var info_text_label: Label
var info_title_label: Label
var graph_animator: GraphAnimator = null
var init_run: bool

var _2nn_props: Array
var _bsp_probs: Array


func _ready():
	init_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/InitLabel")
	info_text_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/Info Button/InfoContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/AlgorithmInfo")
	info_title_label = get_tree().root.get_node("Main/CanvasLayer/MarginContainer/Info Button/InfoContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer/AlgorithmTitle")
	graph_animator = $GraphAnimator
	init_run = false
	_2nn_props = [25, 50.0, 150.0, 10]
	_bsp_probs = [18, 40, 100, 0.25]


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


func load_info_from_file(path:String):
	var f = FileAccess.open(path,FileAccess.READ)
	var title_line = f.get_line()
	#get first line of file
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


func _on_canvas_layer__bsp_properties_changed(_bsp_target_room, _bsp_min_room, _bsp_max_room, _bsp_edge_prob):
	_bsp_probs = [_bsp_target_room, _bsp_min_room, _bsp_max_room, _bsp_edge_prob]


func _on_run_bsp_pressed():
	new_graph()
	graph_animator.interupt_tween()
	
	#read and load the Info file for this
	if loaded_path != BSP_info:
		load_info_from_file(BSP_info)
	
	dungeon_gen = DGenBSP.new(
			area_coord1,
			area_coord2,
			_bsp_probs[0],
			_bsp_probs[1],
			_bsp_probs[2],
			_bsp_probs[3],
			graph_animator
	)
	add_child(dungeon_gen)
	dungeon_gen.generate_dungeon()

