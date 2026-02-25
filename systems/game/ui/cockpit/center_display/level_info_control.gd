extends Control

signal request_start_level

var tween: Tween

var level_info: String = "": set = _on_info_set

func fade_out():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	visible = false
	
func fade_in():
	if tween:
		tween.kill()
	tween = create_tween()
	modulate.a = 0.0
	visible = true
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
func _on_info_set(new_value):
	level_info = new_value
	%InfoLabel.text = level_info
	


func _on_start_button_pressed() -> void:
	request_start_level.emit()
	fade_out()
