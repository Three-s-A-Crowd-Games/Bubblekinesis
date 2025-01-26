class_name Flickable

extends Inputable

@export var impuls_strength := 1.0
@export var min_distance := 5
@export_group("Arrow", "arrow")
@export var arrow_max_drag_distance := 20
@export var arrow_color_gradient: Gradient = preload("res://resources/components/flickable_arrow_gradient.tres")
@export_subgroup("Head", "arrow_head")
@export var arrow_head_min_scale := 0.3
@export var arrow_head_max_scale := 1
@export var arrow_head_texture: Texture2D = preload("res://assets/sprites/arrow_tip.png")
@export_subgroup("Stem", "arrow_stem")
@export var arrow_stem_min_width := 1
@export var arrow_stem_max_width := 4

var dragging := false
var init_pos :Vector2
var min_distance_reached := false

var line := Line2D.new()
var arrow_head := Sprite2D.new()
var body: RigidBody2D

func _init(spobj: RigidBody2D):
	body = spobj
	spobj.input_pickable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	arrow_head.texture = arrow_head_texture
	add_child(line)
	add_child(arrow_head)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dragging: return
	
	var t_pos: Vector2 = line.get_local_mouse_position()
	
	if init_pos.distance_to(t_pos) < min_distance and min_distance_reached:
		min_distance_reached = false
		hide()
	elif init_pos.distance_to(t_pos) > min_distance and not min_distance_reached:
		min_distance_reached = true
		show()
	
	if not min_distance_reached:
		return
	if not visible:
		show()
	
	var distance: float = t_pos.length()
	if distance > arrow_max_drag_distance:
		t_pos = t_pos.limit_length(arrow_max_drag_distance)
		distance = arrow_max_drag_distance
	
	var distance_ratio = distance/arrow_max_drag_distance
	var color = arrow_color_gradient.sample(distance_ratio)
	
	line.points[1] = -t_pos
	line.width = lerpf(arrow_stem_min_width, arrow_stem_max_width, distance_ratio)
	line.default_color = color
	
	arrow_head.position = -t_pos
	arrow_head.rotation = t_pos.angle() - PI/2
	arrow_head.scale = Vector2.ONE * lerpf(arrow_head_min_scale, arrow_head_max_scale, distance_ratio)
	arrow_head.modulate = color

func input() -> void:
	init_pos = line.get_local_mouse_position()
	dragging = true

func release_input() -> bool:
	dragging = false
	
	if min_distance_reached:
		var dir := line.to_global(line.points[1]) - body.global_position
		body.apply_central_impulse(dir * impuls_strength)
		hide()
		return true
	return false
