class_name Spobject

extends RigidBody2D

@onready var Collider := $CollisionShape2D
@onready var Sprite := $Sprite2D

enum Type {
	RESOURCE,
	COMET
}

# Path and Size-Tier: S=0, M=1, L=2
const resources = {
	"res://assets/sprites/spobjects/bubbleable/rocket_part.png": 2,
	"res://assets/sprites/spobjects/bubbleable/rocket_part_2.png": 1,
	"res://assets/sprites/spobjects/bubbleable/satellite.png": 2,
	"res://assets/sprites/spobjects/bubbleable/solar_panel_1.png": 2,
	"res://assets/sprites/spobjects/bubbleable/sputnik.png": 2,
}

const comets = [
	"res://assets/sprites/spobjects/non_bubbleable/comet_1.png",
	"res://assets/sprites/spobjects/non_bubbleable/comet_2.png",
	"res://assets/sprites/spobjects/non_bubbleable/comet_3.png",
	"res://assets/sprites/spobjects/non_bubbleable/comet_4.png",
	"res://assets/sprites/spobjects/non_bubbleable/comet_5.png",
]

var chance_for_resource := 0.5
var type
var size_tier :int

func _ready() -> void:
	type = Type.RESOURCE if randf() < chance_for_resource else Type.COMET
	
	var bubbleable :Bubbleable
	
	if type == Type.RESOURCE:
		bubbleable = load("res://resources/components/bubbleable.tscn").instantiate()
		add_child(bubbleable)
		
		var key :String = resources.keys()[randi_range(0,resources.keys().size() - 1)]
		size_tier = resources[key]
		Sprite.texture = load(key)
	elif type == Type.COMET:
		var key :String = comets[randi_range(0,comets.size() - 1)]
		Sprite.texture = load(key)
	else:
		Sprite.texture =  load("res://assets/32x32testthing.png")
	
	linear_velocity = Vector2(randf_range(-1,1), randf_range(-1,1))
	angular_velocity = randf_range(-0.3,0.3)
	Collider.shape.height = (Sprite.texture.get_height() * Sprite.scale.y)
	Collider.shape.radius = (Sprite.texture.get_width() * Sprite.scale.x) / 2
	
	if bubbleable:
		bubbleable.setup(size_tier, Collider.shape)

func _physics_process(delta: float) -> void:
	move_and_collide(linear_velocity*delta, false, 0.01, false)

func set_collider_shape(shape :Shape2D) -> void:
	Collider.shape = shape
