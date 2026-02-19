extends CanvasLayer

var count_in_label = load("res://scenes/ui/count_in.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_count_in(beat: int) -> void:
	var label = count_in_label.instantiate()
	add_child(label)
	label.set_text(str(beat))
	
