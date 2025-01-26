extends Node

enum ResourceType {
	SILVER,
	BLUE,
	RED
}

# Play area is actually this * 2
var play_area :Vector2 = Vector2(256, 256):
	set(value):
		play_area = value
		upgraded_play_area.emit(value)
# NOTE: We always HAVE to have one more than actual available upgrades
var play_area_upgrades = [ 256, 384, 512, 640, 768 ]

var cur_play_area_upgrade = 0:
	set(value):
		cur_play_area_upgrade = value
		play_area = Vector2(play_area_upgrades[value],play_area_upgrades[value])
		upgraded_radar_level.emit(value)
var cur_net_level = 0:
	set(value):
		cur_net_level = value
		upgraded_net.emit(value)
var cur_max_bubbles_level = 0:
	set(value):
		cur_max_bubbles_level = value
		if value < GameState.max_bubbles_per_level.size() and value >= 0:
			max_bubbles = max_bubbles_per_level[value]
		upgraded_max_bubbles.emit(value)

var cur_bubbles := 0:
	set(value):
		new_cur_bubbles.emit(value)
		cur_bubbles = value
var max_bubbles_per_level = [2, 3 , 4, 5]
@onready var max_bubbles :int = max_bubbles_per_level[0]

var captured_resources = {
	ResourceType.SILVER: 100,
	ResourceType.BLUE: 100,
	ResourceType.RED: 100,
}

var base_upgrade_cost = 5

signal resources_changed(new_amount :int, type :ResourceType)
signal upgraded_play_area(play_area :Vector2)
signal upgraded_radar_level(new_level :int)
signal upgraded_net(new_level :int)
signal upgraded_max_bubbles(new_level :int)
signal new_cur_bubbles(amount :int)

func change_resources(amount :int, type :ResourceType) -> void:
	captured_resources[type] += amount
	resources_changed.emit(captured_resources[type], type)

func upgrade_net() -> void:
	cur_net_level += 1
	change_resources(-(base_upgrade_cost * cur_net_level), ResourceType.RED)

func upgrade_bubbles() -> void:
	cur_max_bubbles_level += 1
	change_resources(-(base_upgrade_cost * cur_max_bubbles_level), ResourceType.BLUE)

func upgrade_radar() -> void:
	cur_play_area_upgrade += 1
	change_resources(-(base_upgrade_cost * cur_play_area_upgrade), ResourceType.SILVER)
