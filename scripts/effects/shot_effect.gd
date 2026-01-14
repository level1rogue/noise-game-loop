extends Node2D

var radius := 50.0
var duration := 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()
	
	# Fade out and destroy
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, duration)
	tween.tween_callback(queue_free)

func _draw() -> void:
	#draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Color.CRIMSON, 2.0, true)
	draw_circle(Vector2.ZERO, radius, Color.CRIMSON, false, 2.0, true)
func setup(effect_radius: float) -> void:
	radius = effect_radius
	queue_redraw()
