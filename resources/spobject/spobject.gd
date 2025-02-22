class_name Spobject

extends RigidBody2D

@onready var Collider := $CollisionShape2D
@onready var Sprite := $Sprite2D
@onready var collide_sfx_player: AudioStreamPlayer2D = $Collide

enum Type {
	RESOURCE,
	COMET
}

# Path and [Size-Tier: S=0, M=1, L=2 , ResourceType]
var resources = {
	"res://assets/sprites/spobjects/bubbleable/rocket_part.png": [2, GameState.ResourceType.RED],
	"res://assets/sprites/spobjects/bubbleable/rocket_part_2.png": [1, GameState.ResourceType.BLUE],
	"res://assets/sprites/spobjects/bubbleable/satellite.png": [2, GameState.ResourceType.RED],
	"res://assets/sprites/spobjects/bubbleable/solar_panel_1.png": [2, GameState.ResourceType.BLUE],
	"res://assets/sprites/spobjects/bubbleable/sputnik.png": [2, GameState.ResourceType.SILVER],
	"res://assets/sprites/spobjects/bubbleable/light.png": [0, GameState.ResourceType.SILVER],
}

const comets = {
	"res://assets/sprites/spobjects/non_bubbleable/comet_1.png": 100,
	"res://assets/sprites/spobjects/non_bubbleable/comet_2.png": 10,
	"res://assets/sprites/spobjects/non_bubbleable/comet_3.png": 10,
	"res://assets/sprites/spobjects/non_bubbleable/comet_4.png": 100,
	"res://assets/sprites/spobjects/non_bubbleable/comet_5.png": 1000,
}

var chance_for_resource := 0.5
var type
var size_tier :int
var bubbleable :Bubbleable

var worth :int
var resource_type

var orig_shape :Shape2D
var should_reset := false

var captured := false
var check_input = []

func _ready() -> void:
	type = Type.RESOURCE if randf() < chance_for_resource else Type.COMET
	
	
	if type == Type.RESOURCE:
		bubbleable = load("res://resources/components/bubbleable.tscn").instantiate()
		add_child(bubbleable)
		
		var key :String = resources.keys()[randi_range(0,resources.keys().size() - 1)]
		size_tier = resources[key][0]
		resource_type = resources[key][1]
		Sprite.texture = load(key)
		worth = 1
	elif type == Type.COMET:
		var key :String = comets.keys()[randi_range(0,comets.size() - 1)]
		mass = comets[key]
		Sprite.texture = load(key)
	else:
		Sprite.texture =  load("res://assets/32x32testthing.png")
	
	linear_velocity = Vector2(randf_range(-1,1), randf_range(-1,1))
	angular_velocity = randf_range(-0.3,0.3)
	Collider.shape.height = (Sprite.texture.get_height() * Sprite.scale.y)
	Collider.shape.radius = (Sprite.texture.get_width() * Sprite.scale.x) / 2
	
	if bubbleable:
		bubbleable.setup(size_tier)
		orig_shape = Collider.shape.duplicate()

func _physics_process(delta: float) -> void:
	if should_reset:
		should_reset = false
		Collider.shape = orig_shape
	move_and_collide(linear_velocity*delta, false, 0.01, false)

func set_collider_shape(shape :Shape2D) -> void:
	Collider.shape = shape

func reset_collider_shape() -> void:
	should_reset = true

func _on_input_event(viewport, event, shape_idx):
	event = event as InputEventMouseButton
	if event and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		BubbleGenerator.can_draw = false
		for inputable in check_input:
			inputable.input()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		BubbleGenerator.can_draw = true
		var already_handled := false
		for inputable in check_input:
			if inputable.release_input(already_handled):
				already_handled = true


func _on_body_entered(body):
	if not bubbleable or not bubbleable.bubbled:
		collide_sfx_player.play()
