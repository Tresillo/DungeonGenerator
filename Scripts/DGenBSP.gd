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
	
	#loop
	#get leaf nodes
	#itterate on each one
	#split each
	#check remaining rooms after each split, break if true
	#once all have have been split, get bsp leaf nodes
	
	while (partitions_remaining > 0 and not no_new_partitions_made):
		
		#refresh available leaf nodes
		if current_leaf_nodes.size() <= 0:
			if not new_partition_this_generation:
				#no more space to partition for more rooms
				no_new_partitions_made = true
			else:
				new_partition_this_generation = false
				current_leaf_nodes = binary_tree.get_leaf_nodes()
		
		if not no_new_partitions_made:
			var cur_part_parent = current_leaf_nodes.pop_back()
			var cur_parent_region = cur_part_parent.dungeon_region
			
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
				if split_dir == Vector2.DOWN:
					#can only choose to split in a way where a room
					#could be generated in the resulting partition
					var split_min = cur_parent_region.coord1.x + min_dim
					var split_max = cur_parent_region.coord2.x - min_dim
					
					split_position = randf_range(split_min,split_max)
					
					#Very messy derivation of children from Vertical split
					child1 = DungeonRegion.new(Rect2(\
							cur_parent_region.coord1,\
							Vector2(split_position,\
									cur_parent_region.dim.y)
							)
					)
					
					child2 = DungeonRegion.new(Rect2(\
							Vector2(split_position + cur_parent_region.coord1.x,\
									cur_parent_region.coord1.y),\
							Vector2(cur_parent_region.dim.x - split_position,\
									cur_parent_region.dim.y)
							)
					)
				else:
					#can only choose to split in a way where a room
					#could be generated in the resulting partition
					var split_min = cur_parent_region.coord1.y + min_dim
					var split_max = cur_parent_region.coord2.y - min_dim
					
					split_position = randf_range(split_min,split_max)
					
					#Very messy derivation of children from Horizontal split
					child1 = DungeonRegion.new(Rect2(\
							cur_parent_region.coord1,\
							Vector2(cur_parent_region.dim.x,\
									split_position)
							)
					)
					
					child2 = DungeonRegion.new(Rect2(\
							Vector2(cur_parent_region.coord1.x,\
									split_position + cur_parent_region.coord1.y),\
							Vector2(cur_parent_region.dim.x,\
									cur_parent_region.dim.y - split_position)
							)
					)
				
				binary_tree.add_new_tree_child(cur_part_parent,BinTreeNode.new(child1))
				binary_tree.add_new_tree_child(cur_part_parent,BinTreeNode.new(child2))
				partitions_remaining -= 1
				#keep track that there is still a chance new partitions can be generated
				new_partition_this_generation = true
				
				
	

