extends Node2D

var MIN_RADIUS := 20
var MAX_RADIUS := 45
var MAX_SIDES := 11
var MAX_OFFSET := 3
var MIN_RATIO := 1.5
var MAX_RATIO := 10.0
var MIN_SUB_DIVS := 0
var MAX_SUB_DIVS := 5

var rpctg := 40.0 # circumradius (from center to point) in percentage of screen
var r := 200 # circumradius in px
var n := 5 # nr. of sides = nr. of points / must be at least 3
var subs := 3 # nr. of sub divisions for each side
var offset := 10 # nr of pixels a polygon point might get offset randomly (range will be from -offset to offset)
var radius_ratio := 5.0 # fraction the inner radius is in relation to the outer radius
var orig_angle = PI/2 
var screen_center : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Debug only
	#get_tree().debug_collisions_hint = true
	
	$Menu.set_constraints({
		"min_radius": MIN_RADIUS,
		"max_radius": MAX_RADIUS,
		"max_sides": MAX_SIDES,
		"max_offset": MAX_OFFSET,
		"min_ratio": MIN_RATIO,
		"max_ratio": MAX_RATIO,
		"min_sub_divs": MIN_SUB_DIVS,
		"max_sub_divs": MAX_SUB_DIVS
	})
	$Menu.render_requested.connect(_on_render_requested)
	$Menu.start_requested.connect(_on_start_requested)
	$Menu.update_base_upgrades.connect($Player.update_base_upgrades)
	screen_center = get_viewport_rect().size / 2
	$Background.size = get_viewport_rect().size
	r = calc_radius(rpctg)
	render_polygon(n, r)
	

func calc_radius(radius_in_percent):
	# calc the pixel value of radius with screen height and percentage radius
	var screen_height = get_viewport_rect().size.y
	prints("screen y: ", screen_height)
	prints("radius:", (radius_in_percent / 100) * screen_height)
	return (radius_in_percent / 100) * screen_height

	
func calc_points(nr_of_points: int, radius: float, sub_divisions := 3):
	# a = 2R sin(π/n) 
	# var side_length = radius * 2 * sin(PI/nr_of_points)
	
	var ext_angle = PI*2 / nr_of_points
	
	var first_point_x = radius * cos(orig_angle)
	var first_point_y = radius * sin(orig_angle) *-1
	
	var line_points := []
	
	var offset_in_px = radius * (1 + offset) / 100
	var prev_point = null
	
	for i in (nr_of_points + 1):
		var angle = orig_angle + i * ext_angle
		var x = radius * cos(angle)# + randi_range(-offset_in_px, offset_in_px)
		var y = radius * sin(angle) *-1# + randi_range(-offset_in_px, offset_in_px)
		var curr_point = Vector2(x, y)
		
		prints("sub divs: ", sub_divisions)
		if sub_divisions > 0:
			if prev_point is not Vector2:
				prev_point = curr_point
			else:
				#var sub_div_points := []
				for sub in range(1, sub_divisions):
					var weight : float = float(sub) / float(sub_divisions)
					var new_point = prev_point.lerp(curr_point, weight)
					line_points.append(new_point)
				prev_point = curr_point
		line_points.append(curr_point)
		
		if i == 0:
			first_point_x = x
			first_point_y = y
	
	#line_points.append(Vector2(first_point_x, first_point_y)) # append 1st point at the end to close the polygon
	
	return line_points

func calc_lanes(inner_points, outer_points):
	var lanes_array := []
	var prev_i_point
	var prev_o_point
	
	for i in inner_points.size():
		var i_point = inner_points[i]
		var o_point = outer_points[i]
		if i == 0:
			prev_i_point = i_point
			prev_o_point = o_point
		else:
			var area = PolyLane.new()
			var lane = Polygon2D.new()
			var lane_gradient = GradientTexture1D.new()
			var lane_outline = Line2D.new()
			var outline_width_curve = Curve.new()
			var lane_outline_gradient = Gradient.new()
			var lane_col = CollisionPolygon2D.new()

			
			#lane.width = 2
			lane.position = screen_center
			lane.polygon = PackedVector2Array([prev_i_point, prev_o_point, o_point, i_point])
			#lane.uv = PackedVector2Array([
					#Vector2(0, 0),  # prev_i_point  → inner edge
					#Vector2(1, 0),  # prev_o_point  → outer edge
					#Vector2(1, 1),  # o_point       → outer edge
					#Vector2(0, 1)   # i_point       → inner edge
			#])

			var blue_value = randf_range(0.2, 0.4)
			var start_color = Color(0.1, 0.2, blue_value, 0.1)
			var end_color = Color(0.1, 0.2, blue_value, 0.9)
			
			var grad := Gradient.new()
			grad.colors = PackedColorArray([start_color, end_color])
			#grad.offsets = PackedFloat32Array([0.0, 1.0])
			lane_gradient.gradient = grad

			#lane.texture = lane_gradient
			lane.color = start_color
			
			lane_outline.position = lane.position
			lane_outline.points = PackedVector2Array([prev_i_point, prev_o_point])
			lane_outline.default_color = Color(0.98, 0.941, 0.62, 1.0)
			lane_outline.width = 1
			outline_width_curve.add_point(Vector2(0,0.5))
			outline_width_curve.add_point(Vector2(1,1))
			#lane_outline.width_curve = outline_width_curve
			lane_outline_gradient.colors = PackedColorArray([Color(0.49, 0.447, 0.073, 0.035), Color(0.173, 0.615, 0.791, 1.0)])
			lane_outline.gradient = lane_outline_gradient
			
			lane_col.position = lane.position
			lane_col.polygon = lane.polygon

			var lane_label = "Lane Nr. " + str(i)

			area.set("lane_label", lane_label)

			lanes_array.append(lane)
			area.add_child(lane)
			area.add_child(lane_outline)
			area.add_child(lane_col)

#			FIXME: signal for some reason not working anymore (worked before!)
			area.mouse_entered.connect(_on_lane_entered.bind(area))
			
			add_child(area)
			prev_i_point = i_point
			prev_o_point = o_point
	return lanes_array
	
	
func render_polygon(nr_of_sides, radius, sub_divisions := 3):
	orig_angle += randf() + 10.0
	
	var outer_line = Line2D.new()
	var inner_line = Line2D.new()
	outer_line.default_color = Color(0.1, 0.2, randf_range(0.2, 0.4))
	inner_line.default_color = Color(0.1, 0.2, randf_range(0.2, 0.4))
	
	var outer_points = calc_points(nr_of_sides, radius, sub_divisions)
	
	outer_line.width = 2
	outer_line.position = screen_center
	outer_line.points = outer_points
	add_child(outer_line)
	
	var inner_points = calc_points(nr_of_sides, radius / radius_ratio, sub_divisions)
	
	inner_line.width = 2
	inner_line.position = screen_center
	inner_line.points = inner_points
	add_child(inner_line)
	
	var array_of_lanes := []
	array_of_lanes = calc_lanes(inner_points, outer_points)


func _on_render_requested(data: Dictionary) -> void:
	$EnemySpawnMachine.stop_timer()
	n = data.n
	subs = data.subs
	rpctg = data.rpctg
	offset = data.offset
	radius_ratio = data.radius_ratio
	for child in get_children():
		if child is Area2D or child is Line2D:
			child.queue_free()
	r = calc_radius(rpctg)
	screen_center = get_viewport_rect().size / 2
	render_polygon(n, r, subs)
	#start_game_timer()


func _on_lane_entered(area: Area2D):
	prints("lane: ", area.lane_label)
	%InfoLabel.text = area.lane_label

func _on_start_requested(data: Dictionary):
	$EnemySpawnMachine.start_timer(data)
