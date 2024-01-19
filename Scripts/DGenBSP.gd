extends Node2D
class_name DGenBSP

# Binary Space Partitioning Dungeon Generator Algorithm:
# base on https://www.roguebasin.com/index.php/Basic_BSP_Dungeon_generation
#  1.  Start from a region where the dungeon will be generated
#  2.  Split the region randomly into 2 partitions, with a random cardinal direction of the slice and a random place to start the slice. The slices should ensure not to leave a partition with less than the minimum size of a room in either dimension
#  3.  Create 2 sub regions from this split region, and keep track of this split in a binary tree, where each layer of split down is a new layer on the tree.
#  4.  Repeatedly split these sub regions in the same way you split the original region until you have as many sub areas as you want dungeon rooms.
#  5.  Randomly generate rooms in each of these leave binary partitions.
#  6.  In an attempt to generate loops in the graph, extra corridors will be added using the following
#    6a. For each leaf partition's edge, check through the opposite edges of all other leaf partitions to see if the two line up on the same axis.
#    6b. If a pair like this is found, make a secondary check to see if the other dimensions of the two leaf partitions are in the same range.
#    6c. If this is true, add this other leaf partition to the current leaf partition's list pf adjacent regions. These will be used to add additional edges.
#  7.  Merge the leaf node partitions together into their parent region, creating an edge between the two rooms in the two partitions.
#  8.  When making edges between rooms:
#    8a. If a straight line can be made between the rooms, make the corridor straight.
#    8b. If a straight line cannot be found, separate the edge into 3 components. From the centers of each room, move the greater component of the displacement of the rooms exactly half way using the first and thrid components of the corridor.
#    8c. With the second component of the corridor between the two rooms, create a perpendicular line between the first and third component of the rooms in order to make a Z shaped corridor.
#  9.  Also randomly add corridors between adjacent leaf partitions at this stage that were calculated from step 6.
#  10. Continue merging rooms and creating edges between them until the root of the binary tree is reached.
#  11. Using the tree from the binary tree earlier, find the longest path through this tree. Place the start room at one end and the end room at the other.
#  12. For leaf rooms in the binary tree that are not designated as the start or end rooms, label these as treasure rooms.

#dungeon properties
var crd1: Vector2
var crd2: Vector2
var rm_num: int
var min_dim: float
var max_dim: float

var rng
var graph_animator: GraphAnimator = null
var binary_tree: BinTree


func _init(area_coord1: Vector2, area_coord2: Vector2, number_of_rooms: int, min_room_dim: float, max_room_dim: float, graph_anim: GraphAnimator = null):
	crd1 = area_coord1
	crd2 = area_coord2
	rm_num = number_of_rooms
	min_dim = min_room_dim
	max_dim = max_room_dim
	
	rng = RandomNumberGenerator.new()
	binary_tree = null
	
	graph_animator = graph_anim


func generate_dungeon():
	#Step 1
	var super_region_rect = Rect2(crd1,Vector2(abs(crd2.x-crd1.x),abs(crd2.y-crd1.y)))
	var super_region = DungeonRegion.new(super_region_rect)
	binary_tree = BinTree.new(BinTreeNode.new(super_region))
	
	var current_leaf_nodes: Array[BinTreeNode] = []
	var partitions_remaining: int = rm_num - 1 #super partition is first one
	var no_new_partitions_made: bool = false
	var new_partition_this_generation: bool = true
	var splits_to_animate = []
	var splits_to_animate_cur_gen = []
	
	#Step 4
	while (partitions_remaining > 0 and not no_new_partitions_made):
		#refresh available leaf nodes
		if current_leaf_nodes.size() <= 0:
			if splits_to_animate_cur_gen.size() > 0:
				splits_to_animate.append(splits_to_animate_cur_gen.duplicate())
				splits_to_animate_cur_gen = []
			if not new_partition_this_generation:
				#no more space to partition for more rooms
				no_new_partitions_made = true
			else:
				new_partition_this_generation = false
				current_leaf_nodes = binary_tree.get_leaf_nodes() as Array[BinTreeNode]
		
		if not no_new_partitions_made:
			var cur_part_parent = current_leaf_nodes.pop_back()
			var cur_parent_region = cur_part_parent.dungeon_region
			var cur_part_split:PartitionSplit = null
			#Step 2
			#if current leaf node has a dimension large enough to split
			if cur_parent_region.dim.x > 2*min_dim or cur_parent_region.dim.y > 2*min_dim:
				#choose random available split direction
				var split_dir = [Vector2.RIGHT, Vector2.DOWN]
				if cur_parent_region.dim.x > 2*min_dim and cur_parent_region.dim.y > 2*min_dim:
					split_dir = split_dir[rng.randi_range(0,1)]
				elif cur_parent_region.dim.x > 2*min_dim:
					split_dir = Vector2.DOWN
				else :
					split_dir = Vector2.RIGHT
				
				#choose random place to split
				var split_position: float = -1.0
				var child1: DungeonRegion
				var child2: DungeonRegion
				
				#Step 3
				if split_dir == Vector2.DOWN:
					#can only choose to split in a way where a room
					#could be generated in the resulting partition
					var split_min = cur_parent_region.coord1.x + min_dim
					var split_max = cur_parent_region.coord2.x - min_dim
					
					split_position = randf_range(split_min,split_max)
					
					#print(str(split_min) + " -> " + str(split_position) + " -> " + str(split_max))
					
					#Very messy derivation of children from Vertical split
					child1 = DungeonRegion.new(Rect2(\
									cur_parent_region.coord1,\
							Vector2(split_position - cur_parent_region.coord1.x,\
									cur_parent_region.dim.y)
							)
					)
					
					child2 = DungeonRegion.new(Rect2(\
							Vector2(split_position,\
									cur_parent_region.coord1.y),\
							Vector2(cur_parent_region.coord2.x - split_position,\
									cur_parent_region.dim.y)
							)
					)
				else:
					
					#can only choose to split in a way where a room
					#could be generated in the resulting partition
					var split_min = cur_parent_region.coord1.y + min_dim
					var split_max = cur_parent_region.coord2.y - min_dim
					
					split_position = randf_range(split_min,split_max)
					
					#print(str(split_min) + " -> " + str(split_position) + " -> " + str(split_max))
					
					#Very messy derivation of children from Horizontal split
					child1 = DungeonRegion.new(Rect2(\
									cur_parent_region.coord1,\
							Vector2(cur_parent_region.dim.x,\
									split_position - cur_parent_region.coord1.y)
							)
					)
					
					child2 = DungeonRegion.new(Rect2(\
							Vector2(cur_parent_region.coord1.x,\
									split_position),\
							Vector2(cur_parent_region.dim.x,\
									cur_parent_region.coord2.y - split_position)
							)
					)
				
				var child1_node = BinTreeNode.new(child1)
				var child2_node = BinTreeNode.new(child2)
				
				binary_tree.add_new_tree_child(cur_part_parent,child1_node)
				binary_tree.add_new_tree_child(cur_part_parent,child2_node)
				partitions_remaining -= 1
				#keep track that there is still a chance new partitions can be generated
				new_partition_this_generation = true
				
				#create split container class for keeping track of splits to animate
				cur_part_split = PartitionSplit.new()
				cur_part_split.parent_partition = cur_part_parent
				cur_part_split.child1_partition = child1_node
				cur_part_split.child2_partition = child2_node
				cur_part_split.split_direction = split_dir
				cur_part_split.split_line_start = child2.coord1
				cur_part_split.split_line_end = child1.coord2
				#print(str(partitions_remaining) + " , " + str(split_dir) + " , " + str(splits_to_animate.size()))
				splits_to_animate_cur_gen.append(cur_part_split)
				
				if partitions_remaining <= 0:
					splits_to_animate.append(splits_to_animate_cur_gen.duplicate())
		
	
	if graph_animator != null:
		graph_animator.animate_in_regions([binary_tree.root.dungeon_region])
		graph_animator.animate_splits(splits_to_animate)
	
	#var bsp_leaf_regions:Array[DungeonRegion] = []
	var bsp_leaf_nodes:Array[BinTreeNode] = binary_tree.get_leaf_nodes()
	#for b in bsp_leaf_nodes:
		#bsp_leaf_regions.append(b.dungeon_region as DungeonRegion)
	
	#Step 5
	var dungeon_rooms:Array[DungeonVert] = []
	for bsp_node in bsp_leaf_nodes:
		var reg = bsp_node.dungeon_region
		var reg_x_dim = abs(reg.coord2.x - reg.coord1.x)
		var reg_y_dim = abs(reg.coord2.y - reg.coord1.y)
		var new_region_dim = Vector2(rng.randf_range(min_dim, reg_x_dim),\
				rng.randf_range(min_dim, reg_y_dim))
		
		var new_room_x = rng.randf_range(reg.coord1.x + new_region_dim.x * 0.5,\
				reg.coord2.x - new_region_dim.x * 0.5)
		var new_room_y = rng.randf_range(reg.coord1.y + new_region_dim.y * 0.5,\
				reg.coord2.y - new_region_dim.y * 0.5)
		
		var new_room = DungeonVert.new(Vector2(new_room_x,new_room_y), new_region_dim)
		dungeon_rooms.append(new_room)
		bsp_node.rooms = [new_room]
	
	if graph_animator != null:
		graph_animator.animate_in_verticies(dungeon_rooms)
	
	#Step 6
	var nodes_to_check = bsp_leaf_nodes
	var new_edges:Array[DungeonEdge] = []
	for bsp_node in bsp_leaf_nodes:
		var cur_reg = bsp_node.dungeon_region
		#ensures that nodes wont be double checked for neighbours
		#if A is the neighbour of B, then B is the neighbour of A
		nodes_to_check.remove_at(nodes_to_check.find(bsp_node))
		if nodes_to_check.size() > 0:
			for temp_node in nodes_to_check:
				var temp_reg = temp_node.dungeon_region
				
				#Step 6a
				if cur_reg.coord1.x == temp_reg.coord2.x or\
						cur_reg.coord2.x == temp_reg.coord1.x:
					print("Horizontal")
					#oposite sides share same vertical line
					#now to check the vertical regions match up
					print(str(cur_reg.coord1.y) + ", " + str(cur_reg.coord2.y))
					print(str(temp_reg.coord1.y) + ", " + str(temp_reg.coord2.y))
					#Step 6b
					if (cur_reg.coord2.y >= temp_reg.coord1.y and\
							cur_reg.coord2.y <= temp_reg.coord2.y) or\
							(cur_reg.coord1.y >= temp_reg.coord1.y and\
							cur_reg.coord1.y <= temp_reg.coord2.y) or\
							(temp_reg.coord2.y >= cur_reg.coord1.y and\
							temp_reg.coord2.y <= cur_reg.coord2.y) or\
							(temp_reg.coord1.y >= cur_reg.coord1.y and\
							temp_reg.coord1.y <= cur_reg.coord2.y):
						#Step 6c
						#two regions are neighbours
						print("3")
						bsp_node.neighbours.append(temp_node)
						temp_node.neighbours.append(bsp_node)
						#create edges between rooms in neighbouring areas
						var new_edge = DungeonEdge.new(bsp_node.rooms[0], temp_node.rooms[0])
						bsp_node.rooms[0].connected_edges.append(new_edge)
						temp_node.rooms[0].connected_edges.append(new_edge)
						new_edges.append(new_edge)
				#Step 6a
				elif cur_reg.coord1.y == temp_reg.coord2.y or\
						cur_reg.coord2.y == temp_reg.coord1.y:
					print("Vertical")
					#oposite sides share same Horizontal line
					#now to check the Horizontal regions match up
					print(str(cur_reg.coord1.y) + ", " + str(cur_reg.coord2.y))
					print(str(temp_reg.coord1.y) + ", " + str(temp_reg.coord2.y))
					#Step 6b
					if (cur_reg.coord2.x >= temp_reg.coord1.x and\
							cur_reg.coord2.x <= temp_reg.coord2.x) or\
							(cur_reg.coord1.x >= temp_reg.coord1.x and\
							cur_reg.coord1.x <= temp_reg.coord2.x) or\
							(temp_reg.coord2.x >= cur_reg.coord1.x and\
							temp_reg.coord2.x <= cur_reg.coord2.x) or\
							(temp_reg.coord1.x >= cur_reg.coord1.x and\
							temp_reg.coord1.x <= cur_reg.coord2.x):
						#Step 6c
						#two regions are neighbours
						print("4")
						bsp_node.neighbours.append(temp_node)
						temp_node.neighbours.append(bsp_node)
						#create edges between rooms in areas
						var new_edge = DungeonEdge.new(bsp_node.rooms[0], temp_node.rooms[0])
						bsp_node.rooms[0].connected_edges.append(new_edge)
						temp_node.rooms[0].connected_edges.append(new_edge)
						new_edges.append(new_edge)
	
	if graph_animator != null:
		graph_animator.animate_in_edges(new_edges)
