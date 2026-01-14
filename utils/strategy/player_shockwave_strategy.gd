class_name PlayerShockwaveStrategy extends PlayerBaseStrategy

var shockwave_radius_multiplier := 3.0  # Expands to 3x original shot radius
var shockwave_damage_multiplier := 0.5  # 50% of original damage
var shockwave_duration := 0.5
func apply_upgrade():
	pass
	
func on_shot_fired(player: CharacterBody2D, shot_data: ShotData):
	var target_radius = shot_data.radius * shockwave_radius_multiplier
	var shockwave_damage = int(shot_data.damage * shockwave_damage_multiplier)
	
	player._execute_sweep_shot(shot_data, target_radius, shockwave_damage)
