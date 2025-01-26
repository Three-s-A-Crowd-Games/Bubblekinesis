extends Node2D

@onready var Play_Area_Coll := $PlayArea/CollisionShape2D
@onready var Next_Area_Coll := $NextArea/CollisionShape2D

@onready var Fog_Noise :FastNoiseLite = $Fog.material.get_shader_parameter("NOISE_TEX").noise

var noisy = FastNoiseLite.new()
var star_noise = FastNoiseLite.new()
var bg_size = 2058

var time_to_next_spawn :float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Play_Area_Coll.shape.size = GameState.play_area * 2
	var next_size = GameState.play_area_upgrades[GameState.cur_play_area_upgrade+1]
	Next_Area_Coll.shape.size = Vector2(next_size, next_size) * 2
	
	noisy.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noisy.frequency = 10
	noisy.fractal_gain = 1.5
	var tex = ImageTexture.new()
	tex.set_image(noisy.get_image((GameState.play_area.x * 2) / 48, (GameState.play_area.y * 2) / 48))
	$Sprite2D.texture = tex
	
	star_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	star_noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	star_noise.seed = randi()
	star_noise.frequency = 0.35
	star_noise.fractal_octaves = 2
	star_noise.fractal_gain = 0.3
	star_noise.fractal_lacunarity = 5.0
	
	var star_array :PackedByteArray = []
	for x in range(bg_size):
		for y in range(bg_size):
			if star_noise.get_noise_2d(x,y) > 0.6:
				star_array.append(255)
			else:
				star_array.append(0)
	
	var star_tex = ImageTexture.new()
	star_tex.set_image(Image.create_from_data(bg_size,bg_size, false, Image.FORMAT_L8, star_array))
	$Parallax2D/Sprite2D.texture = star_tex
	
	Fog_Noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	Fog_Noise.frequency = 0.025
	Fog_Noise.fractal_gain = 0.15
	Fog_Noise.fractal_lacunarity = 2
	Fog_Noise.fractal_octaves = 6
	
	GameState.upgraded_play_area.connect(radar_upgrade)
	
	init_spawns()

func _process(delta :float) -> void:
	Fog_Noise.offset.x += delta
	Fog_Noise.offset.y += delta * 1.5
	Fog_Noise.offset.z += delta * 3
	time_to_next_spawn -= delta
	if time_to_next_spawn <= 0:
		spawn_new_spobjects()
		time_to_next_spawn = randf_range(10,30)


func init_spawns() -> void:
	noisy.seed = randi()
	for x in range((GameState.play_area.x * 2) / 48):
		for y in range((GameState.play_area.y * 2) / 48):
				spawn_new_spobj(x,y, true)

func spawn_new_spobj(x :int, y :int, cur_area :bool = false) -> void:
	var cur_x_real :int
	var cur_y_real :int
	if cur_area:
		cur_x_real = -GameState.play_area.x + (24 + x * 48)
		cur_y_real = -GameState.play_area.y + (24 + y * 48)
	else:
		cur_x_real = -GameState.play_area_upgrades[GameState.cur_play_area_upgrade + 1] + (24 + x * 48)
		cur_y_real = -GameState.play_area_upgrades[GameState.cur_play_area_upgrade + 1] + (24 + y * 48)
	
	# Lets see if we actually want to add
	if cur_area or (
		cur_x_real < -GameState.play_area.x or cur_x_real > GameState.play_area.x or
		cur_y_real < -GameState.play_area.y or cur_y_real > GameState.play_area.y):
			var noise = noisy.get_noise_2d(x,y) + 1
			if noise >= 1.0:
				var newspobj = load("res://resources/spobject/spobject.tscn").instantiate()
				var jitter := Vector2(randi_range(-16,16),randi_range(-16,16))
				newspobj.position = Vector2(cur_x_real, cur_y_real) + jitter
				$Spobjects.add_child(newspobj)
				var rect = newspobj.Sprite.get_rect()
				rect.position = newspobj.global_position - rect.size/2
				if rect.intersects($SpaceStation/Net.get_rect()):
					newspobj.queue_free()

func spawn_new_spobjects() -> void:
	noisy.seed = randi()
	for x in range((GameState.play_area_upgrades[GameState.cur_play_area_upgrade + 1] * 2) / 48):
		for y in range((GameState.play_area_upgrades[GameState.cur_play_area_upgrade + 1] * 2) / 48):
			spawn_new_spobj(x,y)
	
func radar_upgrade(size :Vector2) -> void:
	var act_size = size * 2
	$Fog.size = act_size
	$Fog.position = size * -1
	var red_tex :GradientTexture2D = $Fog.material.get_shader_parameter("RED_TEXTURE")
	var fog_tex :NoiseTexture2D = $Fog.material.get_shader_parameter("NOISE_TEX")
	red_tex.width = act_size.x
	red_tex.height = act_size.y
	fog_tex.width = act_size.x
	fog_tex.height = act_size.y
	
	Play_Area_Coll.shape.size = GameState.play_area * 2
	var next_size = GameState.play_area_upgrades[GameState.cur_play_area_upgrade+1]
	Next_Area_Coll.shape.size = Vector2(next_size, next_size) * 2

func _on_play_area_body_exited(body: Node2D) -> void:
	if body is Spobject:
		if body.bubbleable and body.bubbleable.bubbled:
			GameState.cur_bubbles -= 1
		body.queue_free()
		
func _on_next_area_body_exited(body: Node2D) -> void:
	if body is Spobject:
		if body.bubbleable and body.bubbleable.bubbled:
			GameState.cur_bubbles -= 1
		body.queue_free()
