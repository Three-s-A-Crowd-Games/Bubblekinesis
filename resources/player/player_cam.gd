extends Camera2D

@export var sens = 0.2
@export var zoom_sens = 0.1
@export var max_zoom = 3

var zoom_upgrades = [ 2, 1, 0.75, 0.6 ]
var sens_upgrades = [ 0.2, 0.3, 0.4, 0.5]

func _ready() -> void:
	GameState.upgraded_play_area.connect(change_play_area)
	change_play_area(GameState.play_area)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("cam_drag"):
		var act_screen_width_half = (get_viewport_rect().size.x * (1/zoom.x))/2
		var act_screen_height_half = (get_viewport_rect().size.y * (1/zoom.y))/2
		position.x = clamp(position.x + event.relative.x * -sens, -GameState.play_area.x + act_screen_width_half, GameState.play_area.x - act_screen_width_half)
		position.y = clamp(position.y + event.relative.y * -sens, -GameState.play_area.y + act_screen_width_half, GameState.play_area.y - act_screen_width_half)
	if event.is_action_pressed("reset_cam"):
		position = Vector2.ZERO
	if event.is_action("zoom_in"):
		change_zoom(zoom + Vector2(zoom_sens, zoom_sens))
	if event.is_action("zoom_out"):
		change_zoom(zoom - Vector2(zoom_sens, zoom_sens))

func change_play_area(play_area :Vector2) -> void:
	limit_right = play_area.y
	limit_left = -play_area.y
	limit_top = -play_area.x
	limit_bottom = play_area.x
	sens = sens_upgrades[GameState.cur_play_area_upgrade]

func change_zoom(zoom_level :Vector2) -> void:
	zoom = clamp(zoom_level, Vector2(zoom_upgrades[GameState.cur_play_area_upgrade],zoom_upgrades[GameState.cur_play_area_upgrade]), Vector2(max_zoom,max_zoom))
