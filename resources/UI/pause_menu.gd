extends Control

var _is_paused :bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused
		$GridContainer/Resume.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused


func _on_resume_pressed() -> void:
	_is_paused = false


func _on_exit_game_pressed() -> void:
	get_tree().quit()
