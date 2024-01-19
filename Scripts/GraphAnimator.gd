extends Node

class_name GraphAnimator

var current_tween: Tween

var animating_rooms: Array[DungeonVert]
var animating_corridors: Array[DungeonEdge]
var animating_areas: Array[DungeonRegion]

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
		animating_rooms.append(rm)
		add_child(rm)
		var final_radius = rm.default_circle_radius
		rm.circle_radius = 0
		rm.visible = false
		current_tween.tween_callback(func():rm.visible = true)
		current_tween.tween_property(rm, "circle_radius", final_radius,1 * animation_speed_mult)\
				.set_delay(in_delay / animation_speed_mult)
		if rm.region != null:
			var r_center_point = Vector2((rm.region.coord1.x + rm.region.coord2.x) * 0.5,(rm.region.coord1.y + rm.region.coord2.y) * 0.5)
			rm.region.draw_coord1 = r_center_point
			rm.region.draw_coord2 = r_center_point
			current_tween.tween_property(rm.region, "draw_coord1", rm.region.coord1, 1 * animation_speed_mult)\
					.set_delay(in_delay / animation_speed_mult)
			current_tween.tween_property(rm.region, "draw_coord2", rm.region.coord2, 1 * animation_speed_mult)\
					.set_delay(in_delay / animation_speed_mult)
		in_delay += 0.03


func animate_in_regions(regions: Array[DungeonRegion]):
	check_tween()
	
	for r in regions:
		add_child(r)
		var r_center_point = Vector2((r.coord1.x + r.coord2.x) * 0.5,(r.coord1.y + r.coord2.y) * 0.5)
		r.draw_coord1 = r_center_point
		r.draw_coord2 = r_center_point
		animating_areas.append(r)
		current_tween.tween_property(r, "draw_coord1", r.coord1, 1)
		current_tween.tween_property(r, "draw_coord2", r.coord2, 1)


func animate_in_edges(edges:Array[DungeonEdge]):
	check_tween()
	
	for e in edges:
		animating_corridors.append(e)
		add_child(e)
		var final_end_point = e.draw_pos2
		e.draw_pos2 = e.draw_pos1
		current_tween.tween_property(e, "draw_pos2", final_end_point,1.2 * animation_speed_mult)


func animate_vertex_groups(groups: Array):
	var color_index_tracker: int = 0
	for g in groups:
		animate_object_colors_arbitrary(g, color_display_array[color_index_tracker])
		
		color_index_tracker += 1
		if color_index_tracker >= color_display_array.size():
			color_index_tracker = 0


func animate_object_colors_arbitrary(dungeon_objects: Array, col: Color):
	check_tween()
	
	for obj in dungeon_objects:
		current_tween.tween_property(obj, "fill_color",col,1 * animation_speed_mult)


func animate_out_dungeon_objects(dungeon_objects: Array):
	check_tween()
	
	var out_delay = 0.0
	for obj in dungeon_objects:
		if obj is DungeonEdge:
			current_tween.tween_property(obj, "draw_pos2", obj.draw_pos1,0.75 * animation_speed_mult)\
					.set_delay(out_delay / animation_speed_mult)
		elif obj is DungeonVert:
			current_tween.tween_property(obj, "circle_radius", 0,0.6 * animation_speed_mult)\
					.set_delay(out_delay / animation_speed_mult)
		elif obj is DungeonRegion:
			var obj_center = Vector2(obj.coord1 + obj.coord2) *0.5
			current_tween.tween_property(obj, "draw_coord1", obj_center, 0.6 * animation_speed_mult)\
					.set_delay(out_delay / animation_speed_mult)
			current_tween.tween_property(obj, "draw_coord2", obj_center, 0.6 * animation_speed_mult)\
					.set_delay(out_delay / animation_speed_mult)
		
		out_delay += 0.03
	
	#Remove objects that have been animated out after animation
	for obj in dungeon_objects:
		current_tween.chain().tween_callback(func(): obj.call_deferred("queue_free"))


func emphasize_verticies(verts: Array[DungeonVert], cols: Array[Color]):
	check_tween()
	
	var color_tracker: int = 0
	for rm in verts:
		var target_radius = rm.default_circle_radius * 1.5
		current_tween.tween_property(rm, "circle_radius", target_radius,1 * animation_speed_mult)
		current_tween.tween_property(rm, "fill_color",cols[color_tracker],1 * animation_speed_mult)
		
		color_tracker += 1
		#small logic check if color and vertex arrays arent the same size
		if color_tracker >= cols.size():
			color_tracker = 0
		


func animate_splits(regions):
	check_tween()
	print("ANIMATING SPLITS")
	var color_tracker: int = 0
	for gen in regions:
		#Draw lines
		#change visibility from parent region + line to children
		#pull back for children margin
		var temp_lines = []
		for s in gen:
			var new_split_line = Line2D.new()
			add_child(new_split_line)
			new_split_line.width = s.parent_partition.dungeon_region.border_width
			new_split_line.default_color = Color.NAVY_BLUE
			temp_lines.append(new_split_line)
			current_tween.tween_callback(func():
					new_split_line.add_point(s.split_line_start,0)
					new_split_line.add_point(s.split_line_start,1)
			)
			#Animate Line to draw Across
			current_tween.tween_method((func(val):
					new_split_line.points[1] = val),
					s.split_line_start,
					s.split_line_end,
					0.8 * animation_speed_mult
			)
		
		#Hide the lines and swap them out with the regions
		current_tween.chain().tween_callback(func():
				for l in temp_lines:
					l.visible = false
					l.call_deferred("queue_free")
				
				temp_lines = []
				
				for s in gen:
					var chld1_region = s.child1_partition.dungeon_region
					var chld2_region = s.child2_partition.dungeon_region
					add_child(chld1_region)
					add_child(chld2_region)
					s.parent_partition.dungeon_region.visible = false
					
					#Hide the seam for a seamless transition and showing margin later
					if s.split_direction == Vector2.DOWN:
						chld1_region.draw_coord2.x += chld1_region.get_margin()
						chld2_region.draw_coord1.x -= chld1_region.get_margin()
					else:
						chld1_region.draw_coord2.y += chld1_region.get_margin()
						chld2_region.draw_coord1.y -= chld1_region.get_margin()
		)
		
		current_tween.chain().tween_interval(0.3)
		current_tween.chain().tween_interval(0.01)
		
		#animate margins away from center of split
		for s in gen:
			var chld1_region = s.child1_partition.dungeon_region
			var chld2_region = s.child2_partition.dungeon_region
			current_tween.tween_property(chld1_region,"draw_coord2", chld1_region.coord2,0.5 * animation_speed_mult)
			current_tween.tween_property(chld2_region,"draw_coord1", chld2_region.coord1,0.5 * animation_speed_mult)
		
		current_tween.chain().tween_interval(0.3)
		current_tween.chain().tween_interval(0.01)


func check_tween():
	if current_tween == null:
		current_tween = get_tree().create_tween().bind_node(self)\
				.set_trans(Tween.TRANS_SINE)\
				.set_parallel(true)
		
		if current_tween.finished.get_connections().size() <= 0:
			current_tween.connect("finished", func():print("ANIMATION FINISHED"))
	
	#This chained interval is to allow steps to happen one after another automatically
	#While still allowing each operation of the step to animate in parallel
	if not current_tween == null:
		#small delay between stages of animations
		current_tween.chain().tween_interval(0.25)
		current_tween.chain().tween_interval(0.01)


func interupt_tween():
	if current_tween != null:
		if current_tween.is_running():
			current_tween.kill()
	
	for o in animating_areas:
		if is_instance_valid(o):
			o.queue_free()
	animating_areas = []
	
	for o in animating_corridors:
		if is_instance_valid(o):
			o.queue_free()
	animating_corridors = []
	
	for o in animating_rooms:
		if is_instance_valid(o):
			o.queue_free()
	animating_rooms = []
	
	current_tween = null
