extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tween = create_tween()
	#tween.set_parallel(true)
	tween.tween_property(%CountInLabel, "modulate:a", 0.0, 0.2)
	tween.parallel().tween_property($Container, "scale", Vector2(8.0, 8.0), 1.8)
	tween.tween_callback(queue_free)
	pass

func set_text(text: String):
	$%CountInLabel.text = text
