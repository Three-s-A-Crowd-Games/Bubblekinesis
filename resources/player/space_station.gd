class_name SpaceStation

extends StaticBody2D

@export var net_rotation_speed :float = 0.05

@onready var Sprite := $StationSprite

@onready var Net := $Net
@onready var target_rot = $Net.rotation

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action("rmb") or event is InputEventMouseMotion and Input.is_action_pressed("rmb"):
		target_rot = self.global_position.angle_to_point(get_global_mouse_position()) + PI/2

func _process(delta :float) -> void:
	if Net.rotation != target_rot:
		Net.rotation = rotate_toward(Net.rotation, target_rot, net_rotation_speed)


func _on_capture_area_body_entered(body: Node2D) -> void:
	if body is Spobject and body.type == Spobject.Type.RESOURCE:
		GameState.captured_resources += body.worth
		body.queue_free()
