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


func _init(area_coord1: Vector2, area_coord2: Vector2, number_of_rooms: int, min_room_dim: float, max_room_dim: float, graph_anim: GraphAnimator = null):
	crd1 = area_coord1
	crd2 = area_coord2
	rm_num = number_of_rooms
	min_dim = min_room_dim
	max_dim = max_room_dim
	
	rng = RandomNumberGenerator.new()
	
	graph_animator = graph_anim


func generate_dungeon():
	pass
