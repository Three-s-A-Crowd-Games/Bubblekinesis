class_name Bubbleable

extends Node2D

@export var bubble_lives :int = 1

var bubbled := false
var orig_shape :Shape2D
var new_shape :Shape2D

var size_per_tier = [8, 20, 36]
var tex_per_tier = [
	"res://assets/sprites/bubble_s.png",
	"res://assets/sprites/bubble_m.png",
	"res://assets/sprites/bubble_l.png"
]

func _ready() -> void:
	$Sprite2D.texture = load(tex_per_tier[get_parent().size_tier])
	
	orig_shape = get_parent().Collider.shape
	new_shape = CircleShape2D.new()
	new_shape.radius = size_per_tier[get_parent().size_tier] / 2

func bubble_up() -> void:
	bubbled = true
	get_parent().Collider.shape = new_shape
	get_parent().body_entered.connect(bubble_used)
	$Sprite2D.visible = true

func bubble_used() -> void:
	bubble_lives -= 1
	if bubble_lives <= 0:
		bubbled = false
		$Sprite2D.visible = false
		get_parent().Collider.shape = orig_shape
		get_parent().body_entered.disconnect()
