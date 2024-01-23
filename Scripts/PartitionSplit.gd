class_name PartitionSplit
#Container class for helping pass information for each split in the BSP algorithm
#Could be replaced with a dictionary

var parent_partition: BinTreeNode
var child1_partition: BinTreeNode
var child2_partition: BinTreeNode

var split_direction: Vector2

var split_line_start: Vector2
var split_line_end: Vector2

var resultant_edge: DungeonEdge
