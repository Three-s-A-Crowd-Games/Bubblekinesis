extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.size = GameState.play_area * 2


func _on_body_exited(body: Node2D) -> void:
	if body is Spobject:
		body.queue_free()
