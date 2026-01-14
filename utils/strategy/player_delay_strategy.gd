class_name PlayerDelayStrategy extends PlayerBaseStrategy

var delay_repeats := 4
var delay_power := 0.5 # % of original shot power
var delay_radius := 0.5 # % of original shot radius
var delay_interval := 0.1

func apply_upgrade():
	print("Delay upgrade")

func on_shot_fired(player: CharacterBody2D, shot_data: ShotData):
	var last_angle := 0.0
	var min_angle_distance := PI * 0.5  # 90 degrees minimum between shots
		
	for i in range(delay_repeats):
		await player.get_tree().create_timer(delay_interval).timeout
		
		var delayed_damage : int = int(shot_data.damage * delay_power)
		var delayed_radius : float = shot_data.radius * delay_radius
		
		# Random offset position around original shot
		var angle : float = randf() * TAU
		# Random angle avoiding previous shot
		while local_angle_difference(angle, last_angle) < min_angle_distance:
				angle = randf() * TAU
		last_angle = angle
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
