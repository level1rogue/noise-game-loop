extends CharacterBody2D

const SPEED = 20000.0
const OVERSHOOT_RADIUS = 5.0 #for smooth rendering when standstill

var shot_damage := 5
var shot_interval := 1.0
var shot_radius := 50.0
var shot_effect = preload("res://scenes/shot_effect.tscn")

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
	
	# Spawn shot effect
	var effect = shot_effect.instantiate()
	effect.global_position = global_position
	effect.setup(shot_radius)
	get_parent().add_child(effect)
	
	var enemies = $ShotArea.get_targets()
	for enemy in enemies:
		if enemy.has_method("take_damage"):
			enemy.take_damage(shot_damage)

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
