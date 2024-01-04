extends Node

class_name UISettingsManager

# 2 nearest neighbour properties
@export var _2nn_target_room_num: int
@export var _2nn_min_room_dim: float
@export var _2nn_max_room_dim: float
@export var _2nn_room_gen_atmpt: int

@export var default_2nn_target_room: int
@export var default_2nn_min_room_dim: float
@export var default_2nn_max_room_dim: float
@export var default_2nn_room_gen_atmpt: int

@onready var _2nn_target_room_num_counter = %"2NNTargetRoomNumCounter"
@onready var _2nn_target_room_num_sld = %"2NNTargetRoomNumSld"
@onready var _2nn_min_room_dim_counter = %"2NNMinRoomDimCounter"
@onready var _2nn_min_room_dim_sld = %"2NNMinRoomDimSld"
@onready var _2nn_max_room_dim_counter = %"2NNMaxRoomDimCounter"
@onready var _2nn_max_room_dim_sld = %"2NNMaxRoomDimSld"
@onready var _2nn_room_gen_atmpt_counter = %"2NNRoomGenAttemptCounter"
@onready var _2nn_room_gen_atmpt_sld = %"2NNRoomGenAtmptSld"

#signals
signal _2nn_properties_changed(_2nn_target_room: int, _2nn_min_room: float, _2nn_max_room: float, _2nn_room_gen: int)

func  _ready():
	#Setup Node paths for 2 Nearest Neighbour
	_2nn_target_room_num_sld.value_changed.connect(_on_2nn_target_room_num_changed)
	default_2nn_target_room = _2nn_target_room_num_sld.value
	_2nn_target_room_num = default_2nn_target_room
	_2nn_min_room_dim_sld.value_changed.connect(_on_2nn_min_room_dim_changed)
	default_2nn_min_room_dim = _2nn_min_room_dim_sld.value
	_2nn_min_room_dim = default_2nn_min_room_dim
	_2nn_max_room_dim_sld.value_changed.connect(_on_2nn_max_room_dim_changed)
	default_2nn_max_room_dim = _2nn_max_room_dim_sld.value
	_2nn_max_room_dim = default_2nn_max_room_dim
	_2nn_room_gen_atmpt_sld.value_changed.connect(_on_2nn_room_gen_attempt_changed)
	default_2nn_room_gen_atmpt = _2nn_room_gen_atmpt_sld.value
	_2nn_room_gen_atmpt = default_2nn_room_gen_atmpt


func _on_2nn_target_room_num_changed(val: float):
	_2nn_target_room_num = val
	_2nn_target_room_num_counter.text = str(val)
	
	_2nn_properties_changed.emit(_2nn_target_room_num,_2nn_min_room_dim,_2nn_max_room_dim,_2nn_room_gen_atmpt)


func _on_2nn_min_room_dim_changed(val: float):
	_2nn_min_room_dim = val
	_2nn_min_room_dim_counter.text = str(val)
	
	_2nn_properties_changed.emit(_2nn_target_room_num,_2nn_min_room_dim,_2nn_max_room_dim,_2nn_room_gen_atmpt)


func _on_2nn_max_room_dim_changed(val: float):
	_2nn_max_room_dim = val
	_2nn_max_room_dim_counter.text = str(val)
	
	_2nn_properties_changed.emit(_2nn_target_room_num,_2nn_min_room_dim,_2nn_max_room_dim,_2nn_room_gen_atmpt)


func _on_2nn_room_gen_attempt_changed(val: float):
	_2nn_room_gen_atmpt = val
	_2nn_room_gen_atmpt_counter.text = str(val)
	
	_2nn_properties_changed.emit(_2nn_target_room_num,_2nn_min_room_dim,_2nn_max_room_dim,_2nn_room_gen_atmpt)


func _on_default_2nn_pressed():
	_2nn_target_room_num_sld.value = default_2nn_target_room
	_2nn_min_room_dim_sld.value = default_2nn_min_room_dim
	_2nn_max_room_dim_sld.value = default_2nn_max_room_dim
	_2nn_room_gen_atmpt_sld.value = default_2nn_room_gen_atmpt
