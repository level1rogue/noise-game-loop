extends CanvasLayer

signal on_start_level_pressed
signal on_load_next_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_start_button_pressed() -> void:
	on_start_level_pressed.emit()


func _on_load_next_button_pressed() -> void:
	on_load_next_pressed.emit()
