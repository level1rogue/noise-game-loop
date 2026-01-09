extends Node2D
#
## crosshair (ch) variables
#var ch_radius := 80.0
#var ch_color := Color.LIGHT_GREEN
#var ch_width := 2.0
#var arc_length := ch_radius / 2 #degrees
#
#var right_arc_start_deg := 0 - (arc_length / 2) 
#var right_arc_end_deg := 0 + (arc_length / 2) 
#var down_arc_start_deg := 90 - (arc_length / 2) 
#var down_arc_end_deg := 90 + (arc_length / 2) 
#var left_arc_start_deg := 180 - (arc_length / 2) 
#var left_arc_end_deg := 180 + (arc_length / 2) 
#var up_arc_start_deg := 270 - (arc_length / 2) 
#var up_arc_end_deg := 270 + (arc_length / 2) 
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#queue_redraw()
#
#func _draw() -> void:
	## center dot
	#draw_circle(Vector2(0,0), 2, ch_color, true, 2.0, true)
	#
	## outer arcs
	#draw_arc(Vector2(0,0), ch_radius, deg_to_rad(right_arc_start_deg), deg_to_rad(right_arc_end_deg), 50, ch_color, ch_width, true)
	#draw_arc(Vector2(0,0), ch_radius, deg_to_rad(down_arc_start_deg), deg_to_rad(down_arc_end_deg), 50, ch_color, ch_width, true)
	#draw_arc(Vector2(0,0), ch_radius, deg_to_rad(left_arc_start_deg), deg_to_rad(left_arc_end_deg), 50, ch_color, ch_width, true)
	#draw_arc(Vector2(0,0), ch_radius, deg_to_rad(up_arc_start_deg), deg_to_rad(up_arc_end_deg), 50, ch_color, ch_width, true)
