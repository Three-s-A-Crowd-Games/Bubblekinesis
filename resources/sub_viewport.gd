extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size.y = 426 * (1/DisplayServer.screen_get_size().aspect())
	get_parent().size.y = 1280 * (1/DisplayServer.screen_get_size().aspect())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
