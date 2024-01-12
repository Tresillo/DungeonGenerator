class_name BinTree

var nodes: Array[BinTreeNode]
var root: BinTreeNode


func _init(root_node: BinTreeNode):
	nodes = [root_node]
	root = root_node


func get_leaf_nodes() -> Array[BinTreeNode]:
	var leaf_array: Array[BinTreeNode] = []
	for n in nodes:
		if n.is_leaf():
			leaf_array.append(n)
	
	return leaf_array


func add_new_tree_child(parent_node: BinTreeNode, new_child_node: BinTreeNode) -> bool:
	var has_added = parent_node.add_tree_child(new_child_node)
	if has_added:
		nodes.append(new_child_node)
	
	return has_added
