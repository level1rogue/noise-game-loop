class_name PlayerShockwaveStrategy extends PlayerBaseStrategy

var shockwave_radius_multiplier := 3.0  # Expands to 3x original shot radius
var shockwave_damage_multiplier := 0.5  # 50% of original damage
var shockwave_duration := 0.5
var ring_width := 10.0

func apply_upgrade():
	pass
	
func on_shot_fired(player: CharacterBody2D, shot_data: ShotData):
	var target_radius = shot_data.radius * shockwave_radius_multiplier
	var shockwave_damage = int(shot_data.damage * shockwave_damage_multiplier)
	
	# Spawn visual effect
	var effect = player.shockwave_effect.instantiate()
	effect.global_position = shot_data.position
	effect.setup(shot_data.radius, target_radius, shockwave_duration, ring_width)
	player.get_parent().add_child(effect)
	
	_apply_damage(player, shot_data.position, shot_data.radius, target_radius, shockwave_damage)
		
func _apply_damage(player: CharacterBody2D, position: Vector2, start_radius: float, end_radius: float, damage: int):
	var hit_enemies: Array = []
	var duration := shockwave_duration
	var elapsed := 0.0
	
	while elapsed < duration:
		await player.get_tree().process_frame
		elapsed += player.get_process_delta_time()
		
		var progress = elapsed / duration
		var current_radius = lerp(start_radius, end_radius, progress)
		
		# Check for enemies
		var space_state = player.get_world_2d().direct_space_state
		var query = PhysicsShapeQueryParameters2D.new()
		var shape = CircleShape2D.new()
		shape.radius = current_radius + ring_width / 2
		query.shape = shape
		query.transform = Transform2D(0, position)
		query.collision_mask = 2
		
		var results = space_state.intersect_shape(query)
		
		for result in results:
			var body = result.collider
			var distance = position.distance_to(body.global_position)
			if distance >= current_radius - ring_width / 2 and distance <= current_radius + ring_width / 2:
				if not body in hit_enemies:
					hit_enemies.append(body)
					if body.has_method("take_damage"):
						body.take_damage(damage, position, ["knockback"])

					
		
		
