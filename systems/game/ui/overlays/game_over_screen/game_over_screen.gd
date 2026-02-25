extends CanvasLayer

signal request_restart

func _on_restart_button_pressed() -> void:
	request_restart.emit()
