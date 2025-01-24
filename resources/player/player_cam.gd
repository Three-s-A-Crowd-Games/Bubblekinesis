extends Camera2D

@export var sens = 0.1
@export var zoom_sens = 0.1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("cam_drag"):
		position += event.relative * -sens
	if event.is_action_pressed("reset_cam"):
		position = Vector2.ZERO
	if event.is_action("zoom_in"):
		zoom += Vector2(zoom_sens, zoom_sens)
	if event.is_action("zoom_out"):
		zoom -= Vector2(zoom_sens, zoom_sens)
