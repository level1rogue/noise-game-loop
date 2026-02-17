extends CharacterBody2D

@export var deathParticles : PackedScene
@export var flicker_speed : float = 0.0
@export var noise_frequency : float = 0.3
@export var time_offset : float = 0.0

var MIN_SPEED := 0.01
var max_speed := 0.5

var SPEED := 0.0
var DIRECTION := Vector2(0,0)
var rotation_value := 0.0
var skew_value := 0.0

var MAX_HEALTH := 10.0
var health = MAX_HEALTH

var go_go_go := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initiate_me()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if go_go_go:
		velocity += DIRECTION * SPEED * delta
		scale += Vector2(0.03, 0.03) * SPEED * delta
		rotation += rotation_value
		skew += skew_value
		
		# Pulsing glow effect
		#var pulse = sin(get_tree().get_frame() * 0.05) * 0.1
		var updated_material = $ColorRect/TextureRect.material.duplicate()
		# enemy opacity dependent on health
		#updated_material.set_shader_parameter("global_opacity", health/MAX_HEALTH + pulse)
		# glow intensity dependent on health
		updated_material.set_shader_parameter("glow_intensity", 0.0 if health <= MAX_HEALTH/2 else 4.5)
		$ColorRect/TextureRect.material = updated_material
		move_and_slide()

func initiate_me():
	SPEED = randf_range(MIN_SPEED, max_speed)
	DIRECTION = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	position = get_viewport_rect().size / 2 + DIRECTION * randi_range(20, get_viewport_rect().size.x / 20)
	rotate(randf_range(0.0, PI))
	var scale_val = randf_range(1.3, 1.8)
	scale = Vector2(scale_val, scale_val)
	rotation_value = randf_range(-0.002, 0.002)
	#skew_value = randf_range(-0.002, 0.002)
	#skew = randf_range(0.0, 0.3)
	
	#var noise_color_value = randf() 
	#$ColorRect.color = Color(noise_color_value, noise_color_value, noise_color_value, 1.0)
	
 	# All enemies share world noise, but with offset timing for variation
	var shader_material = $ColorRect/TextureRect.material.duplicate() as ShaderMaterial
	#material.set_shader_parameter("time_offset", time_offset)
	#material.set_shader_parameter("flicker_speed", flicker_speed)
	$ColorRect/TextureRect.material = shader_material
	
	go_go_go = true

func take_damage(amount: int, hit_position: Vector2 = global_position, damage_effects: Array = ["shake"]):
	health -= amount
	$ColorRect.color.a = health / MAX_HEALTH
	
	for effect in damage_effects:
		var knockback_direction = (global_position - hit_position).normalized()
		match effect:
			"shake":
				_apply_shake()
			"rumble":
				#_apply_rumble(knockback_direction)
				pass
			"knockback":
				# add knockback effect
				_apply_knockback(knockback_direction)
				#pass

	
	skew_value = randf_range(-0.008, 0.008)
	#var skew_amount = randf_range(0.1, 0.3) #should transition not happen instantly
	#var tween = create_tween()
	#tween.set_trans(Tween.TRANS_QUAD)
	#tween.set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "skew", skew_amount, 0.1)  # Skew to 0.3 in 0.1 seconds
	
	if health <= 0:
		die()
	
func _apply_knockback(direction: Vector2, force: float = 10.0, height: float = 10.0, duration: float = 0.8):
	var original_velocity = velocity
	var original_z = z_index
	var original_pos = global_position
	var pushed_pos = original_pos + direction * force
	velocity += direction * force
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Increase z_index to appear "higher"
	tween.tween_property(self, "z_index", original_z + int(height), duration * 0.3)
	tween.parallel().tween_property(self, "global_position", pushed_pos, duration * 0.3)
	
	# Return
	tween.tween_property(self, "z_index", original_z, duration * 0.3)
	tween.parallel().tween_property(self, "global_position", original_pos + direction * force * (duration * 0.7), duration * 0.7)

	tween.tween_method(func(weight):
		velocity = original_velocity.lerp(velocity, 1.0 - weight),
		0.0, 1.0, duration * 1.5
		)

func _apply_shake():
	var tween = create_tween()
	tween.tween_property(self, "skew", 0.2, 0.05)
	tween.tween_property(self, "skew", 0.0, 0.15)

func die():
	# Create multiple shards from enemy
	var shard_count = randi_range(2, 3)
	for i in range(shard_count):
		var shard = await create_shard()
		get_tree().current_scene.add_child(shard)
		shard.global_position = global_position + Vector2(randf_range(-10, 10), randf_range(-10, 10))
		
		# Random velocity outward
		#var angle = randf() * TAU
		#var velocity = randf_range(150, 350)
		shard.linear_velocity = DIRECTION * randi_range(10, 40)
		shard.angular_velocity = randf_range(-15, 15)
			
	queue_free()

func create_shard() -> RigidBody2D:
	var shard = RigidBody2D.new()
	shard.gravity_scale = 0.0
	
	# Random shard size
	var shard_size = Vector2(randf_range(9, 18), randf_range(9, 18))
	
	# Background color rect
	var rect = ColorRect.new()
	rect.size = shard_size
	rect.position = -shard_size / 2
	rect.color = $ColorRect.color
	shard.add_child(rect)
	
	# Noise texture with shader
	var texture_rect = TextureRect.new()
	var new_material = $ColorRect/TextureRect.material.duplicate()
	new_material.set_shader_parameter("global_opacity", 0.5)
	texture_rect.material = new_material
	texture_rect.texture = CanvasTexture.new()
	texture_rect.size = shard_size
	texture_rect.position = -shard_size / 2
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	texture_rect.stretch_mode = TextureRect.STRETCH_SCALE
	shard.add_child(texture_rect)
	
	# Fade out and delete - fade the parent shard instead
	await get_tree().process_frame  # Wait for shard to be added to tree
	var tween = shard.create_tween()
	var random_duration = randf_range(0.1, 1.5)
	tween.tween_property(shard, "modulate:a", 0.0, random_duration).set_delay(0.3) # TODO: Use material's global_opacity instead
	tween.tween_callback(shard.queue_free)
	
	return shard
