extends CharacterBody2D

const SPEED := 80000.0
const OVERSHOOT_RADIUS := 6.0 #for smooth rendering when standstill
const TOTAL_STEPS := 16

var initial_shot_step_index := 8
var active_seq_steps : Dictionary = {}

var shot_damage := 5
var shot_interval := 1.0
var shot_radius := 20.0
var shot_effect = preload("res://scenes/effects/shot_effect.tscn")
var shockwave_effect = preload("res://scenes/effects/shockwave_effect.tscn")

var boundary_left : float
var boundary_right : float

# Upgrades Dictionary of Upgrade Strategies
var upgrades : Dictionary = {} # key = upgrade_type, value = strategy

var upgrade_strategies := {
	"delay": PlayerDelayStrategy,
	"shockwave": PlayerShockwaveStrategy,
}

func _physics_process(delta: float) -> void:
	
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var distance = direction.length()
	
	if mouse_pos.x > boundary_left and mouse_pos.x < boundary_right:
		var max_step = SPEED * delta

		if distance <= max_step:
			# Snap exactly to cursor when close enough
			velocity = direction / delta
		else:
			velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	# Snap to pixel grid
	#global_position = global_position.round()

func set_initial_seq_steps(data: Dictionary):
	for step in TOTAL_STEPS:
		active_seq_steps[step] = ""
	for i in data:
		active_seq_steps[i] = data[i]

func set_movement_bounds(bound_left, bound_right):
	boundary_left = bound_left
	boundary_right = bound_right

func trigger_shot():
	%ShotArea.animate_shot()
	$ShotAudio.play()
	
	var shot_data = ShotData.new()
	shot_data.position = global_position
	shot_data.damage = shot_damage
	shot_data.radius = shot_radius
	
	_execute_shot(shot_data)
	
	# Apply upgrades
	for upgrade in upgrades.values():
		if upgrade.has_method("on_shot_fired"):
			upgrade.on_shot_fired(self, shot_data)

func _execute_shot(shot_data: ShotData):
	# Spawn shot effect
	var effect = shot_effect.instantiate()
	effect.global_position = shot_data.position
	effect.setup(shot_data.radius)
	get_parent().add_child(effect)
	
	# Deal damage in area
	var shot_area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = shot_data.radius
	collision.shape = shape
	shot_area.add_child(collision)
	shot_area.global_position = shot_data.position
	shot_area.collision_mask = 2
	get_parent().add_child(shot_area)
	
	await get_tree().process_frame # Wait for physics to detect overlapping
	await get_tree().process_frame # Wait for physics to detect overlapping

	if shot_area.has_overlapping_bodies():
		for body in shot_area.get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage(shot_data.damage)
			
	shot_area.queue_free()

func _execute_sweep_shot(shot_data: ShotData, target_radius: float, damage: int):
	var effect = shockwave_effect.instantiate()
	effect.global_position = shot_data.position
	effect.setup(shot_data.radius, target_radius, damage)
	get_parent().add_child(effect)
	
	

#func _on_shot_timer_timeout() -> void:
	#trigger_shot()
	
func update_base_upgrades(data: Dictionary):
	if data.shot_damage != null:
		shot_damage = data.shot_damage
	if data.shot_interval != null:
		shot_interval = data.shot_interval
		#$ShotTimer.wait_time = shot_interval
	if data.shot_radius != null:
		shot_radius = data.shot_radius
		%ShotArea.redraw_crosshair(data.shot_radius)
		
func update_special_upgrades(upgrade_type, is_applied):
	if is_applied:
		if not upgrade_type in upgrades:
			upgrades[upgrade_type] = upgrade_strategies[upgrade_type].new()
	else:
		if upgrade_type in upgrades:
			upgrades.erase(upgrade_type)
		
func _on_step(step: int):
	var active_step = step % TOTAL_STEPS
	if active_seq_steps[active_step]:
		match active_seq_steps[active_step]:
			"basic_shot":
				trigger_shot()
				
