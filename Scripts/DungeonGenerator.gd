extends Node2D

class_name DungeonGenerator

###########################################
#	DUNGEON GENERATOR ALGORITHM - DRAFT 1
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
#	(nvm it runs in O(n^2) because of the distance matrix)

#dungeon properties
var crd1: Vector2
var crd2: Vector2
var rm_num: int

var rng
var graph_animator: GraphAnimator = null

var room_array: Array[DungeonVert]
var room_distance_matrix = []
var dungeon_edges

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
		add_child(new_room)
		room_array.append(new_room)
	
	if graph_animator != null:
		graph_animator.animate_in_verticies(room_array)
	
	#Step 3
	for room in room_array:
		var dist_array = []
		for rm_index in range(0, room_array.size()):
			dist_array.append(room.pos.distance_to(room_array[rm_index].pos))
		room_distance_matrix.append(dist_array)
	
	#Step 4
	var init_added_edges: Array[DungeonEdge] = []
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
			init_added_edges.append(new_edge)
		
		if not closest_room_2 == null:
			var new_edge = DungeonEdge.new(cur_room, closest_room_2)
			cur_room.connected_edges.append(new_edge)
			closest_room_2.connected_edges.append(new_edge)
			init_added_edges.append(new_edge)
	
	graph_animator.animate_in_edges(init_added_edges)
