class_name BinTreeNode

var dungeon_region: DungeonRegion
var left_tree_child: BinTreeNode
var right_tree_child: BinTreeNode
var tree_parent: BinTreeNode
var neighbours: Array[BinTreeNode]


func _init(contained_region: DungeonRegion):
	dungeon_region = contained_region
	
	left_tree_child = null
	right_tree_child = null
	tree_parent = null


func add_tree_child(new_child: BinTreeNode) -> bool:
	if left_tree_child == null:
		left_tree_child = new_child
		return true
	elif right_tree_child == null:
		right_tree_child = new_child
		return true
	else:
		return false


func get_tree_children() -> Array[BinTreeNode]:
	return [left_tree_child,right_tree_child]


func get_tree_parent() -> BinTreeNode:
	return tree_parent


func is_leaf() -> bool:
	return (left_tree_child == null and right_tree_child == null)
