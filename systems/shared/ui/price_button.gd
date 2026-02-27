extends Button
class_name PriceButton

@export var label_text: String = "Text set by Button"
@export var cost: int = 120

func _ready() -> void:
	set_label(label_text, cost)
	#await get_tree().process_frame
	#custom_minimum_size = $PriceLabel.size

func set_label(_text: String, _cost: int):
	$PriceLabel.set_label(_text, _cost)
	self.text = _text + "(C " + str(_cost) + ")"
