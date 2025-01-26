extends Node

enum ResourceType {
	SILVER,
	BLUE,
	RED
}

# Play area is actually this * 2
var play_area :Vector2 = Vector2(256, 256):
	set(value):
		play_area_update.emit(value)
		play_area = value
# NOTE: We always HAVE to have one more than actual available upgrades
var play_area_upgrades = [ 256, 384, 512, 768 ]
var cur_play_area_upgrade = 0

var captured_resources = {
	ResourceType.SILVER: 0,
	ResourceType.BLUE: 0,
	ResourceType.RED: 0,
}

func change_resources(amount :int, type :ResourceType) -> void:
	captured_resources[type] += amount
	resources_changed.emit(captured_resources[type], type)

signal resources_changed(new_amount :int, type :ResourceType)
signal play_area_update(play_area :Vector2)
