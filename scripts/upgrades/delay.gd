extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2(0,0), 50, Color.RED)
