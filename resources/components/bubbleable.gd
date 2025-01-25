class_name Bubbleable

extends Node2D

@export var bubble_lives :int = 1

var bubbled := false
var orig_shape :Shape2D

var size_per_tier = [24, 48, 76]

func _ready() -> void:
	pass

func bubble_up() -> void:
	bubbled = true
	orig_shape = get_parent().Collider.shape
	var new_shape = CircleShape2D.new()
	new_shape.radius = size_per_tier[get_parent().size_tier] / 2
	get_parent().Collider.shape = new_shape
	get_parent().body_entered.connect(bubble_used)

func bubble_used() -> void:
	bubble_lives -= 1
	if bubble_lives <= 0:
		bubbled = false
		get_parent().Collider.shape = orig_shape
		get_parent().body_entered.disconnect()
