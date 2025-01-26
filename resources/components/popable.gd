class_name Popable

extends Inputable

var bubbleable :Bubbleable

func _init(bubb: Bubbleable):
	bubbleable = bubb

func release_input(already_handled :bool) -> bool:
	if not already_handled and this_was_meant:
		bubbleable.damage_bubble(bubbleable.bubble_lives)
		return true
	else:
		return super.release_input(already_handled)
