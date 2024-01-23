extends TextureRect


func _ready():
	get_tree().root.size_changed.connect(_on_viewport_size_change)
	_on_viewport_size_change()


func _on_viewport_size_change():
	size = get_viewport().size
