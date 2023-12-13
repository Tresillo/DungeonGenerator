extends Node

class_name GraphAnimator

var current_tween: Tween

var animating_rooms: Array[DungeonVert]
var animating_corridors: Array[DungeonEdge]
var animating_areas: Array

var color_display_array: PackedColorArray = [
	Color.LIGHT_BLUE,
	Color.LIGHT_CORAL,
	Color.LIGHT_GOLDENROD,
	Color.LIGHT_GREEN,
	Color.LIGHT_PINK,
	Color.LIGHT_SEA_GREEN,
	Color.LIGHT_YELLOW
]

func _init():
	current_tween = null


func animate_in_verticies(rooms:Array[DungeonVert]):
	check_tween()
	
	var in_delay: float = 0.0
	for rm in rooms:
		rm.z_index = 1
		animating_rooms.append(rm)
		var final_radius = rm.circle_radius
		rm.circle_radius = 0
		current_tween.tween_property(rm, "circle_radius", final_radius,1).set_delay(in_delay)
		in_delay += 0.03


func animate_in_edges(edges:Array[DungeonEdge]):
	check_tween()
	
	for e in edges:
		e.z_index = 0
		animating_corridors.append(e)
		var final_end_point = e.draw_pos2
		e.draw_pos2 = e.draw_pos1
		current_tween.tween_property(e, "draw_pos2", final_end_point,1.2)


func animate_vertex_groups(groups: Array):
	var color_index_tracker: int = 0
	for g in groups:
		animate_vertex_colors_arbitrary(g, color_display_array[color_index_tracker])
		
		color_index_tracker += 1
		if color_index_tracker >= color_display_array.size():
			color_index_tracker = 0


func animate_vertex_colors_arbitrary(vert: Array, col: Color):
	check_tween()
	
	for v in vert:
		current_tween.tween_property(v, "fill_color",col,0.5)


func check_tween():
	if current_tween == null:
		current_tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_parallel(true)
	
	if not current_tween == null:
		current_tween.chain().tween_interval(0.1)
