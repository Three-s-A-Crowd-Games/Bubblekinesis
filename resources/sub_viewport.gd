extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = DisplayServer.screen_get_size() / 4
	get_parent().size = DisplayServer.screen_get_size()
	get_parent().position = get_parent().size / -4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
