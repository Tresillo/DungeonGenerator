extends Node

class_name GraphAnimator

var current_tween: Tween

var animating_rooms: Array[DungeonVert]
var animating_corridors: Array[DungeonEdge]
var animating_areas: Array

func _init():
	current_tween = null


func animate_in_verticies(rooms:Array[DungeonVert]):
	if current_tween == null:
		current_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_parallel(true)
	
	if not current_tween == null:
		current_tween.chain().tween_interval(0.1)
	
	var in_delay: float
	for rm in rooms:
		rm.z_index = 1
		animating_rooms.append(rm)
		var final_radius = rm.circle_radius
		rm.circle_radius = 0
		current_tween.tween_property(rm, "circle_radius", final_radius,1).set_delay(in_delay)
		in_delay += 0.05


func animate_in_edges(edges:Array[DungeonEdge]):
	print("In")
	if current_tween == null:
		current_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_parallel(true)
		print("No Tween")
	
	if not current_tween == null:
		current_tween.chain().tween_interval(0.1)
		print("Chain Tween")
	
	for e in edges:
		e.z_index = 0
		animating_corridors.append(e)
		var final_end_point = e.draw_pos2
		e.draw_pos2 = e.draw_pos1
		current_tween.tween_property(e, "draw_pos2", final_end_point,1.2)
