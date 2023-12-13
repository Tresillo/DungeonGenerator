extends Node

class_name GraphAnimator

var current_tween: Tween

func _init():
	current_tween = null


func animate_in_verticies(rooms:Array[DungeonVert]):
	if current_tween == null:
		current_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_parallel(true)
	
	var in_delay: float
	for rm in rooms:
		rm.z_index = 1
		var final_radius = rm.circle_radius
		rm.circle_radius = 0
		current_tween.tween_property(rm, "circle_radius", final_radius,1).set_delay(in_delay)
		in_delay += 0.05


func animate_in_edges(edges:Array[DungeonEdge]):
	print(edges)
