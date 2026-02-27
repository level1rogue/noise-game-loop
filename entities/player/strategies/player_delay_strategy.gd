class_name PlayerDelayStrategy extends PlayerBaseStrategy

var upgrade_system = GlobalData.upgrade_system

var delay_repeats : int = upgrade_system.get_level("effect_delay") + 1
var delay_power := 0.75 # % of original shot power
var delay_radius := 0.75 # % of original shot radius
var delay_interval := 0.15

func apply_upgrade(level: int):
	prints("delay upgrade applied:", level)
	delay_repeats = level + 1

func on_shot_fired(player: CharacterBody2D, shot_data: ShotData):
	
	var used_angles : Array[float] = []
	var min_angle_distance := PI * 0.5  # 90 degrees minimum between shots
		
	for i in range(delay_repeats):
		await player.get_tree().create_timer(delay_interval).timeout
		
		var delayed_damage : int = int(shot_data.damage * delay_power)
		var delayed_radius : float = shot_data.radius * delay_radius
		
		# Find angle that doesn't conflict with any used angles
		var angle : float
		var max_attempts := 100  # Prevent infinite loop
		var attempts := 0
		var valid := false
		
		while not valid and attempts < max_attempts:
			angle = randf() * TAU
			valid = true
			# Check against all previously used angles
			for used_angle in used_angles:
				if local_angle_difference(angle, used_angle) < min_angle_distance:
					valid = false
					break
			attempts += 1
		
		used_angles.append(angle)
		var distance : float = (shot_data.radius + delayed_radius) * randf_range(1.0, 1.3)
		var offset : Vector2 = Vector2(cos(angle), sin(angle)) * distance
		var shot_pos : Vector2 = shot_data.position + offset
		
		var delayed_shot = ShotData.new()
		delayed_shot.position = shot_pos
		delayed_shot.damage = delayed_damage
		delayed_shot.radius = delayed_radius
		
		player._execute_shot(delayed_shot)

func local_angle_difference(angle1: float, angle2: float):
	var diff = abs(angle1 - angle2)
	return min(diff, TAU - diff) # shortest distance between angles
