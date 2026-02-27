extends HBoxContainer
class_name PriceLabel

@export var label_text: String = "Buy Item"
@export var cost: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_label(label_text, cost)

func set_label(text: String, _cost: int):
	$TextLabel.text = text + " ("
	$CostLabel.text = str(_cost) + ")"
