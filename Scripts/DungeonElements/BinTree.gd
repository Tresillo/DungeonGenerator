class_name BinTree

var nodes: Array[BinTreeNode]
var root: BinTreeNode


func _init(root_node: BinTreeNode):
	nodes = [root_node]
	root = root_node


func get_leaf_nodes() -> Array[BinTreeNode]:
	var leaf_array = []
	for n in nodes:
		if n.is_leaf():
			leaf_array.append(n)
	
	return leaf_array
