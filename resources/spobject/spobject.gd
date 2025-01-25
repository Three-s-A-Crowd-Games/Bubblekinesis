class_name Spobject

extends RigidBody2D

@export var init_velocity :Vector2 = Vector2(0.5,1)
@export var init_rot :float = 0.0

func _ready() -> void:
	linear_velocity = init_velocity
	angular_velocity = init_rot
	$CollisionShape2D.shape.height = ($Sprite2D.texture.get_height() * $Sprite2D.scale.y)
	$CollisionShape2D.shape.radius = ($Sprite2D.texture.get_width() * $Sprite2D.scale.x)/2

func _physics_process(delta: float) -> void:
	move_and_collide(linear_velocity*delta, false, 0.01, false)
