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
		body.captured = true
		GameState.captured_resources += body.worth
		var tween := get_tree().create_tween()
		tween.tween_property(body, "scale", Vector2(0,0), 0.5)
		tween.parallel().tween_property(body, "global_position", Vector2(0,0), 0.5)
		tween.tween_callback(delete_body.bind(body))
		tween.play()

func delete_body(body :Node2D) -> void:
	body.queue_free()
