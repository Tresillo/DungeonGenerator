extends Node

class_name UISettingsManager

# 2 nearest neighbour properties
@export var TNN_num_of_vertexes: int
@export var TNN_min_dim_room_size: float
@export var TNN_max_room_dim_size: float
@export var TNN_max_room_gen_tries: int

var TNN_num_of_vertexes_slider: HSlider
var TNN_num_of_vertexes_counter: Label
var TNN_min_dim_room_size_slider: HSlider
var TNN_min_dim_room_size_counter: Label
var TNN_max_room_dim_size_slider: HSlider
var TNN_max_room_dim_size_counter: Label
var TNN_max_room_gen_tries_slider: HSlider
var TNN_max_room_gen_tries_counter: Label


func  _ready():
	#Setup Node paths for 2 Nearest Neighbour
	TNN_num_of_vertexes_slider = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/TargetRoomNumPnl/TargetRoomNumCont/TargetRoomNumSld"
	TNN_num_of_vertexes_counter = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/TargetRoomNumPnl/TargetRoomNumCont/HBoxContainer/TargetRoomNumCounter"
	TNN_min_dim_room_size_slider = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/MinRoomDimPnl/MinRoomDimCtn/MinRoomDimSld"
	TNN_min_dim_room_size_counter = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/MinRoomDimPnl/MinRoomDimCtn/HBoxContainer/MinRoomDimCounter"
	TNN_max_room_dim_size_slider = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/MaxRoomDimPnl/MaxRoomDimCtn/MaxRoomDimSld"
	TNN_max_room_dim_size_counter = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/MaxRoomDimPnl/MaxRoomDimCtn/HBoxContainer/MaxRoomDimCounter"
	TNN_max_room_gen_tries_slider = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/RoomGenAtmptPnl/RoomGenAtmptCtn/RoomGenAtmptSld"
	TNN_max_room_gen_tries_counter = $"MarginContainer/Foldaway Controller/Foldaway Container/ScrollContainer/Dropdown/Panel/VBoxContainer/RoomGenAtmptPnl/RoomGenAtmptCtn/HBoxContainer/RoomGenAttemptCounter"
