extends Area2D

# crosshair (ch) variables
var ch_radius := 40.0
var ch_color := Color.LIGHT_GREEN
var ch_width := 4.0
var arc_length := ch_radius / 0.9 #degrees

var right_arc_start_deg := 0 - (arc_length / 2) 
var right_arc_end_deg := 0 + (arc_length / 2) 
var down_arc_start_deg := 90 - (arc_length / 2) 
var down_arc_end_deg := 90 + (arc_length / 2) 
var left_arc_start_deg := 180 - (arc_length / 2) 
var left_arc_end_deg := 180 + (arc_length / 2) 
var up_arc_start_deg := 270 - (arc_length / 2) 
var up_arc_end_deg := 270 + (arc_length / 2) 

var recoil := 0.0

func _ready() -> void:
	queue_redraw()

func _process(delta):
	recoil = lerp(recoil, 0.0, 1.0 - exp(-delta * 10.0))
	if recoil > 0.01:

		queue_redraw()

func _draw() -> void:
	# draw center dot
	draw_circle(Vector2(0,0), 4, ch_color, false, 4.0, true)
	
	# draw outer arcs
	var radius = ch_radius + recoil * 12.0
	
	draw_arc(Vector2(0,0), radius, deg_to_rad(right_arc_start_deg), deg_to_rad(right_arc_end_deg), 50, ch_color, ch_width, true)
	draw_arc(Vector2(0,0), radius, deg_to_rad(down_arc_start_deg), deg_to_rad(down_arc_end_deg), 50, ch_color, ch_width, true)
	draw_arc(Vector2(0,0), radius, deg_to_rad(left_arc_start_deg), deg_to_rad(left_arc_end_deg), 50, ch_color, ch_width, true)
	draw_arc(Vector2(0,0), radius, deg_to_rad(up_arc_start_deg), deg_to_rad(up_arc_end_deg), 50, ch_color, ch_width, true)
func redraw_crosshair(radius):
	ch_radius = radius
	queue_redraw()
	# Update/recreate collision shape
	_update_collision()

func _update_collision():
	var shape := CircleShape2D.new()
	shape.radius = ch_radius
	$ShotCollision.shape = shape

func animate_shot():
	recoil = 1.0
	
func get_targets():
	return get_overlapping_bodies()

func set_radius(radius: float):
	ch_radius = radius
	queue_redraw()
