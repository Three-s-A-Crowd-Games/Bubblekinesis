extends Node2D

@onready var Play_Area_Coll := $PlayArea/CollisionShape2D
@onready var Next_Area_Coll := $NextArea/CollisionShape2D

var noisy = FastNoiseLite.new()

var time_to_next_spawn := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Play_Area_Coll.shape.size = GameState.play_area * 2
	Next_Area_Coll.shape.size = Vector2() * 2
	
	noisy.frequency = 10
	noisy.fractal_gain = 2
	var tex = ImageTexture.new()
	tex.set_image(noisy.get_image((GameState.play_area.x * 2) / 48, (GameState.play_area.y * 2) / 48))
	$Sprite2D.texture = tex
	
	init_spawns()

func init_spawns() -> void:
	noisy.seed = randi()
	for x in range((GameState.play_area.x * 2) / 48):
		for y in range((GameState.play_area.y *2) / 48):
			var noise = noisy.get_noise_2d(x,y)
			if noise > 0.02:
				spawn_new_spobj(x,y)
	

func _process(delta :float) -> void:
	time_to_next_spawn -= delta
	if time_to_next_spawn <= 0:
		spawn_new_spobjects()
		time_to_next_spawn = randf_range(2,10)

func spawn_new_spobj(x :int, y :int) -> void:
	var newspobj = load("res://resources/spobject/spobject.tscn").instantiate()
	var jitter := Vector2(randi_range(-16,16),randi_range(-16,16))
	newspobj.position = Vector2(-GameState.play_area.x + (x*48+24),-GameState.play_area.y + (y*48+24)) + jitter
	$Spobjects.add_child(newspobj)
	var rect = newspobj.Sprite.get_rect()
	rect.position = newspobj.global_position - rect.size/2
	if rect.intersects($SpaceStation.Sprite.get_rect()):
		newspobj.queue_free()

func spawn_new_spobjects() -> void:
	pass


func _on_play_area_body_exited(body: Node2D) -> void:
	if body is Spobject:
		body.queue_free()
		
func _on_next_area_body_exited(body: Node2D) -> void:
	if body is Spobject:
		body.queue_free()
