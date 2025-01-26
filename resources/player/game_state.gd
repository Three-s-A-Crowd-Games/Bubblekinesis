extends Node

enum ResourceType {
	SILVER,
	BLUE,
	RED
}

# Play area is actually this * 2
var play_area :Vector2 = Vector2(256, 256):
	set(value):
		upgraded_play_area.emit(value)
		play_area = value
# NOTE: We always HAVE to have one more than actual available upgrades
var play_area_upgrades = [ 256, 384, 512, 640, 768 ]

var cur_play_area_upgrade = 0:
	set(value):
		play_area = Vector2(play_area_upgrades[value],play_area_upgrades[value])
var cur_net_level = 0:
	set(value):
		cur_net_level = value
		upgraded_net.emit(value)
var cur_max_bubbles_level = 0:
	set(value):
		cur_net_level = value
		upgraded_max_bubbles.emit(value)

var cur_bubbles := 0:
	set(value):
		new_cur_bubbles.emit(value)
		cur_bubbles = value

var captured_resources = {
	ResourceType.SILVER: 0,
	ResourceType.BLUE: 0,
	ResourceType.RED: 0,
}

func change_resources(amount :int, type :ResourceType) -> void:
	captured_resources[type] += amount
	resources_changed.emit(captured_resources[type], type)

signal resources_changed(new_amount :int, type :ResourceType)
signal upgraded_play_area(play_area :Vector2)
signal upgraded_net(new_level :int)
signal upgraded_max_bubbles(new_level :int)
signal new_cur_bubbles(amount :int)
