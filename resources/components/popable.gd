class_name Popable

extends Inputable

var bubbleable :Bubbleable

func _init(bubb: Bubbleable):
	bubbleable = bubb

func release_input() -> bool:
	bubbleable.damage_bubble(bubbleable.bubble_lives)
	return true
