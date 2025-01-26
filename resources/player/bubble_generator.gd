extends Node2D
class_name BubbleGenerator

signal bubbleup_canceled

@export var generation_area_threshold = 0.85
@export var auto_close_gap_distance = 30
@export var min_draw_step_size = 2
@export var base_line_thickness = 3
@export var debug_draw := false

static var can_draw := true
var is_drawing := false
var points: PackedVector2Array = []
var debug_draw_poly: PackedVector2Array
var debug_target_rect: Rect2
var debug_query_rect: Rect2

@onready var cam: Camera2D = $"../PlayerCam"
@onready var draw_sfx_player: AudioStreamPlayer = $Draw

func _physics_process(_delta) -> void:
	if debug_draw and Input.is_action_just_pressed("ui_cancel"):
		debug_draw_poly.clear()
		debug_target_rect = Rect2()
		debug_query_rect = Rect2()
		queue_redraw()
	
	if is_drawing or points.size() == 0: return
	
	if GameState.cur_bubbles >= GameState.max_bubbles:
		bubbleup_canceled.emit()
		points.clear()
		queue_redraw()
		prints("No bubble, because max amount of bubbles reached")
		return
	
	var begin_end_distance := points[0].distance_to(points[-1])
	if begin_end_distance > auto_close_gap_distance:
		points.clear()
		queue_redraw()
		prints("No bubble, because end points are too far apart:", begin_end_distance)
		return
	
	var space_state = get_world_2d().direct_space_state
	var query := PhysicsShapeQueryParameters2D.new()
	var q_shape := ConvexPolygonShape2D.new()
	q_shape.set_point_cloud(points)
	query.shape = q_shape
	var result := space_state.intersect_shape(query)
	
	var q_rect = q_shape.get_rect()
	debug_query_rect = q_rect
	
	var max_ratio := 0.0
	var t_node: Spobject
	var t_rect
	
	prints("Number of collision check results:", result.size())
	
	for collission_data in result:
		var collider = collission_data["collider"] as Spobject
		if collider:
			var col_shapes := collider.find_children("*", "CollisionShape2D", false)
			var col_rect := Rect2(col_shapes[0].global_position, Vector2.ZERO)
			for col_shape in col_shapes:
				var shape_rect: Rect2 = col_shape.shape.get_rect()
				shape_rect.position = col_shape.global_position - shape_rect.size/2
				col_rect = col_rect.merge(shape_rect)
			
			var intersection = col_rect.intersection(q_rect)
			var ratio = intersection.get_area() / col_rect.get_area()
			if ratio > max_ratio:
				max_ratio = ratio
				t_node = collider
				t_rect = col_rect
				debug_target_rect = t_rect
		else:
			print("Collider is no Spobject")
			
	if max_ratio >= generation_area_threshold:
		if t_node.bubbleable:
			print(t_node.bubbleable.bubbled)
			if not t_node.bubbleable.bubbled:
				t_node.bubbleable.bubble_up()
				GameState.cur_bubbles += 1
				print("Successfully bubbled up")
			else:
				print("Spobject is already bubbled")
		else:
			print("Spobject has no bubbleable component")
	else:
		prints("No bubble because intersection ratio is too low:", max_ratio)
		printt("target rect", t_rect)
		printt("query rect", q_rect)
	points.clear()
	queue_redraw()
		

func _unhandled_input(event):
	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
		if not can_draw: return
		if not draw_sfx_player.playing: draw_sfx_player.play()
		 
		var new_pos := mouse_to_screen_pos(event.position)
		
		if points.size() > 0:
			var distance_to_last: float = new_pos.distance_to(points[-1])
			if distance_to_last < min_draw_step_size:
				return
		
		for i in range(0, points.size()-2):
			var intersection = Geometry2D.segment_intersects_segment(points[i], points[i+1], new_pos, points[-1])
			if intersection is Vector2:
				draw_sfx_player.stop()
				is_drawing = false
				can_draw = false
				points.append(intersection)
				points = points.slice(i+1, points.size())
				debug_draw_poly = points.duplicate()
				queue_redraw()
				return
		
		points.append(new_pos)
		queue_redraw()
		
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT: 
		is_drawing = event.pressed
		if not is_drawing:
			draw_sfx_player.stop()
			can_draw = true
			debug_draw_poly = points.duplicate()
			

func _draw():
	if points.size() > 1:
		draw_polyline(points, Color.RED, base_line_thickness / cam.zoom.x)
	
	if not debug_draw: return
	draw_rect(debug_target_rect, Color(Color.RED, 0.5))
	draw_rect(debug_query_rect, Color(Color.WEB_GREEN, 0.5))
	var colors := PackedColorArray()
	colors.append(Color(Color.YELLOW, 0.5))
	if debug_draw_poly.size() > 2:
		draw_polygon(debug_draw_poly, colors)
	

func mouse_to_screen_pos(pos: Vector2) -> Vector2:
	return pos / cam.zoom - get_viewport_rect().size / (cam.zoom * 2) + cam.position
