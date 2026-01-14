extends CharacterBody2D

const SPEED = 20000.0
const OVERSHOOT_RADIUS = 5.0 #for smooth rendering when standstill

var shot_damage := 5
var shot_interval := 1.0
var shot_radius := 50.0
var shot_effect = preload("res://scenes/shot_effect.tscn")

# Upgrades Dictionary of Upgrade Strategies
var upgrades : Dictionary = {} # key = upgrade_type, value = strategy

var upgrade_strategies := {
	"delay": PlayerDelayStrategy
}

func _process(delta: float) -> void:
	
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	
	if direction.length_squared() > OVERSHOOT_RADIUS * OVERSHOOT_RADIUS:
		velocity = direction.normalized() * SPEED * delta
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func trigger_shot():
	$ShotArea.animate_shot()
	#$ShotAudio.play()
	
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

	for body in shot_area.get_overlapping_bodies():
		prints("overlapping:", body)
		if body.has_method("take_damage"):
			body.take_damage(shot_data.damage)
			
	shot_area.queue_free()

func _on_shot_timer_timeout() -> void:
	trigger_shot()
	
func update_base_upgrades(data: Dictionary):
	if data.shot_damage != null:
		shot_damage = data.shot_damage
	if data.shot_interval != null:
		shot_interval = data.shot_interval
		$ShotTimer.wait_time = shot_interval
	if data.shot_radius != null:
		shot_radius = data.shot_radius
		$ShotArea.redraw_crosshair(data.shot_radius)
		
func update_special_upgrades(upgrade_type, is_applied):
	if is_applied:
		if not upgrade_type in upgrades:
			upgrades[upgrade_type] = upgrade_strategies[upgrade_type].new()
	else:
		if upgrade_type in upgrades:
			upgrades.erase(upgrade_type)
		
