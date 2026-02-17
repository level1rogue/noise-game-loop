extends CanvasLayer

signal on_start_level_pressed
signal on_load_next_pressed


var cursor_point = load("res://assets/graphics/mouse_cursors/cursor_point.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_CROSS, Vector2(6, 6))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_start_button_pressed() -> void:
	on_start_level_pressed.emit()


func _on_load_next_button_pressed() -> void:
	on_load_next_pressed.emit()
