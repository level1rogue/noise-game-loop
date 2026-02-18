extends Node2D

const MIN_RADIUS := 20
const MAX_RADIUS := 45
const MAX_SIDES := 11
const MAX_OFFSET := 3
const MIN_RATIO := 1.5
const MAX_RATIO := 10.0
const MIN_SUB_DIVS := 0
const MAX_SUB_DIVS := 5

var rpctg := 40.0 # circumradius (from center to point) in percentage of screen
var r := 200 # circumradius in px
var n := 5 # nr. of sides = nr. of points / must be at least 3
var subs := 3 # nr. of sub divisions for each side
var offset := 10 # nr of pixels a polygon point might get offset randomly (range will be from -offset to offset)
var radius_ratio := 8.0 # fraction the inner radius is in relation to the outer radius
var orig_angle = PI/2 
var screen_center : Vector2

var player_bounds_left : float
var player_bounds_right : float

var initial_player_steps := {
		0: "basic_shot",
		8: "basic_shot"
	}

var loaded_level: LevelData

var count_in_label = load("res://scenes/ui/count_in.tscn")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Debug only
	#get_tree().debug_collisions_hint = true
	
	$OverlayMenu.set_constraints({
		"min_radius": MIN_RADIUS,
		"max_radius": MAX_RADIUS,
		"max_sides": MAX_SIDES,
		"max_offset": MAX_OFFSET,
		"min_ratio": MIN_RATIO,
		"max_ratio": MAX_RATIO,
		"min_sub_divs": MIN_SUB_DIVS,
		"max_sub_divs": MAX_SUB_DIVS
	})
	$OverlayMenu.render_requested.connect(_on_render_requested)
	$OverlayMenu.start_requested.connect(_on_start_requested)
	$OverlayMenu.toggle_pause_game.connect(_on_toggle_pause)
	$OverlayMenu.update_base_upgrades.connect(%Player.update_base_upgrades)
	$OverlayMenu.update_special_upgrades.connect(%Player.update_special_upgrades)
	
	
	
	$WorldClock.step.connect(%Player._on_step)
	$WorldClock.step.connect($CockpitLayer/%Sequencer.on_step_progress)
	$WorldClock.beat.connect($CockpitLayer/%Sequencer.on_beat_progress)
	$WorldClock.bar.connect($CockpitLayer/%Sequencer.on_bar_progress)
	$WorldClock.count_in_beat.connect(_on_count_in)
	$WorldClock.level_started.connect(_start_level)
	$WorldClock.request_level_ended.connect(_on_level_ended)
	screen_center = get_viewport_rect().size / 2
	var screen_size = get_viewport_rect().size
	$Background.size = screen_size
	load_next_level()
	
	var bound_size_by_ratio = screen_size.x / 5
	var bound_size_by_height = (screen_size.x - screen_size.y) / 2
	var bound_size = maxf(bound_size_by_ratio, bound_size_by_height)
	player_bounds_left = bound_size
	player_bounds_right = screen_size.x - bound_size
	%Player.set_movement_bounds(player_bounds_left, player_bounds_right)	
	%Player.set_initial_seq_steps(initial_player_steps)
	#$CockpitUI.on_start_level_pressed.connect(_on_start_requested)
	#$CockpitUI.on_load_next_pressed.connect(load_next_level)
	#$CockpitUI/%Sequencer.set_initial_seq_steps(initial_player_steps)
	
	$CockpitLayer.start_level.connect(_on_start_requested)
	$CockpitLayer.load_next_level.connect(load_next_level )
	$CockpitLayer/%Sequencer.set_initial_seq_steps(initial_player_steps)
	
	$EnemySpawnMachine.on_add_to_credits.connect(on_credit_change)
	#$EnemySpawnMachine.on_add_to_credits.connect($CockpitLayer/%DisplayControl.on_credit_change)
	
func calc_radius(radius_in_percent):
	# calc the pixel value of radius with screen height and percentage radius
	var screen_height = get_viewport_rect().size.y
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

			var blue_value = randf_range(0.05, 0.2)
			var start_color = Color(0.06, 0.1, blue_value, 0.35)
			var end_color = Color(0.1, 0.2, blue_value, 1.0)
			
			var grad := Gradient.new()
			grad.colors = PackedColorArray([start_color, end_color])
			#grad.offsets = PackedFloat32Array([0.0, 1.0])
			lane_gradient.gradient = grad

			#lane.texture = lane_gradient
			lane.color = start_color
			
			lane_outline.position = lane.position
			lane_outline.points = PackedVector2Array([prev_i_point, prev_o_point])
			lane_outline.default_color = Color(0.98, 0.941, 0.62, 1.0)
			lane_outline.width = 2
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
	inner_line.default_color = Color(0.06, 0.1, randf_range(0.1, 0.2))
	
	var outer_points = calc_points(nr_of_sides, radius, sub_divisions)
	
	outer_line.width = 3
	outer_line.antialiased = true
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
	%InfoLabel.text = area.lane_label

func _on_destroy_level():
	for child in get_children():
		if child is Area2D or child is Line2D:
			child.queue_free()

func _on_start_requested():
	_start_level_count_in()
	
func _start_level_count_in():
	if not get_tree().paused:
		$WorldClock.setup_level_and_start_clock(loaded_level)
		
func _start_level():
	#count_in_label.set_finished()
	if not get_tree().paused:
		$EnemySpawnMachine.start_timer(loaded_level)

func _create_level():
	_on_destroy_level()
	n = loaded_level.polygon_sides
	subs = loaded_level.polygon_sub_divs
	r = calc_radius(rpctg)
	render_polygon(n, r)

func _on_toggle_pause(button: Button):
	if get_tree().paused:
		get_tree().paused = false
		button.text = "Pause"
	else:
		get_tree().paused = true
		button.text = "Resume"

func _on_count_in(beat: int) -> void:
	var label = count_in_label.instantiate()
	add_child(label)
	label.set_text(str(beat))

func _on_level_ended():
	_on_destroy_level()
	$EnemySpawnMachine.end_level()
	$CockpitLayer/%Sequencer.set_finished()
	$RewardScreen.set_level_rewards(loaded_level)

func load_next_level():
	$WorldClock.stop_level()
	loaded_level = $LevelManager.load_next_level()
	$CockpitLayer/%Sequencer.set_initial_bars(loaded_level.duration)
	_create_level()
	
func on_credit_change(amount: int):
	$Player.on_credit_change(amount)
	$CockpitLayer/%DisplayControl.on_credit_change()	
	
		
