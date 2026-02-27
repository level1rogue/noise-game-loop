class_name DissipatingLabel
extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos_y = position.y
	var tween = create_tween()
	#tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "position:y", pos_y - 20, 1.2)
	tween.tween_property(self, "position:y", pos_y - 100, 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_callback(queue_free)

func set_label_text(value: String):
	text = value
