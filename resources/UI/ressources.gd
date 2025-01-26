extends VBoxContainer

@onready var red_label := $red_container/red_box/amount
@onready var blue_label := $blue_container/blue_box/amount
@onready var silver_label := $silver_container/silver_box/amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	red_label.text = "00"
	blue_label.text = "00"
	silver_label.text = "00"
	GameState.resources_changed.connect(update_amount)

func update_amount(amount :int, type :GameState.ResourceType) -> void:
	var new_text = str(amount) if amount >= 10 else "0" + str(amount)
	match (type):
		GameState.ResourceType.RED:
			red_label.text = new_text
		GameState.ResourceType.BLUE:
			blue_label.text = new_text
		GameState.ResourceType.SILVER:
			silver_label.text = new_text
