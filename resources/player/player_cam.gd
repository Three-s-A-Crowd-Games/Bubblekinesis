extends Camera2D

@export var sens = 0.1
@export var zoom_sens = 0.1
@export var max_zoom = 10

var cur_upgrade = 0

var zoom_upgrades = [ 6, 4, 2, 1 ]

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("cam_drag"):
		position += event.relative * -sens
	if event.is_action_pressed("reset_cam"):
		position = Vector2.ZERO
	if event.is_action("zoom_in"):
		change_zoom(zoom + Vector2(zoom_sens, zoom_sens))
	if event.is_action("zoom_out"):
		change_zoom(zoom - Vector2(zoom_sens, zoom_sens))

func change_zoom(zoom_level :Vector2) -> void:
	zoom = clamp(zoom_level, Vector2(zoom_upgrades[cur_upgrade],zoom_upgrades[cur_upgrade]), Vector2(max_zoom,max_zoom))
