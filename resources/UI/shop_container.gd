extends VBoxContainer

@onready var net_button = $item_1/item/upgrades/upgrade_amounts/Button
@onready var net_1 = $item_1/item/upgrades/upgrade_amounts/upgrade_1
@onready var net_2 = $item_1/item/upgrades/upgrade_amounts/upgrade_2
@onready var net_3 = $item_1/item/upgrades/upgrade_amounts/upgrade_3
@onready var net_cost = $item_1/item/info/text/HBoxContainer/cost_amount

@onready var bubble_button = $item_2/item/upgrades/upgrade_amounts/Button
@onready var bubble_1 = $item_2/item/upgrades/upgrade_amounts/upgrade_1
@onready var bubble_2 = $item_2/item/upgrades/upgrade_amounts/upgrade_2
@onready var bubble_3 = $item_2/item/upgrades/upgrade_amounts/upgrade_3
@onready var bubble_cost = $item_2/item/info/text/HBoxContainer/cost_amount

@onready var radar_button = $item_3/item/upgrades/upgrade_amounts/Button
@onready var radar_1 = $item_3/item/upgrades/upgrade_amounts/upgrade_1
@onready var radar_2 = $item_3/item/upgrades/upgrade_amounts/upgrade_2
@onready var radar_3 = $item_3/item/upgrades/upgrade_amounts/upgrade_3
@onready var radar_cost = $item_3/item/info/text/HBoxContainer/cost_amount

@onready var image_full = load("res://assets/sprites/UI/upgrade_amount_full.png")
@onready var image_empty = load("res://assets/sprites/UI/upgrade_amount_empty.png")

func _ready() -> void:
	GameState.upgraded_net.connect(update_net)
	GameState.upgraded_max_bubbles.connect(update_bubbles)
	GameState.upgraded_radar_level.connect(update_radar)
	
	GameState.resources_changed.connect(check_funds)
	
	update_cost(net_cost,0)
	update_cost(bubble_cost,0)
	update_cost(radar_cost,0)
	
	net_button.pressed.connect(GameState.upgrade_net)
	bubble_button.pressed.connect(GameState.upgrade_bubbles)
	radar_button.pressed.connect(GameState.upgrade_radar)

func update_cost(lab :Label, level :int, done :bool = false):
	if not done:
		var cost = GameState.base_upgrade_cost * (level+1)
		lab.text = str(cost) if cost >= 10 else "0"+str(cost)
	else:
		lab.text = "XX"

func update_net(level :int) -> void:
	var max_level :bool = level == GameState.max_net_level
	update_cost(net_cost, level, max_level)
	if level >= 1:
		net_1.texture = image_full
	else:
		net_1.texture = image_empty
	if level >= 2:
		net_2.texture = image_full
	else:
		net_2.texture = image_empty
	if level >= 3:
		net_3.texture = image_full
	else:
		net_3.texture = image_empty
	
	if max_level and not net_button.disabled:
		net_button.disabled = true
	elif not max_level and net_button.disabled:
		net_button.disabled = false
	
func update_bubbles(level :int) -> void:
	var max_level :bool = level == GameState.max_net_level
	update_cost(bubble_cost, level, max_level)
	if level >= 1:
		bubble_1.texture = image_full
	else:
		bubble_1.texture = image_empty
	if level >= 2:
		bubble_2.texture = image_full
	else:
		bubble_2.texture = image_empty
	if level >= 3:
		bubble_3.texture = image_full
	else:
		bubble_3.texture = image_empty
	
	if max_level and not bubble_button.disabled:
		bubble_button.disabled = true
	elif not max_level and bubble_button.disabled:
		bubble_button.disabled = false
	
func update_radar(level :int) -> void:
	var max_level :bool = level == GameState.max_net_level
	update_cost(radar_cost, level, max_level)
	if level >= 1:
		radar_1.texture = image_full
	else:
		radar_1.texture = image_empty
	if level >= 2:
		radar_2.texture = image_full
	else:
		radar_2.texture = image_empty
	if level >= 3:
		radar_3.texture = image_full
	else:
		radar_3.texture = image_empty
	
	if max_level and not radar_button.disabled:
		radar_button.disabled = true
	elif not max_level and radar_button.disabled:
		radar_button.disabled = false

func check_funds(new_amount :int, type :GameState.ResourceType) -> void:
	var cost
	var button
	match (type):
		GameState.ResourceType.RED:
			if GameState.cur_net_level >= GameState.max_net_level: return
			cost = GameState.base_upgrade_cost * (GameState.cur_net_level + 1)
			button = net_button
		GameState.ResourceType.BLUE:
			if GameState.cur_max_bubbles_level >= GameState.max_bubble_level: return
			cost = GameState.base_upgrade_cost * (GameState.cur_max_bubbles_level + 1)
			button = bubble_button
		GameState.ResourceType.SILVER:
			if GameState.cur_play_area_upgrade >= GameState.max_radar_level: return
			cost = GameState.base_upgrade_cost * (GameState.cur_play_area_upgrade + 1)
			button = radar_button
			
	if GameState.captured_resources[type] >= cost and button.disabled:
		button.disabled = false
	elif GameState.captured_resources[type] < cost and not button.disabled:
		button.disabled = true
