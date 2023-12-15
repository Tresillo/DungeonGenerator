extends Node

class_name GraphAnimator

var current_tween: Tween

var animating_rooms: Array[DungeonVert]
var animating_corridors: Array[DungeonEdge]
var animating_areas: Array

var animation_speed_mult: float = 1.0

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
		add_child(rm)
		var final_radius = rm.circle_radius
		rm.circle_radius = 0
		current_tween.tween_property(rm, "circle_radius", final_radius,1 * animation_speed_mult)\
				.set_delay(in_delay / animation_speed_mult)
		in_delay += 0.03


func animate_in_edges(edges:Array[DungeonEdge]):
	check_tween()
	
	for e in edges:
		e.z_index = 0
		animating_corridors.append(e)
		add_child(e)
		var final_end_point = e.draw_pos2
		e.draw_pos2 = e.draw_pos1
		current_tween.tween_property(e, "draw_pos2", final_end_point,1.2 * animation_speed_mult)


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
		current_tween.tween_property(v, "fill_color",col,0.5 * animation_speed_mult)


func animate_out_dungeon_objects(dungeon_objects: Array):
	check_tween()
	
	for obj in dungeon_objects:
		if obj is DungeonEdge:
			current_tween.tween_property(obj, "draw_pos2", obj.draw_pos1,0.75 * animation_speed_mult)
		elif obj is DungeonVert:
			current_tween.tween_property(obj, "circle_radius", 0,0.6 * animation_speed_mult)
	
	#Remove objects that have been animated out after animation
	for obj in dungeon_objects:
		current_tween.chain().tween_callback(func(): obj.call_deferred("queue_free"))


func check_tween():
	if current_tween == null:
		current_tween = get_tree().create_tween().bind_node(self)\
				.set_trans(Tween.TRANS_SINE)\
				.set_parallel(true)
		current_tween.connect("finished", func(): print("ANIMATION FINISHED"))
	
	#This chained interval is to allow steps to happen one after another automatically
	#While still allowing each operation of the step to animate in parallel
	if not current_tween == null:
		current_tween.chain().tween_interval(0.1)
