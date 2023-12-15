extends Node2D

class_name DungeonGenerator

##	DUNGEON GENERATOR ALGORITHM - DRAFT 1
#
#	1.  Randomly Generate each room.
#	2.  Store each center point of each room as a dungeon vertex.
#	3.  Calculate a distance matrix of the distance between each pair of verticies.
#	4.  For each Vertex, add an edge or corridor between the current vertex and
#			its 2 nearest verticies.
#	5a. Attempt to traverse all verticies of the graph from an arbitrary vertex using
#			the breadth-first search algorithm. store these verticies as a group of nodes.
#	5b. If not all verticies are reached after all edges are traversed, choose an unreached
#			vertex and continue to search, adding all verticies found to a new vertex group.
#	5c. Continue Searching vertex groups until all verticies have been added to a vertex group.
#	6.  Connect each vertex group together with at least 1 edge.
#		6a. Calculate the average position of each vertex group and determine the
#			 	2 closest vertex groups.
#		6b. Create a new unconnected graph vertex on the midpoint between the shortest path
#				between the 2 current vertex group average centers (called A).
#		6c. Find the distance between all verticies in both current vertex groups and A vertex.
#		6d. Create an edge between the A and the nearest vertex from each current vertex group.
#		6e. Remove A from the graph and connect the 2 vertecies that were connected to A
#				and connect them.
#		6f. Update the vertex group distance matrix and Repeat this for the next closest
#				pair of vertex groups until only 1 vertex group remains.
#	7.  Apply Primm's Algorithm to find the minimum spanning tree of the graph.
#	8.  Find the longest path within the MST and place the spawn room at one end
#			and the goal room at the other.
#	9.  Apply AStar algorithm between each graph edge to map the corridor between each room.
#
#	THIS ALGORITHM RUNS IN O(n*log(n)) I think
#	(nvm it runs in O(n^2) because of the distance matrix (like High O(n^2))

#dungeon properties
var crd1: Vector2
var crd2: Vector2
var rm_num: int

var rng
var graph_animator: GraphAnimator = null

var room_array: Array[DungeonVert]
var dungeon_edges: Array[DungeonEdge] = []
var room_distance_matrix = []

var vertex_groups = []
var disp_vertex_group_centers: Array[DungeonVert] = []
var vertex_group_centers = []
var vertex_group_distance_matrix = []

func _init(area_coord1: Vector2, area_coord2: Vector2, number_of_rooms: int):
	crd1 = area_coord1
	crd2 = area_coord2
	rm_num = number_of_rooms
	
	rng = RandomNumberGenerator.new()
	
	graph_animator = GraphAnimator.new()
	add_child(graph_animator)


func generate_dungeon():
	#Step 1
	for i in range(0,rm_num):
		var rm_coord = Vector2(rng.randf_range(crd1.x, crd2.x),rng.randf_range(crd1.y, crd2.y))
		#Step 2
		var new_room = DungeonVert.new(rm_coord)
		room_array.append(new_room)
	
	if graph_animator != null:
		graph_animator.animate_in_verticies(room_array)
	
	#Step 3
	for room in room_array:
		var dist_array = []
		for rm_index in range(0, room_array.size()):
			dist_array.append(room.pos.distance_to(room_array[rm_index].pos))
		room_distance_matrix.append(dist_array)
	
#region Step 4: Initial Edge Connection
	#Step 4
	for room_index in range(0, room_distance_matrix.size()):
		var sorted_dist_array = room_distance_matrix[room_index].duplicate()
		#sort in ascending order
		sorted_dist_array.sort_custom(func(a, b): return a < b)
		
		var cur_room = room_array[room_index]
		
		var room_min_dist_index_1 = room_distance_matrix[room_index].find(sorted_dist_array[1])
		var closest_room_1 = room_array[room_min_dist_index_1]
		
		var room_min_dist_index_2 = room_distance_matrix[room_index].find(sorted_dist_array[2])
		var closest_room_2 = room_array[room_min_dist_index_2]
		
		#If an edge between this node and one of the two closest ones already exists
		# dont make another
		if cur_room.connected_edges.size() > 0:
			for cur_edge in cur_room.connected_edges:
				var other_room = cur_edge.get_other_vertex(cur_room)
				if other_room == closest_room_1:
					closest_room_1 = null
				elif other_room == closest_room_2:
					closest_room_2 = null
		
		if not closest_room_1 == null:
			var new_edge = DungeonEdge.new(cur_room, closest_room_1)
			cur_room.connected_edges.append(new_edge)
			closest_room_1.connected_edges.append(new_edge)
			dungeon_edges.append(new_edge)
		
		if not closest_room_2 == null:
			var new_edge = DungeonEdge.new(cur_room, closest_room_2)
			cur_room.connected_edges.append(new_edge)
			closest_room_2.connected_edges.append(new_edge)
			dungeon_edges.append(new_edge)
	
	if graph_animator != null:
		graph_animator.animate_in_edges(dungeon_edges)
#endregion
	
	#Step 5
	var bfs_rooms = room_array.duplicate()
	while bfs_rooms.size() > 0:
		bfs_rooms = BFS(bfs_rooms)
	
	if graph_animator != null:
		graph_animator.animate_vertex_groups(vertex_groups)
	
	#use closest to arbitrary group
	#midpoint by averaging both point's components together
	
	while vertex_groups.size() > 1:
		
		#Step 6e (its confusing I know)
		disp_vertex_group_centers = []
		vertex_group_centers = []
		vertex_group_distance_matrix = []
		for vg in vertex_groups:
			var vg_poses = vg.map(func(vert): return vert.pos)
			var group_average_position = (vg_poses.reduce(func(accum, num): return num + accum, Vector2(0,0))) / vg.size()
			vertex_group_centers.append(group_average_position)
			
			var new_display_vertex = DungeonVert.new(group_average_position)
			#custom colors for vertex group centers
			new_display_vertex.circle_radius = 16.0
			new_display_vertex.fill_color = Color(Color.DEEP_PINK, 0.25)
			new_display_vertex.border_color = Color(Color.NAVY_BLUE, 0.25)
			disp_vertex_group_centers.append(new_display_vertex)
		
		# if not all verticies are connected, connect them
		if graph_animator != null:
			graph_animator.animate_in_verticies(disp_vertex_group_centers)
		
		# Step 6a
		#vertex group distance matrix calculation
		for vg_index in range(0,vertex_groups.size()):
			var cur_vg_center = vertex_group_centers[vg_index]
			var cur_vg_dists = []
			for vert_index in range(0,vertex_group_centers.size()):
				cur_vg_dists.append(cur_vg_center.distance_to(vertex_group_centers[vert_index]))
			
			vertex_group_distance_matrix.append(cur_vg_dists.duplicate())
		
		#index closest to group 0
		var sorted_group_dist_array = vertex_group_distance_matrix[0].duplicate()
		#sort in ascending order
		sorted_group_dist_array.sort_custom(func(a, b): return a < b)
		var closest_group_index = vertex_group_distance_matrix[0].find(sorted_group_dist_array[1])
		
		# Step 6a2
		var close_vg1_center = vertex_group_centers[0]
		var close_vg1 = vertex_groups[0]
		var close_vg2_center = vertex_group_centers[closest_group_index]
		var close_vg2 = vertex_groups[closest_group_index]
		
		# Step 6b
		var close_vg_midpoint = Vector2(
				(close_vg1_center.x + close_vg2_center.x)*0.5,
				(close_vg1_center.y + close_vg2_center.y)*0.5)
		
		var close_vg_midpoint_room = DungeonVert.new(close_vg_midpoint)
		
		if graph_animator != null:
			graph_animator.animate_in_verticies([close_vg_midpoint_room])
		
		# Step 6c
		var closest_to_new_vert_1
		var closest_to_new_vert_1_dist = -1
		for vert in close_vg1:
			var temp_dist = close_vg_midpoint.distance_to(vert.pos)
			if closest_to_new_vert_1_dist < 0 or temp_dist < closest_to_new_vert_1_dist:
				closest_to_new_vert_1_dist = temp_dist
				closest_to_new_vert_1 = vert
		
		var closest_to_new_vert_2
		var closest_to_new_vert_2_dist = -1
		for vert in close_vg2:
			var temp_dist = close_vg_midpoint.distance_to(vert.pos)
			if closest_to_new_vert_2_dist < 0 or temp_dist < closest_to_new_vert_2_dist:
				closest_to_new_vert_2_dist = temp_dist
				closest_to_new_vert_2 = vert
		
		# Step 6d
		var close_midpoint_edge1 = DungeonEdge.new(close_vg_midpoint_room, closest_to_new_vert_1)
		var close_midpoint_edge2 = DungeonEdge.new(close_vg_midpoint_room, closest_to_new_vert_2)
		if graph_animator != null:
			graph_animator.animate_in_edges([close_midpoint_edge1,close_midpoint_edge2])
		
		# Step 6e
		var group_connecting_edge = DungeonEdge.new(closest_to_new_vert_1, closest_to_new_vert_2)
		closest_to_new_vert_1.connected_edges.append(group_connecting_edge)
		closest_to_new_vert_2.connected_edges.append(group_connecting_edge)
		if graph_animator != null:
			graph_animator.animate_in_edges([group_connecting_edge])
			graph_animator.animate_out_dungeon_objects([
					close_midpoint_edge1,
					close_midpoint_edge2,
					close_vg_midpoint_room
			])
		
		#connect vertex groups
		vertex_groups[0].append_array(close_vg2)
		vertex_groups.remove_at(closest_group_index)
		
		if graph_animator != null:
			graph_animator.animate_vertex_groups(vertex_groups)
			graph_animator.animate_out_dungeon_objects(disp_vertex_group_centers)
	

#Breadth First Search algorithm for step 5 of dungeon generation
func BFS(bfs_rooms: Array[DungeonVert]) -> Array[DungeonVert]:
	var traversal_queue:Array[DungeonVert] = []
	var visited_array:Array[DungeonVert] = []
	var rooms_to_find: Array[DungeonVert] = bfs_rooms.duplicate()
	
	#start at arbitrary room
	var current_room = rooms_to_find.pop_back()
	visited_array.append(current_room)
	traversal_queue.append_array(current_room.get_connected_verticies())
	
	#Traverse through queue
	while traversal_queue.size() > 0:
		#Go to next room in traversal queue
		current_room = traversal_queue.pop_front()
		visited_array.append(current_room)
		#Find the connections to new room
		var cur_room_connections = current_room.get_connected_verticies()
		#add connected rooms that arent already visited, or in the traversal queue
		for con in cur_room_connections:
			if rooms_to_find.find(con) > -1:
				rooms_to_find.remove_at(rooms_to_find.find(con))
				if visited_array.find(con) == -1 and traversal_queue.find(con) == -1:
					traversal_queue.append(con)
	
	
	#Add all traversed verticies to their own vertex group
	vertex_groups.append(visited_array.duplicate())
	
	return rooms_to_find

