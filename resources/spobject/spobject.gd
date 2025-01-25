class_name Spobject

extends RigidBody2D

@onready var Collider := $CollisionShape2D
@onready var Sprite := $Sprite2D

var size_tier :int

func _ready() -> void:
	linear_velocity = Vector2(randf_range(-1,1), randf_range(-1,1))
	angular_velocity = randf_range(-0.3,0.3)
	Collider.shape.height = ($Sprite2D.texture.get_height() * $Sprite2D.scale.y)
	Collider.shape.radius = ($Sprite2D.texture.get_width() * $Sprite2D.scale.x) / 2
	size_tier = 0

func _physics_process(delta: float) -> void:
	move_and_collide(linear_velocity*delta, false, 0.01, false)
