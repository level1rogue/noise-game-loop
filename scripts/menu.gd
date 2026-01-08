extends CanvasLayer

signal render_requested(data: Dictionary)
signal start_requested()

var constraints := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_input_value(name: String) -> String:
	var path := NodePath("%" + name)
	var node := get_node_or_null(path)
	if node is LineEdit:
		return node.text
	return ""

func set_constraints(c: Dictionary):
	constraints = c

func _on_calc_button_pressed() -> void:
	var n := int(%SidesInput.text)
	n = n if n >= 3 else 5

	var subs := int(%SubDivsInput.text)
	subs = subs if subs >= 0 else 3

	var rpctg := int(%RadiusInput.text)
	rpctg = rpctg if rpctg > 0 else 100

	var offset := int(%OffsetInput.text)
	offset = offset if offset >= 1 else 20

	var radius_ratio := float(%RatioInput.text)
	radius_ratio = radius_ratio if radius_ratio >= 1.5 else 3.0

	emit_signal("render_requested", {
		"n": n,
		"subs": subs,
		"rpctg": rpctg,
		"offset": offset,
		"radius_ratio": radius_ratio
	})


func _on_rng_button_pressed() -> void:
	%SidesInput.text = str(randi_range(3, constraints.max_sides))
	%SubDivsInput.text = str(randi_range(constraints.min_sub_divs, constraints.max_sub_divs))
	%RadiusInput.text = str(randi_range(constraints.min_radius, constraints.max_radius))
	%OffsetInput.text = str(randi_range(1, constraints.max_offset))
	%RatioInput.text = str(snapped(randf_range(constraints.min_ratio, constraints.max_ratio), 0.01))
	_on_calc_button_pressed()


func _on_start_button_pressed() -> void:
	var init_enemies := int(%InitEnemyInput.text)
	var timer_interval := int(%TimerIntervalInput.text)
	var enemy_max_speed := float(%EnemyMaxSpeedInput.text)
	emit_signal("start_requested", {
		"init_enemies": init_enemies,
		"timer_interval": timer_interval,
		"enemy_max_speed": enemy_max_speed
	})
