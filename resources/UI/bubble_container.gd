extends HBoxContainer

var tex_recs = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(GameState.max_bubbles):
		add_bubble()
	GameState.upgraded_max_bubbles.connect(add_bubble)
	GameState.new_cur_bubbles.connect(redo_tex)

func add_bubble() -> void:
	var tex_rec = TextureRect.new()
	tex_rec.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	add_child(tex_rec)
	tex_recs.append(tex_rec)
	redo_tex(GameState.cur_bubbles)

func redo_tex(amount :int) -> void:
	for i in range(tex_recs.size()):
		if i < amount:
			tex_recs[i].texture = load("res://assets/sprites/UI/bubble.png")
		else:
			tex_recs[i].texture = load("res://assets/sprites/UI/bubble_gray.png")
