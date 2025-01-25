extends Node

# Play area is actually this * 2
var play_area :Vector2 = Vector2(256, 256):
	set(value):
		play_area_update.emit(value)
		play_area = value
# NOTE: We always HAVE to have one more than actual available upgrades
var play_area_upgrades = [ 256, 384, 512, 768 ]
var cur_play_area_upgrade = 0

signal play_area_update(play_area :Vector2)
