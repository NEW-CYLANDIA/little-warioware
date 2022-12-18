extends Node
# Common helper functions


func find_by_class(node : Node, className : String, result : Array) -> void:
	if node.is_class(className) :
		result.push_back(node)
	for child in node.get_children():
		find_by_class(child, className, result)