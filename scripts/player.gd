extends CharacterBody2D

const SPEED = 500.0
const OVERSHOOT_RADIUS = 5.0 #for smooth rendering when standstill

var shot_damage := 5
var shot_interval := 1.0

func _physics_process(delta: float) -> void:
	
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	
	if direction.length() > OVERSHOOT_RADIUS:
		velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func trigger_shot():
	$ShotArea.animate_shot()
	#$ShotAudio.play()
	
	var enemies = $ShotArea.get_targets()
	for enemy in enemies:
		print("overlap")
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
		$ShotArea.redraw_crosshair(data.shot_radius)
