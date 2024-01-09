class_name BinTreeNode

var dungeon_region: DungeonRegion
var tree_children: Array[BinTreeNode]
var tree_parent: BinTreeNode


func _init(contained_region: DungeonRegion):
	dungeon_region = contained_region
	
	tree_children = []
	tree_parent = null


func add_tree_child(new_child: BinTreeNode) -> bool:
	if tree_children.size() >= 2:
		return false
	else:
		tree_children.append(new_child)
		new_child.tree_parent = self
		return true


func get_tree_children() -> Array[BinTreeNode]:
	return tree_children


func get_tree_parent() -> BinTreeNode:
	return tree_parent


func is_leaf() -> bool:
	return (tree_children.size() <= 0)
