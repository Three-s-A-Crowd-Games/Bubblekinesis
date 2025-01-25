class_name Bubbleable

extends Node2D

@export var bubble_lives :int = 1

@onready var Animator = $AnimatedSprite2D

var bubbled := false
var orig_shape :Shape2D
var new_shape :Shape2D

var size_per_tier = [8, 20, 36]
var tex_per_tier = [
	"res://assets/sprites/bubbles/bubble_s.png",
	"res://assets/sprites/bubbles/bubble_m.png",
	"res://assets/sprites/bubbles/bubble_l.png"
]

func setup(size_tier :int, ori_shape :Shape2D) -> void:
	$Sprite2D.texture = load(tex_per_tier[size_tier])
	orig_shape = ori_shape.duplicate()
	new_shape = CircleShape2D.new()
	new_shape.radius = size_per_tier[size_tier] / 2
	
	match size_tier:
		0:
			Animator.animation = "s"
		1:
			Animator.animation = "m"
		2:
			Animator.animation = "l"
		_:
			Animator.animation = "l"

func bubble_up() -> void:
	bubbled = true
	get_parent().set_collider_shape(new_shape)
	get_parent().body_entered.connect(bubble_used)
	$Sprite2D.visible = true

func bubble_used(body :Node2D) -> void:
	if body is Spobject:
		var other_bubbleable = body.find_children("*", "Bubbleable", false, false)
		if other_bubbleable.size() == 1 and other_bubbleable[0].bubbled:
			return
	bubble_lives -= 1
	if bubble_lives <= 0:
		bubbled = false
		$Sprite2D.visible = false
		Animator.play()
		get_parent().call_deferred("set_collider_shape", orig_shape)
		get_parent().body_entered.disconnect(bubble_used)
