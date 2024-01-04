extends Node2D
class_name DGenBSP

# Binary Space Partitioning Dungeon Generator Algorithm:
# base on https://www.roguebasin.com/index.php/Basic_BSP_Dungeon_generation

#dungeon properties
var crd1: Vector2
var crd2: Vector2
var rm_num: int
var min_dim: float
var max_dim: float
var gen_attempts: float

var rng
var graph_animator: GraphAnimator = null


func _init(area_coord1: Vector2, area_coord2: Vector2, number_of_rooms: int, min_room_dim: float, max_room_dim: float, room_gen_tries: int, graph_anim: GraphAnimator = null):
	crd1 = area_coord1
	crd2 = area_coord2
	rm_num = number_of_rooms
	min_dim = min_room_dim
	max_dim = max_room_dim
	gen_attempts = room_gen_tries
	
	rng = RandomNumberGenerator.new()
	
	graph_animator = graph_anim


func generate_dungeon():
	pass
