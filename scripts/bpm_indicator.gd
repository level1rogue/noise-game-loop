extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	
	draw_circle(Vector2(0,0), 8, Color.WHITE, true, -1.0, true)
	
func on_beat(beat):
	modulate.a = 1.0
	queue_redraw()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	#tween.tween_callback(queue_free)
