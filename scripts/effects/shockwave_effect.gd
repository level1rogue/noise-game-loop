extends Node2D

var start_radius := 50.0
var target_radius := 200.0
var current_radius := 50.0
var duration := 0.5
var elapsed := 0.0
var ring_width := 10.0
var effect_color := Color.DARK_ORCHID
func _ready() -> void:
	queue_redraw()
	
func _process(delta: float) -> void:
	elapsed += delta
	var progress = elapsed / duration
	
	if progress >= 1.0:
		queue_free()
		return
	
	current_radius = lerp(start_radius, target_radius, progress)
	queue_redraw()
	
func _draw() -> void:
	draw_arc(Vector2.ZERO, current_radius, 0, TAU, 64, effect_color, ring_width * 0.3, true)
	draw_circle(Vector2.ZERO, current_radius, Color(effect_color, 0.2), true, -1.0, true)
	modulate.a = 1.0 - (elapsed / duration)
	
func setup(initial_radius: float, end_radius: float, shockwave_duration: float = 0.5, updated_ring_width: float = ring_width):
	start_radius = initial_radius
	current_radius = initial_radius
	target_radius = end_radius
	duration = shockwave_duration
	ring_width = updated_ring_width
	queue_redraw()
