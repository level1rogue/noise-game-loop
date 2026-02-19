extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func on_beat(beat):
	var tween = create_tween()
	tween.tween_property($BPMLight, "modulate", Color(0.0, 1.0, 0.698, 1.0), 0.05)
	tween.tween_property($BPMLight, "modulate", Color("2a2a2aff"), 0.2)
